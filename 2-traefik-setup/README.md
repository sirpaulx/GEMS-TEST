# 🛡️ Traefik Reverse Proxy Deployment (Assessment Setup)

This project sets up a secure reverse proxy using Traefik v2 behind HTTPS, with multiple dummy services, Basic Auth, and automatic certificate generation. It was built for a DevOps assessment to demonstrate infrastructure setup, security, and automation using Docker.

---

## ✅ Features

- 🔒 HTTPS via Let’s Encrypt (auto TLS with ACME)
- 🔁 Routing for multiple services (`whoami1`, `whoami2`)
- 🔐 HTTP Basic Auth for sensitive endpoints
- 📊 Secured Traefik dashboard
- 📁 Config via Docker labels & mounted dynamic config
- 🔧 Hardened Ubuntu server
- 🌍 Domain-based routing using DuckDNS

---

## 🌐 URLs

| Component        | URL                                        | Auth Required |
|------------------|---------------------------------------------|----------------|
| Public Service   | https://pauldevops.duckdns.org              | ❌ No           |
| Secure Service   | https://secure.pauldevops.duckdns.org       | ✅ Yes          |
| Traefik Dashboard| https://dashboard.pauldevops.duckdns.org    | ✅ Yes          |

---

## 📦 Project Structure

| File/Dir               | Description                                      |
|------------------------|--------------------------------------------------|
| `docker-compose.yml`   | Main services (Traefik + whoami containers)      |
| `traefik/traefik.yml`  | Static config (entryPoints, providers)           |
| `traefik/dynamic.yml`  | Dynamic config (Basic Auth middleware)           |
| `.env`                 | Environment variables (DOMAIN, EMAIL, AUTH)      |
| `acme.json`            | Let's Encrypt certificate storage (600 perms)    |

---

## 🔧 Setup Instructions

1. **Create `.env` file** with your domain and credentials:
   ```env
   DOMAIN=pauldevops.duckdns.org
   LETSENCRYPT_EMAIL=sirpaulx@gmail.com
   BASIC_AUTH=paul:$apr1$ste3..j/$IJJBmIQMLqX9yU2l7ppxk/
   ```

2. **Secure cert storage**:
   ```bash
   touch acme.json && chmod 600 acme.json
   ```

3. **Deploy stack**:
   ```bash
   docker compose up -d
   ```

4. **Access the services** via the URLs listed above.

---

## 🧪 Auth Credentials

- Username: `paul`
- Password: `admin`

(Password stored securely in `.env` as hashed string.)

---

## ⚠️ Notes & Considerations

- Uses **HTTP challenge** (port 80) – ensure firewall allows it.
- Dashboard and secure service are protected via Basic Auth middleware.
- DNS (DuckDNS) is already pointed to the VM’s public IP.
- UFW and SSH key-based login are used to harden access.

---

## 🧠 Suggested Improvements

- Migrate to DNS challenge (e.g. Cloudflare) for better reliability
- Use Docker secrets or Vault for credentials
- Add automatic deployment via GitHub Actions or Jenkins
- Integrate monitoring (Prometheus, Grafana)
