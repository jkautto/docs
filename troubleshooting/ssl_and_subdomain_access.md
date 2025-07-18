# Troubleshooting: SSL and Subdomain Access

This guide covers the diagnosis and resolution of issues related to SSL certificates and subdomain accessibility.

---

## 1. Problem Synopsis

- **Symptom:** New subdomains (e.g., `pb.kaut.to`) are inaccessible from the internet, while the main domain (`kaut.to`) works correctly.
- **Symptom:** Let's Encrypt certificate generation or expansion fails with a timeout error for new subdomains.

---

## 2. Root Cause

The issue stems from a **Split DNS** configuration combined with a **Proxy/Firewall**.

- **Main Domain (`kaut.to`):** Points to a proxy/tunnel service IP (e.g., `157.180.28.186`).
- **Subdomains (`pb.kaut.to`):** Were incorrectly pointing directly to the origin server's IP (e.g., `172.87.176.11`).
- **The Block:** The origin server is firewalled and only accepts traffic from the proxy service. Direct connections from the internet are blocked.

This configuration prevents Let's Encrypt from validating the subdomains and blocks all external user traffic.

---

## 3. Resolution Steps

The problem was resolved by unifying the DNS and proxy configuration.

1.  **Update DNS Records:** All subdomain A records were updated to point to the same proxy IP address as the main domain (`157.180.28.186`).
2.  **Configure Proxy Service:** The proxy service (e.g., Cloudflare, Hetzner Firewall) was configured to recognize and forward traffic for the new subdomains.
3.  **Expand SSL Certificate:** With traffic flowing correctly through the proxy, the Let's Encrypt certificate was successfully expanded to cover all required subdomains.
4.  **Activate Nginx Configs:** The Nginx server blocks for the subdomains were enabled and tested.

---

## 4. Key Diagnostic Commands

Use these commands to diagnose similar issues:

- **Check DNS Resolution:**
  ```bash
  dig pb.kaut.to
  ```
  *(Verify that the IP address matches the main domain's proxy IP).*

- **Verify SSL Certificate:**
  ```bash
  openssl s_client -connect pb.kaut.to:443 -servername pb.kaut.to | openssl x509 -noout -text
  ```
  *(Check the "Subject Alternative Name" section to ensure all required domains are listed).*

- **Trace Network Path:**
  ```bash
  traceroute pb.kaut.to
  ```
  *(Identify where connections are being dropped).*

---

## 5. Lessons Learned & Best Practices

- **Verify IPs:** Always confirm that main domains and subdomains resolve to the correct IP address, especially when a proxy is involved.
- **Document Proxies:** Maintain clear documentation of all proxy, CDN, or tunnel services in use.
- **Prefer Path-Based Routing:** When possible, using paths (`kaut.to/pb/`) instead of subdomains (`pb.kaut.to`) can simplify network configuration and avoid these issues.
- **Check `certbot`:** Before expanding certificates, run `sudo certbot certificates` to see what domains are currently covered.
