#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

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

print_header "🌍 VPN Ultra-Performant - Global Deployment"

# Configuration - Define your regions and servers
declare -A REGIONS
REGIONS[usa]="user@vpn-usa.example.com"
REGIONS[europe]="user@vpn-europe.example.com"
REGIONS[asia]="user@vpn-asia.example.com"
REGIONS[oceania]="user@vpn-oceania.example.com"

# Files to deploy
SCRIPTS=(
    "install-vpn-server.sh"
    "add-client.sh"
    "vpn-manager.py"
)

# Check if files exist
print_message "$BLUE" "🔍 Checking files..."
for script in "${SCRIPTS[@]}"; do
    if [ ! -f "$script" ]; then
        print_message "$RED" "❌ File not found: $script"
        exit 1
    fi
done
print_message "$GREEN" "✓ All files found"

# Deployment function
deploy_to_server() {
    local region=$1
    local server=$2
    
    print_header "📡 Deploying to $region ($server)"
    
    # Create remote directory
    print_message "$BLUE" "Creating remote directory..."
    ssh "$server" "mkdir -p ~/vpn-deployment" || {
        print_message "$RED" "❌ Failed to create directory on $server"
        return 1
    }
    
    # Copy scripts
    print_message "$BLUE" "Copying scripts..."
    for script in "${SCRIPTS[@]}"; do
        scp "$script" "$server:~/vpn-deployment/" || {
            print_message "$RED" "❌ Failed to copy $script to $server"
            return 1
        }
    done
    
    # Make scripts executable
    print_message "$BLUE" "Making scripts executable..."
    ssh "$server" "chmod +x ~/vpn-deployment/*.sh" || {
        print_message "$RED" "❌ Failed to set permissions on $server"
        return 1
    }
    
    # Run installation
    print_message "$BLUE" "Running installation script..."
    ssh "$server" "cd ~/vpn-deployment && sudo ./install-vpn-server.sh" || {
        print_message "$RED" "❌ Installation failed on $server"
        return 1
    }
    
    print_message "$GREEN" "✅ Deployment to $region completed successfully!"
    return 0
}

# Main deployment loop
DEPLOYED=0
FAILED=0

print_message "$YELLOW" "Starting deployment to ${#REGIONS[@]} regions..."
echo ""

for region in "${!REGIONS[@]}"; do
    server="${REGIONS[$region]}"
    
    if deploy_to_server "$region" "$server"; then
        ((DEPLOYED++))
    else
        ((FAILED++))
    fi
    
    echo ""
done

# Summary
print_header "📊 Deployment Summary"

print_message "$GREEN" "✅ Successfully deployed: $DEPLOYED regions"
if [ $FAILED -gt 0 ]; then
    print_message "$RED" "❌ Failed deployments: $FAILED regions"
fi

echo ""

if [ $FAILED -eq 0 ]; then
    print_message "$GREEN" "🎉 All deployments completed successfully!"
    print_message "$YELLOW" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$YELLOW" "Next Steps:"
    print_message "$YELLOW" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    print_message "$BLUE" "1. Test each server connection"
    print_message "$BLUE" "2. Add clients to each region"
    print_message "$BLUE" "3. Set up load balancing (optional)"
    print_message "$BLUE" "4. Configure monitoring"
    echo ""
else
    print_message "$RED" "⚠️  Some deployments failed. Please check the logs above."
    exit 1
fi
