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
WG_CONFIG_DIR="/etc/wireguard"
WG_INTERFACE="wg0"
VPN_PORT=51820
MTU=1420
DNS_SERVERS="1.1.1.1, 1.0.0.1"
CLIENTS_DIR="$WG_CONFIG_DIR/clients"

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
   print_message "$YELLOW" "   Please run: sudo $0 <client-name>"
   exit 1
fi

# Check if client name is provided
if [ -z "$1" ]; then
    print_message "$RED" "❌ Client name is required"
    print_message "$YELLOW" "   Usage: sudo $0 <client-name>"
    print_message "$YELLOW" "   Example: sudo $0 john-laptop"
    exit 1
fi

CLIENT_NAME=$1

# Validate client name (alphanumeric and hyphens only)
if [[ ! "$CLIENT_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
    print_message "$RED" "❌ Invalid client name"
    print_message "$YELLOW" "   Client name must contain only letters, numbers, and hyphens"
    exit 1
fi

print_header "👤 Adding VPN Client: $CLIENT_NAME"

# Check if WireGuard is installed
if ! command -v wg &> /dev/null; then
    print_message "$RED" "❌ WireGuard is not installed"
    print_message "$YELLOW" "   Please run install-vpn-server.sh first"
    exit 1
fi

# Check if server is configured
if [ ! -f "$WG_CONFIG_DIR/$WG_INTERFACE.conf" ]; then
    print_message "$RED" "❌ WireGuard server configuration not found"
    print_message "$YELLOW" "   Please run install-vpn-server.sh first"
    exit 1
fi

# Check if client already exists
if [ -f "$CLIENTS_DIR/$CLIENT_NAME.conf" ]; then
    print_message "$RED" "❌ Client '$CLIENT_NAME' already exists"
    print_message "$YELLOW" "   Configuration file: $CLIENTS_DIR/$CLIENT_NAME.conf"
    exit 1
fi

# Get server public key and endpoint
SERVER_PUBLIC_KEY=$(cat "$WG_CONFIG_DIR/keys/server_public.key")
SERVER_ENDPOINT=$(curl -4 -s https://ifconfig.me || curl -4 -s https://icanhazip.com)

print_message "$BLUE" "🌐 Server endpoint: $SERVER_ENDPOINT:$VPN_PORT"

# Find next available IP address
print_header "🔍 Finding available IP address"

# Get all used IPs from server config
USED_IPS=$(grep -oP '(?<=AllowedIPs = )[0-9.]+' "$WG_CONFIG_DIR/$WG_INTERFACE.conf" 2>/dev/null | cut -d'/' -f1 || echo "")

# Find next available IP starting from 10.66.66.2
for i in {2..254}; do
    TEST_IP="10.66.66.$i"
    if ! echo "$USED_IPS" | grep -q "^$TEST_IP$"; then
        CLIENT_IP="$TEST_IP"
        break
    fi
done

if [ -z "$CLIENT_IP" ]; then
    print_message "$RED" "❌ No available IP addresses in the range 10.66.66.2-254"
    exit 1
fi

print_message "$GREEN" "✓ Assigned IP: $CLIENT_IP/32"

# Generate client keys
print_header "🔐 Generating client keys"
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo "$CLIENT_PRIVATE_KEY" | wg pubkey)
CLIENT_PRESHARED_KEY=$(wg genpsk)

print_message "$GREEN" "✓ Private key generated"
print_message "$GREEN" "✓ Public key generated"
print_message "$GREEN" "✓ Preshared key generated (double encryption)"

# Save keys
mkdir -p "$WG_CONFIG_DIR/keys/$CLIENT_NAME"
echo "$CLIENT_PRIVATE_KEY" > "$WG_CONFIG_DIR/keys/$CLIENT_NAME/private.key"
echo "$CLIENT_PUBLIC_KEY" > "$WG_CONFIG_DIR/keys/$CLIENT_NAME/public.key"
echo "$CLIENT_PRESHARED_KEY" > "$WG_CONFIG_DIR/keys/$CLIENT_NAME/preshared.key"
chmod 600 "$WG_CONFIG_DIR/keys/$CLIENT_NAME"/*.key

# Create client configuration
print_header "📝 Creating client configuration"

cat > "$CLIENTS_DIR/$CLIENT_NAME.conf" <<EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = $CLIENT_IP/32
DNS = $DNS_SERVERS
MTU = $MTU

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
PresharedKey = $CLIENT_PRESHARED_KEY
Endpoint = $SERVER_ENDPOINT:$VPN_PORT
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF

chmod 600 "$CLIENTS_DIR/$CLIENT_NAME.conf"
print_message "$GREEN" "✓ Client configuration created: $CLIENTS_DIR/$CLIENT_NAME.conf"

# Add peer to server configuration
print_header "🔗 Adding peer to server"

cat >> "$WG_CONFIG_DIR/$WG_INTERFACE.conf" <<EOF

# Client: $CLIENT_NAME
[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
PresharedKey = $CLIENT_PRESHARED_KEY
AllowedIPs = $CLIENT_IP/32
EOF

print_message "$GREEN" "✓ Peer added to server configuration"

# Restart WireGuard service
print_header "🔄 Restarting WireGuard service"
systemctl restart wg-quick@$WG_INTERFACE

if systemctl is-active --quiet wg-quick@$WG_INTERFACE; then
    print_message "$GREEN" "✓ WireGuard service restarted successfully"
else
    print_message "$RED" "❌ Failed to restart WireGuard service"
    exit 1
fi

# Generate QR code for mobile devices
print_header "📱 Generating QR code"

if command -v qrencode &> /dev/null; then
    print_message "$BLUE" "Scan this QR code with your WireGuard mobile app:"
    echo ""
    qrencode -t ansiutf8 < "$CLIENTS_DIR/$CLIENT_NAME.conf"
    echo ""
    print_message "$GREEN" "✓ QR code generated"
else
    print_message "$YELLOW" "⚠️  qrencode not installed, skipping QR code generation"
fi

# Display summary
print_header "🎉 Client Added Successfully!"

print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_message "$GREEN" "Client Information:"
print_message "$GREEN" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_message "$BLUE" "👤 Client Name: $CLIENT_NAME"
print_message "$BLUE" "📍 Client IP: $CLIENT_IP/32"
print_message "$BLUE" "📁 Configuration File: $CLIENTS_DIR/$CLIENT_NAME.conf"
echo ""
print_message "$YELLOW" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_message "$YELLOW" "Next Steps:"
print_message "$YELLOW" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_message "$GREEN" "1. Download the configuration file:"
print_message "$WHITE" "   $CLIENTS_DIR/$CLIENT_NAME.conf"
echo ""
print_message "$GREEN" "2. Import it into WireGuard client:"
print_message "$WHITE" "   - Desktop: Import the .conf file"
print_message "$WHITE" "   - Mobile: Scan the QR code above"
echo ""
print_message "$GREEN" "3. Connect and verify:"
print_message "$WHITE" "   - Enable the VPN connection"
print_message "$WHITE" "   - Check your IP: https://ifconfig.me"
echo ""
print_message "$GREEN" "4. View connected clients:"
print_message "$WHITE" "   sudo wg show"
echo ""
print_message "$GREEN" "✅ Client configuration complete!"
echo ""
