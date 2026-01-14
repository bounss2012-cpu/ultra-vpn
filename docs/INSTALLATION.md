# Installation Guide

## VPN Ultra-Performant - WireGuard Installation

This guide will walk you through the complete installation process of the VPN Ultra-Performant solution.

## 📋 Prerequisites

### System Requirements

- **Operating System**: 
  - Ubuntu 20.04 LTS or later
  - Debian 11 or later
  - Other Linux distributions with WireGuard support
  
- **Access Requirements**:
  - Root or sudo access
  - Active internet connection
  - SSH access (for remote installation)

### Network Requirements

- **Port Requirements**:
  - UDP port 51820 (default WireGuard port) - must be open and forwarded
  - TCP port 8080 (for web management interface - optional)

- **Firewall**: Ensure your firewall allows incoming UDP traffic on port 51820

### Hardware Requirements

- **Minimum**:
  - 1 CPU core
  - 512 MB RAM
  - 5 GB disk space
  
- **Recommended**:
  - 2+ CPU cores
  - 1+ GB RAM
  - 10+ GB disk space

## 🚀 Quick Installation

### Step 1: Download the Scripts

Clone the repository or download the scripts:

```bash
git clone https://github.com/bounss2012-cpu/ultra-vpn.git
cd ultra-vpn
```

Or download directly:

```bash
wget https://raw.githubusercontent.com/bounss2012-cpu/ultra-vpn/main/install-vpn-server.sh
wget https://raw.githubusercontent.com/bounss2012-cpu/ultra-vpn/main/add-client.sh
wget https://raw.githubusercontent.com/bounss2012-cpu/ultra-vpn/main/vpn-manager.py
```

### Step 2: Set Execute Permissions

```bash
chmod +x install-vpn-server.sh
chmod +x add-client.sh
chmod +x deploy-global.sh
```

### Step 3: Run the Installation

```bash
sudo ./install-vpn-server.sh
```

The script will:
- ✅ Detect your operating system
- ✅ Install WireGuard and dependencies
- ✅ Generate server keys
- ✅ Configure IP forwarding
- ✅ Set up firewall rules
- ✅ Start the WireGuard service

### Step 4: Verify Installation

Check if WireGuard is running:

```bash
sudo systemctl status wg-quick@wg0
```

View WireGuard interface status:

```bash
sudo wg show
```

## 👤 Adding Your First Client

### Using the Script

```bash
sudo ./add-client.sh john-laptop
```

The script will:
- Generate client keys
- Assign an IP address
- Create configuration file
- Generate a QR code for mobile devices
- Add the peer to the server

### Configuration File Location

Client configurations are saved in:
```
/etc/wireguard/clients/<client-name>.conf
```

### Download the Configuration

Copy the configuration file to your local machine:

```bash
sudo cat /etc/wireguard/clients/john-laptop.conf
```

## 🌐 Web Management Interface (Optional)

### Install Python Dependencies

```bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip
pip3 install flask
```

### Run the Web Interface

```bash
sudo python3 vpn-manager.py
```

Access the dashboard at: `http://your-server-ip:8080`

### Run as a System Service

Create a systemd service file:

```bash
sudo nano /etc/systemd/system/vpn-manager.service
```

Add the following content:

```ini
[Unit]
Description=VPN Manager Web Interface
After=network.target wg-quick@wg0.service

[Service]
Type=simple
User=root
WorkingDirectory=/path/to/ultra-vpn
ExecStart=/usr/bin/python3 /path/to/ultra-vpn/vpn-manager.py
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable vpn-manager
sudo systemctl start vpn-manager
```

## 🐳 Docker Installation (Alternative)

### Using Docker Compose

```bash
# Pull the required images
docker-compose pull

# Start all VPN servers
docker-compose up -d

# Check status
docker-compose ps
```

### Individual Region Deployment

Start a specific region:

```bash
docker-compose up -d vpn-usa
docker-compose up -d vpn-europe
docker-compose up -d vpn-asia
```

