#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
VPN_PORT=51820
VPN_NETWORK="10.66.66.0/24"
VPN_IP="10.66.66.1"
MTU=1420
DNS_SERVERS="1.1.1.1, 1.0.0.1, 8.8.8.8"
WG_CONFIG_DIR="/etc/wireguard"
WG_INTERFACE="wg0"

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print section headers
print_header() {
    echo ""
    print_message "$PURPLE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$PURPLE" "  $1"
    print_message "$PURPLE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_message "$RED" "❌ This script must be run as root"
   print_message "$YELLOW" "   Please run: sudo $0"
   exit 1
fi

print_header "🚀 VPN Ultra-Performant - Installation WireGuard"

# Detect OS
print_message "$BLUE" "🔍 Detecting operating system..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
    print_message "$GREEN" "✓ Detected: $PRETTY_NAME"
else
    print_message "$RED" "❌ Cannot detect OS. /etc/os-release not found"
    exit 1
fi

# Update package lists
print_header "📦 Updating package lists"
apt-get update -qq

# Install WireGuard and dependencies
print_header "📥 Installing WireGuard and dependencies"
print_message "$BLUE" "Installing: wireguard, wireguard-tools, qrencode, iptables..."

DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    wireguard \
    wireguard-tools \
    qrencode \
    iptables \
    iptables-persistent \
    net-tools \
    resolvconf > /dev/null 2>&1

print_message "$GREEN" "✓ WireGuard and dependencies installed successfully"

# Create WireGuard directory structure
print_header "📁 Creating directory structure"
mkdir -p "$WG_CONFIG_DIR/clients"
mkdir -p "$WG_CONFIG_DIR/keys"
chmod 700 "$WG_CONFIG_DIR"
chmod 700 "$WG_CONFIG_DIR/keys"
print_message "$GREEN" "✓ Directory structure created"

# Generate server keys
print_header "🔐 Generating server keys"
SERVER_PRIVATE_KEY=$(wg genkey)
SERVER_PUBLIC_KEY=$(echo "$SERVER_PRIVATE_KEY" | wg pubkey)

echo "$SERVER_PRIVATE_KEY" > "$WG_CONFIG_DIR/keys/server_private.key"
echo "$SERVER_PUBLIC_KEY" > "$WG_CONFIG_DIR/keys/server_public.key"
chmod 600 "$WG_CONFIG_DIR/keys/server_private.key"
chmod 600 "$WG_CONFIG_DIR/keys/server_public.key"

print_message "$GREEN" "✓ Server keys generated"
print_message "$YELLOW" "   Private key saved to: $WG_CONFIG_DIR/keys/server_private.key"
print_message "$YELLOW" "   Public key saved to: $WG_CONFIG_DIR/keys/server_public.key"

# Detect public IP address
print_header "🌐 Detecting public IP address"
PUBLIC_IP=$(curl -4 -s https://ifconfig.me || curl -4 -s https://icanhazip.com || echo "UNKNOWN")
if [ "$PUBLIC_IP" = "UNKNOWN" ]; then
    print_message "$YELLOW" "⚠️  Could not auto-detect public IP"
    read -p "   Please enter your server's public IP address: " PUBLIC_IP
fi
print_message "$GREEN" "✓ Public IP: $PUBLIC_IP"

# Detect main network interface
print_header "🔌 Detecting network interface"
MAIN_INTERFACE=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
if [ -z "$MAIN_INTERFACE" ]; then
    print_message "$YELLOW" "⚠️  Could not auto-detect network interface"
    print_message "$BLUE" "   Available interfaces:"
    ip -o link show | awk -F': ' '{print "   - "$2}'
    read -p "   Please enter your main network interface: " MAIN_INTERFACE
fi
print_message "$GREEN" "✓ Network interface: $MAIN_INTERFACE"

# Create WireGuard server configuration
print_header "⚙️  Creating WireGuard configuration"
cat > "$WG_CONFIG_DIR/$WG_INTERFACE.conf" <<EOF
[Interface]
Address = $VPN_IP/24
ListenPort = $VPN_PORT
PrivateKey = $SERVER_PRIVATE_KEY
MTU = $MTU

# NAT and forwarding rules
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $MAIN_INTERFACE -j MASQUERADE; ip6tables -A FORWARD -i %i -j ACCEPT; ip6tables -A FORWARD -o %i -j ACCEPT; ip6tables -t nat -A POSTROUTING -o $MAIN_INTERFACE -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $MAIN_INTERFACE -j MASQUERADE; ip6tables -D FORWARD -i %i -j ACCEPT; ip6tables -D FORWARD -o %i -j ACCEPT; ip6tables -t nat -D POSTROUTING -o $MAIN_INTERFACE -j MASQUERADE

# Clients will be added below
EOF

chmod 600 "$WG_CONFIG_DIR/$WG_INTERFACE.conf"
print_message "$GREEN" "✓ WireGuard configuration created at $WG_CONFIG_DIR/$WG_INTERFACE.conf"

# Enable IP forwarding
print_header "🔄 Enabling IP forwarding"
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/' /etc/sysctl.conf

# Add if not exists
grep -q "net.ipv4.ip_forward=1" /etc/sysctl.conf || echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
grep -q "net.ipv6.conf.all.forwarding=1" /etc/sysctl.conf || echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf

sysctl -p > /dev/null 2>&1
print_message "$GREEN" "✓ IP forwarding enabled (IPv4 and IPv6)"

# Configure UFW if installed
if command -v ufw &> /dev/null; then
    print_header "🛡️  Configuring UFW firewall"
    ufw allow "$VPN_PORT/udp" > /dev/null 2>&1
    print_message "$GREEN" "✓ UFW rule added for port $VPN_PORT/udp"
fi

# Start and enable WireGuard service
print_header "🚦 Starting WireGuard service"
systemctl enable wg-quick@$WG_INTERFACE > /dev/null 2>&1
systemctl start wg-quick@$WG_INTERFACE

if systemctl is-active --quiet wg-quick@$WG_INTERFACE; then
    print_message "$GREEN" "✓ WireGuard service started and enabled"
else
    print_message "$RED" "❌ Failed to start WireGuard service"
    systemctl status wg-quick@$WG_INTERFACE
    exit 1
fi

# Display connection information
print_header "🎉 Installation Complete!"

print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_message "$GREEN" "VPN Server Information:"
print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_message "$BLUE" "📍 Server Public IP: $PUBLIC_IP"
print_message "$BLUE" "🔌 Port: $VPN_PORT (UDP)"
print_message "$BLUE" "🌐 VPN Network: $VPN_NETWORK"
print_message "$BLUE" "🔐 Server Public Key:"
echo "   $SERVER_PUBLIC_KEY"
echo ""
print_message "$YELLOW" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_message "$YELLOW" "Next Steps:"
print_message "$YELLOW" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_message "$GREEN" "1. Add your first client:"
print_message "$WHITE" "   sudo ./add-client.sh client-name"
echo ""
print_message "$GREEN" "2. Check server status:"
print_message "$WHITE" "   sudo wg show"
echo ""
print_message "$GREEN" "3. View logs:"
print_message "$WHITE" "   sudo journalctl -u wg-quick@$WG_INTERFACE -f"
echo ""
print_message "$GREEN" "✅ Your VPN server is ready!"
echo ""
