# Deployment Guide

## VPN Ultra-Performant - Production Deployment

This guide covers various deployment scenarios for the VPN Ultra-Performant solution, from single-server setups to global multi-region deployments.

## 📋 Table of Contents

- [Single Server Deployment](#single-server-deployment)
- [Multi-Region Deployment](#multi-region-deployment)
- [Docker-Based Deployment](#docker-based-deployment)
- [Web Interface Setup](#web-interface-setup)
- [Load Balancing](#load-balancing)
- [Monitoring and Alerting](#monitoring-and-alerting)
- [Backup and Disaster Recovery](#backup-and-disaster-recovery)

## 🖥️ Single Server Deployment

### Recommended VPS Providers

**High Performance:**
- DigitalOcean ($5-10/month)
- Vultr ($3.50-6/month)
- Linode ($5-10/month)
- Hetzner ($3-5/month EUR)

**Enterprise Grade:**
- AWS EC2 (t3.micro - t3.medium)
- Google Cloud Platform (e2-micro - e2-small)
- Azure (B1s - B2s)

### Server Specifications

**Small (1-10 users):**
- 1 vCPU
- 1 GB RAM
- 25 GB SSD
- 1 TB bandwidth

**Medium (10-50 users):**
- 2 vCPU
- 2 GB RAM
- 50 GB SSD
- 2-3 TB bandwidth

**Large (50-200 users):**
- 4+ vCPU
- 4+ GB RAM
- 80+ GB SSD
- 4-5 TB bandwidth

### Initial Setup

1. **Create VPS Instance:**
   - Choose Ubuntu 20.04 LTS or Debian 11
   - Select appropriate region (closest to users)
   - Enable IPv4 and IPv6

2. **Configure DNS (Optional):**
   ```bash
   # Point your domain to the server
   vpn.yourdomain.com → 203.0.113.10
   ```

3. **Initial Server Hardening:**
   ```bash
   # Update system
   sudo apt-get update && sudo apt-get upgrade -y
   
   # Configure SSH
   sudo nano /etc/ssh/sshd_config
   # Set: PermitRootLogin no
   # Set: PasswordAuthentication no
   
   # Install fail2ban
   sudo apt-get install fail2ban -y
   ```

4. **Run Installation:**
   ```bash
   git clone https://github.com/bounss2012-cpu/ultra-vpn.git
   cd ultra-vpn
   chmod +x install-vpn-server.sh
   sudo ./install-vpn-server.sh
   ```

### Network Configuration

**Port Forwarding:**
Ensure the following ports are open:
- UDP 51820 (WireGuard)
- TCP 8080 (Web Interface - optional)
- TCP 22 (SSH - restrict to your IP)

**Firewall Rules:**
```bash
# UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 51820/udp
sudo ufw allow 8080/tcp
sudo ufw enable
```

## 🌍 Multi-Region Deployment

### Architecture Overview

Deploy VPN servers in multiple regions for:
- Lower latency for global users
- Redundancy and failover
- Geographic compliance
- Load distribution

### Recommended Regions

**Global Coverage:**
- North America: US East (New York), US West (San Francisco)
- Europe: London, Frankfurt, Amsterdam
- Asia: Singapore, Tokyo, Mumbai
- Oceania: Sydney

### Automated Deployment

1. **Configure `deploy-global.sh`:**

   ```bash
   # Edit the REGIONS array
   declare -A REGIONS
   REGIONS[usa-east]="root@vpn-us-east.example.com"
   REGIONS[usa-west]="root@vpn-us-west.example.com"
   REGIONS[europe]="root@vpn-eu.example.com"
   REGIONS[asia]="root@vpn-asia.example.com"
   ```

2. **Set up SSH keys:**
   ```bash
   ssh-keygen -t ed25519 -C "vpn-deployment"
   ssh-copy-id root@vpn-us-east.example.com
   ssh-copy-id root@vpn-eu.example.com
   # ... repeat for all servers
   ```

3. **Run deployment:**
   ```bash
   chmod +x deploy-global.sh
   ./deploy-global.sh
   ```

### Manual Multi-Region Setup

For each region:

```bash
# Connect to server
ssh root@vpn-region.example.com

# Clone and install
git clone https://github.com/bounss2012-cpu/ultra-vpn.git
cd ultra-vpn
chmod +x install-vpn-server.sh
sudo ./install-vpn-server.sh
```

## 🐳 Docker-Based Deployment

### Prerequisites

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Deploy All Regions

```bash
# Start all VPN servers
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

### Deploy Specific Region

```bash
# Start only USA region
docker-compose up -d vpn-usa

# Start Europe and Asia
docker-compose up -d vpn-europe vpn-asia
```

### Configuration

Each region uses different:
- Port (51820, 51821, 51822)
- Internal subnet (10.66.66.0, 10.67.67.0, 10.68.68.0)
- Timezone

### Accessing Client Configs

```bash
# View generated configs
docker-compose exec vpn-usa cat /config/peer1/peer1.conf

# Download all configs
docker cp vpn-usa:/config/. ./vpn-usa-configs/
```

## 🎨 Web Interface Setup

### Production Deployment with Systemd

1. **Install dependencies:**
   ```bash
   sudo apt-get install python3 python3-pip -y
   pip3 install flask
   ```

2. **Create systemd service:**
   ```bash
   sudo nano /etc/systemd/system/vpn-manager.service
   ```

   ```ini
   [Unit]
   Description=VPN Manager Web Interface
   After=network.target wg-quick@wg0.service
   
   [Service]
   Type=simple
   User=root
   WorkingDirectory=/root/ultra-vpn
   ExecStart=/usr/bin/python3 /root/ultra-vpn/vpn-manager.py
   Restart=always
   RestartSec=10
   
   [Install]
   WantedBy=multi-user.target
   ```

3. **Enable and start:**
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable vpn-manager
   sudo systemctl start vpn-manager
   sudo systemctl status vpn-manager
   ```

### Nginx Reverse Proxy

1. **Install Nginx:**
   ```bash
   sudo apt-get install nginx -y
   ```

2. **Configure reverse proxy:**
   ```bash
   sudo nano /etc/nginx/sites-available/vpn-manager
   ```

   ```nginx
   server {
       listen 80;
       server_name vpn.yourdomain.com;
       
       location / {
           proxy_pass http://127.0.0.1:8080;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

3. **Enable site:**
   ```bash
   sudo ln -s /etc/nginx/sites-available/vpn-manager /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

### HTTPS with Let's Encrypt

```bash
# Install certbot
sudo apt-get install certbot python3-certbot-nginx -y

# Obtain certificate
sudo certbot --nginx -d vpn.yourdomain.com

# Auto-renewal is configured automatically
sudo certbot renew --dry-run
```

## ⚖️ Load Balancing

### DNS-Based Load Balancing

Configure multiple A records for your domain:

```
vpn.yourdomain.com    A    203.0.113.10  (USA)
vpn.yourdomain.com    A    198.51.100.20 (Europe)
vpn.yourdomain.com    A    192.0.2.30    (Asia)
```

### GeoDNS

Use services like:
- AWS Route 53 (Geolocation Routing)
- Cloudflare Load Balancing
- NS1
- DNSMadeEasy

Example configuration for closest server routing.

### Application-Level Load Balancing

Create a simple endpoint selection API:

```python
# endpoint-selector.py
from flask import Flask, jsonify
import requests

app = Flask(__name__)

SERVERS = [
    {"region": "usa", "endpoint": "vpn-us.example.com:51820", "latency": 0},
    {"region": "europe", "endpoint": "vpn-eu.example.com:51820", "latency": 0},
    {"region": "asia", "endpoint": "vpn-asia.example.com:51820", "latency": 0}
]

@app.route('/api/best-server')
def best_server():
    # Logic to determine best server based on user location
    return jsonify(SERVERS[0])

if __name__ == '__main__':
    app.run(port=5000)
```

## 📊 Monitoring and Alerting

### Prometheus + Grafana

1. **Install Prometheus:**
   ```bash
   # Add WireGuard exporter
   wget https://github.com/MindFlavor/prometheus_wireguard_exporter/releases/download/3.6.3/prometheus_wireguard_exporter_3.6.3_amd64.deb
   sudo dpkg -i prometheus_wireguard_exporter_3.6.3_amd64.deb
   ```

2. **Configure Grafana Dashboard:**
   - Import WireGuard dashboard
   - Monitor: Connected clients, bandwidth, latency

### Simple Monitoring Script

```bash
#!/bin/bash
# vpn-monitor.sh

# Check if WireGuard is running
if ! systemctl is-active --quiet wg-quick@wg0; then
    echo "ALERT: WireGuard is down!"
    # Send notification (email, Slack, etc.)
    systemctl restart wg-quick@wg0
fi

# Check client count
CLIENT_COUNT=$(wg show wg0 | grep -c "peer:")
echo "Connected clients: $CLIENT_COUNT"

# Check bandwidth
wg show wg0 transfer
```

**Add to crontab:**
```bash
*/5 * * * * /root/vpn-monitor.sh >> /var/log/vpn-monitor.log 2>&1
```

### Uptime Monitoring

Use external monitoring services:
- UptimeRobot (Free)
- Pingdom
- StatusCake
- Datadog

Monitor: UDP port 51820 availability

## 💾 Backup and Disaster Recovery

### Automated Backup Script

```bash
#!/bin/bash
# vpn-backup.sh

BACKUP_DIR="/root/vpn-backups"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="vpn-backup-$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

# Backup WireGuard configs
tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    /etc/wireguard/ \
    /root/ultra-vpn/

# Keep only last 30 days of backups
find "$BACKUP_DIR" -name "vpn-backup-*.tar.gz" -mtime +30 -delete

echo "Backup completed: $BACKUP_FILE"
```

**Schedule daily backups:**
```bash
# Add to crontab
0 2 * * * /root/vpn-backup.sh >> /var/log/vpn-backup.log 2>&1
```

### Remote Backup

```bash
# Backup to remote server
scp /root/vpn-backups/vpn-backup-*.tar.gz backup@backup-server:/backups/vpn/

# Or use rsync
rsync -avz /etc/wireguard/ backup@backup-server:/backups/vpn/wireguard/
```

### Restore Procedure

```bash
# Stop WireGuard
sudo systemctl stop wg-quick@wg0

# Restore from backup
tar -xzf vpn-backup-YYYYMMDD-HHMMSS.tar.gz -C /

# Restart WireGuard
sudo systemctl start wg-quick@wg0
```

## 🔄 Update Strategy

### Rolling Updates

For multi-region deployment:

```bash
# Update one region at a time
ssh vpn-us.example.com 'cd ultra-vpn && git pull && sudo systemctl restart wg-quick@wg0'
# Wait and verify
ssh vpn-eu.example.com 'cd ultra-vpn && git pull && sudo systemctl restart wg-quick@wg0'
# Continue for other regions
```

### Blue-Green Deployment

Maintain two sets of servers:
- Blue (active)
- Green (standby/update)

Update green, test, then switch DNS.

## 📈 Scaling Considerations

### Vertical Scaling
- Increase CPU/RAM for single server
- Limited by hardware

### Horizontal Scaling
- Add more regional servers
- Use DNS load balancing
- Better for global distribution

### Performance Optimization

```bash
# Kernel tuning
sudo nano /etc/sysctl.conf

# Add:
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.core.netdev_max_backlog = 5000

# Apply
sudo sysctl -p
```

## 🎯 Best Practices

1. **Always use HTTPS** for web interface
2. **Regular backups** - daily automated
3. **Monitor uptime** - external monitoring
4. **Update regularly** - security patches
5. **Document changes** - maintain runbook
6. **Test failover** - quarterly DR drills
7. **Capacity planning** - monitor growth
8. **Security audits** - annual reviews

## 📞 Support and Resources

- **GitHub**: https://github.com/bounss2012-cpu/ultra-vpn
- **Issues**: https://github.com/bounss2012-cpu/ultra-vpn/issues
- **WireGuard Docs**: https://www.wireguard.com/quickstart/

## ✅ Deployment Checklist

- [ ] Server(s) provisioned and hardened
- [ ] DNS configured (if applicable)
- [ ] VPN server installed and tested
- [ ] Firewall rules configured
- [ ] Web interface deployed (optional)
- [ ] HTTPS/SSL configured (if public)
- [ ] Monitoring set up
- [ ] Backup automation configured
- [ ] Documentation updated
- [ ] Team training completed
- [ ] Disaster recovery plan tested

---

For installation instructions, see [INSTALLATION.md](INSTALLATION.md).
For security best practices, see [SECURITY.md](SECURITY.md).
