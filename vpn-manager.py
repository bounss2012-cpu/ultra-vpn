#!/usr/bin/env python3
"""
VPN Manager - Flask Web Application for WireGuard Management
Ultra-Performant VPN Solution
"""

import os
import re
import subprocess
import secrets
from datetime import datetime
from flask import Flask, render_template, jsonify, request, send_file

app = Flask(__name__)
app.secret_key = secrets.token_hex(32)

# Configuration
WG_CONFIG_DIR = "/etc/wireguard"
WG_INTERFACE = "wg0"
CLIENTS_DIR = f"{WG_CONFIG_DIR}/clients"


class VPNManager:
    """WireGuard VPN Management Class"""

    @staticmethod
    def get_server_status():
        """Check if WireGuard service is running"""
        try:
            result = subprocess.run(
                ["systemctl", "is-active", f"wg-quick@{WG_INTERFACE}"],
                capture_output=True,
                text=True,
                timeout=5
            )
            return result.stdout.strip() == "active"
        except Exception as e:
            app.logger.error(f"Error checking server status: {e}")
            return False

    @staticmethod
    def get_clients():
        """Get list of all clients with their connection status"""
        clients = []
        
        if not os.path.exists(CLIENTS_DIR):
            return clients

        try:
            # Get WireGuard status
            wg_output = subprocess.run(
                ["wg", "show", WG_INTERFACE, "dump"],
                capture_output=True,
                text=True,
                timeout=5
            ).stdout

            # Parse active connections
            connected_ips = set()
            for line in wg_output.strip().split('\n')[1:]:  # Skip header
                parts = line.split('\t')
                if len(parts) >= 4 and parts[3] != '0':  # Has recent handshake
                    allowed_ips = parts[4] if len(parts) > 4 else ""
                    ip_match = re.search(r'(\d+\.\d+\.\d+\.\d+)', allowed_ips)
                    if ip_match:
                        connected_ips.add(ip_match.group(1))

            # List all client configurations
            for filename in sorted(os.listdir(CLIENTS_DIR)):
                if filename.endswith('.conf'):
                    client_name = filename[:-5]  # Remove .conf extension
                    config_path = os.path.join(CLIENTS_DIR, filename)
                    
                    # Read client configuration to get IP
                    with open(config_path, 'r') as f:
                        config_content = f.read()
                        ip_match = re.search(r'Address\s*=\s*(\d+\.\d+\.\d+\.\d+)', config_content)
                        client_ip = ip_match.group(1) if ip_match else "Unknown"
                    
                    clients.append({
                        'name': client_name,
                        'ip': client_ip,
                        'connected': client_ip in connected_ips,
                        'config_file': config_path
                    })

        except Exception as e:
            app.logger.error(f"Error getting clients: {e}")

        return clients

    @staticmethod
    def add_client(name):
        """Add a new VPN client"""
        if not name:
            return False, "Client name is required"

        # Validate client name
        if not re.match(r'^[a-zA-Z0-9-]+$', name):
            return False, "Client name must contain only letters, numbers, and hyphens"

        # Check if client already exists
        if os.path.exists(f"{CLIENTS_DIR}/{name}.conf"):
            return False, f"Client '{name}' already exists"

        try:
            # Call add-client.sh script
            result = subprocess.run(
                ["./add-client.sh", name],
                capture_output=True,
                text=True,
                timeout=30
            )

            if result.returncode == 0:
                return True, f"Client '{name}' added successfully"
            else:
                return False, f"Failed to add client: {result.stderr}"

        except Exception as e:
            app.logger.error(f"Error adding client: {e}")
            return False, str(e)

    @staticmethod
    def remove_client(name):
        """Remove a VPN client"""
        if not name:
            return False, "Client name is required"

        config_file = f"{CLIENTS_DIR}/{name}.conf"
        
        if not os.path.exists(config_file):
            return False, f"Client '{name}' not found"

        try:
            # Read client public key from server config
            with open(f"{WG_CONFIG_DIR}/{WG_INTERFACE}.conf", 'r') as f:
                config_content = f.read()

            # Remove client section from server config
            # Find the client section and remove it
            pattern = rf'# Client: {re.escape(name)}\n\[Peer\][^\[]*'
            new_config = re.sub(pattern, '', config_content, flags=re.MULTILINE)

            # Write updated config
            with open(f"{WG_CONFIG_DIR}/{WG_INTERFACE}.conf", 'w') as f:
                f.write(new_config)

            # Remove client configuration file
            os.remove(config_file)

            # Remove client keys directory
            keys_dir = f"{WG_CONFIG_DIR}/keys/{name}"
            if os.path.exists(keys_dir):
                subprocess.run(["rm", "-rf", keys_dir], timeout=5)

            # Restart WireGuard service
            subprocess.run(
                ["systemctl", "restart", f"wg-quick@{WG_INTERFACE}"],
                timeout=10
            )

            return True, f"Client '{name}' removed successfully"

        except Exception as e:
            app.logger.error(f"Error removing client: {e}")
            return False, str(e)

    @staticmethod
    def get_bandwidth_stats():
        """Get bandwidth statistics for all clients"""
        stats = {
            'total_clients': 0,
            'connected_clients': 0,
            'total_rx': 0,
            'total_tx': 0
        }

        try:
            # Get WireGuard statistics
            wg_output = subprocess.run(
                ["wg", "show", WG_INTERFACE, "transfer"],
                capture_output=True,
                text=True,
                timeout=5
            ).stdout

            for line in wg_output.strip().split('\n'):
                parts = line.split('\t')
                if len(parts) >= 3:
                    stats['total_rx'] += int(parts[1])
                    stats['total_tx'] += int(parts[2])

            # Get client counts
            clients = VPNManager.get_clients()
            stats['total_clients'] = len(clients)
            stats['connected_clients'] = sum(1 for c in clients if c['connected'])

        except Exception as e:
            app.logger.error(f"Error getting bandwidth stats: {e}")

        return stats


