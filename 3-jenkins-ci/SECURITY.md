# Jenkins CI Pipeline Security Hardening Notes

## 1. Jenkins Deployment

* Jenkins was deployed behind a **Traefik reverse proxy** with **TLS (HTTPS)** enabled via Let's Encrypt.
* Access was restricted to a DNS-controlled domain: `jenkins.pauldevops.duckdns.org`.

## 2. Admin Access Control

* Initial admin password retrieved securely from container secret:

  ```bash
  docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
  ```
* Strong, unique credentials configured after initial login.

## 3. Security Configuration

* **CSRF Protection** enabled.
* **Agent → Master Access Control** enforced.
* **CLI over Remoting** disabled.
* Anonymous read access disabled entirely.

## 4. User Permissions

* **Matrix Authorization Strategy** configured:

  * Only trusted users have administrative privileges.
  * Limited permissions for job execution and viewing.

## 5. Plugin Management

* Only **official, community-supported plugins** installed.
* Periodic plugin updates to patch vulnerabilities.

## 6. Secrets Management

* Jenkins Credentials Manager used to store:

  * `DOCKER_USERNAME`
  * `DOCKER_PASSWORD` or `GHCR_PAT`
* Secrets accessed in pipelines using `withCredentials` block for secure handling.

## 7. Docker-in-Docker (DinD) Isolation

* Jenkins built from a custom Dockerfile with DinD support.
* Host Docker socket (`/var/run/docker.sock`) securely mounted with limited access.

## 8. System Hardening

* Jenkins container runs as a **non-root user** where possible.
* Host firewall (UFW) restricts inbound traffic to essential ports only (`80`, `443`, `8080`).
* Docker Compose runs Jenkins with reduced privileges:

  ```yaml
  user: "1000:1000"
  read_only: true
  ```

## 9. Monitoring and Logging

* Jenkins logs available via Docker log stream.
* Traefik logs enabled to monitor external access.
* Optional: Integration with ELK or Prometheus for extended monitoring.

---

*Maintained by Oni Paul ([sirpaulx@gmail.com](mailto:sirpaulx@gmail.com))*
