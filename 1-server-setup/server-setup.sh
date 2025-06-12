#!/bin/bash
# ===== UBUNTU 22.04 HARDENING =====
set -e

# 1. Create non-root user
sudo adduser devopsadmin --gecos "" --disabled-password
echo "devopsadmin:$(openssl rand -base64 16)" | sudo chpasswd
sudo usermod -aG sudo devopsadmin

# 2. SSH hardening
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# 3. Configure UFW firewall
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable

# 4. Install Docker securely
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# 5. Install Docker Compose
sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 6. Add user to docker group
sudo usermod -aG docker devopsadmin

# 7. Reboot to apply changes
sudo systemctl restart ssh
echo "✅ Hardening complete! Switch to new user:"
echo "su - devopsadmin"