# Routes

@app.route('/')
def index():
    """Render dashboard"""
    return render_template('dashboard.html')


@app.route('/api/status')
def api_status():
    """Get server status"""
    try:
        is_active = VPNManager.get_server_status()
        return jsonify({
            'success': True,
            'active': is_active,
            'interface': WG_INTERFACE,
            'timestamp': datetime.now().isoformat()
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@app.route('/api/clients')
def api_clients():
    """Get list of all clients"""
    try:
        clients = VPNManager.get_clients()
        return jsonify({
            'success': True,
            'clients': clients
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@app.route('/api/clients/add', methods=['POST'])
def api_add_client():
    """Add a new client"""
    try:
        data = request.get_json()
        if not data or 'name' not in data:
            return jsonify({
                'success': False,
                'error': 'Client name is required'
            }), 400

        success, message = VPNManager.add_client(data['name'])
        
        if success:
            return jsonify({
                'success': True,
                'message': message
            })
        else:
            return jsonify({
                'success': False,
                'error': message
            }), 400

    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@app.route('/api/clients/remove', methods=['POST'])
def api_remove_client():
    """Remove a client"""
    try:
        data = request.get_json()
        if not data or 'name' not in data:
            return jsonify({
                'success': False,
                'error': 'Client name is required'
            }), 400

        success, message = VPNManager.remove_client(data['name'])
        
        if success:
            return jsonify({
                'success': True,
                'message': message
            })
        else:
            return jsonify({
                'success': False,
                'error': message
            }), 400

    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@app.route('/api/download/<name>')
def api_download_config(name):
    """Download client configuration file"""
    try:
        # Validate client name
        if not re.match(r'^[a-zA-Z0-9-]+$', name):
            return jsonify({
                'success': False,
                'error': 'Invalid client name'
            }), 400

        config_file = f"{CLIENTS_DIR}/{name}.conf"
        
        if not os.path.exists(config_file):
            return jsonify({
                'success': False,
                'error': f"Client '{name}' not found"
            }), 404

        return send_file(
            config_file,
            as_attachment=True,
            download_name=f"{name}.conf",
            mimetype='text/plain'
        )

    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


@app.route('/api/stats')
def api_stats():
    """Get bandwidth statistics"""
    try:
        stats = VPNManager.get_bandwidth_stats()
        return jsonify({
            'success': True,
            'stats': stats
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


if __name__ == '__main__':
    # Check if running as root or with proper permissions
    if os.geteuid() != 0:
        print("⚠️  Warning: This application requires root privileges to manage WireGuard")
        print("   Run with: sudo python3 vpn-manager.py")
    
    # Create clients directory if it doesn't exist
    os.makedirs(CLIENTS_DIR, exist_ok=True)
    
    # Run Flask app
    app.run(host='0.0.0.0', port=8080, debug=False)
