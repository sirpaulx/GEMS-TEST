# 🔐 Linux Server Hardening (Ubuntu 22.04)

This folder contains the automation script and documentation for hardening a Docker host on Ubuntu 22.04 as part of the DevOps test project.

## 📜 Objectives
- Provision a secure Ubuntu 22.04 server.
- Prevent unauthorized access and reduce attack surface.
- Install Docker and Docker Compose securely.
- Prepare the system for safe CI/CD operations.

---

## ⚙️ Script Overview (`server-setup.sh`)

### ✔️ Steps Performed:

1. **Create a Non-root Sudo User**
   - Adds user `devopsadmin` with random password (change afterward).
   - Grants `sudo` and `docker` group privileges.

2. **SSH Hardening**
   - Disables root login via SSH.
   - Disables password-based login (public key required).

3. **Firewall Configuration**
   - Enables UFW.
   - Allows only SSH (22), HTTP (80), and HTTPS (443).

4. **Secure Docker Installation**
   - Installs Docker via official Docker APT repo.
   - Installs Docker Compose manually from GitHub.
   - Configures system without using `curl | sh` methods.

5. **SSH Daemon Reload**
   - Applies SSH config changes without reboot.

---

## 🧪 Usage

```bash
chmod +x server-setup.sh
sudo ./server-setup.sh