## 🔧 Firewall Configuration

### UFW (Ubuntu Firewall)

```bash
sudo ufw allow 51820/udp
sudo ufw allow 8080/tcp  # For web interface
sudo ufw reload
```

### iptables

```bash
sudo iptables -A INPUT -p udp --dport 51820 -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/rules.v4
```

### firewalld (RHEL/CentOS)

```bash
sudo firewall-cmd --permanent --add-port=51820/udp
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

## 🔍 Verification Steps

### 1. Check Server Status

```bash
sudo systemctl status wg-quick@wg0
```

Expected output: `active (running)`

### 2. View WireGuard Interface

```bash
sudo wg show wg0
```

Should display server public key and listening port.

### 3. Check IP Forwarding

```bash
sysctl net.ipv4.ip_forward
```

Should return: `net.ipv4.ip_forward = 1`

### 4. Test Client Connection

After adding a client and connecting:

```bash
sudo wg show wg0
```

Should show the connected peer with a recent handshake time.

## 🐛 Troubleshooting

### WireGuard Service Won't Start

**Check logs:**
```bash
sudo journalctl -u wg-quick@wg0 -n 50 --no-pager
```

**Common issues:**
- Port already in use
- Invalid configuration syntax
- Missing kernel modules

**Solution:**
```bash
# Check if port is in use
sudo netstat -tulpn | grep 51820

# Reload kernel modules
sudo modprobe wireguard

# Restart service
sudo systemctl restart wg-quick@wg0
```

### Client Can't Connect

**Check server firewall:**
```bash
sudo ufw status
```

**Check server is listening:**
```bash
sudo ss -ulpn | grep 51820
```

**Verify client configuration:**
- Correct server IP/endpoint
- Matching keys
- Correct AllowedIPs

### No Internet Through VPN

**Check IP forwarding:**
```bash
cat /proc/sys/net/ipv4/ip_forward
```

Should output `1`. If not:
```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

**Check NAT rules:**
```bash
sudo iptables -t nat -L POSTROUTING -v
```

Should show MASQUERADE rule.

### DNS Not Working

**Check DNS in client config:**
```bash
grep DNS /etc/wireguard/clients/client-name.conf
```

**Test DNS resolution:**
```bash
nslookup google.com 1.1.1.1
```

## 📊 Monitoring

### View Active Connections

```bash
sudo wg show wg0
```

### Monitor Logs in Real-Time

```bash
sudo journalctl -u wg-quick@wg0 -f
```

### Check Bandwidth Usage

```bash
sudo wg show wg0 transfer
```

## 🔄 Updates and Maintenance

### Update WireGuard

```bash
sudo apt-get update
sudo apt-get upgrade wireguard wireguard-tools
sudo systemctl restart wg-quick@wg0
```

### Backup Configuration

```bash
sudo tar -czf wireguard-backup-$(date +%Y%m%d).tar.gz /etc/wireguard/
```

### Restore Configuration

```bash
sudo tar -xzf wireguard-backup-YYYYMMDD.tar.gz -C /
sudo systemctl restart wg-quick@wg0
```

## 📞 Support

- **GitHub Issues**: https://github.com/bounss2012-cpu/ultra-vpn/issues
- **Documentation**: https://github.com/bounss2012-cpu/ultra-vpn/docs
- **WireGuard Official**: https://www.wireguard.com/

## ✅ Post-Installation Checklist

- [ ] WireGuard service is running
- [ ] Server public key is accessible
- [ ] Firewall rules are configured
- [ ] IP forwarding is enabled
- [ ] First client is added and tested
- [ ] Web interface is accessible (if installed)
- [ ] Backup of configuration is created
- [ ] Documentation is reviewed

## 🎉 Success!

Your VPN server is now ready to use! Add clients using the `add-client.sh` script and start enjoying secure, high-performance VPN connections.

For advanced deployment scenarios, see [DEPLOYMENT.md](DEPLOYMENT.md).
For security best practices, see [SECURITY.md](SECURITY.md).
