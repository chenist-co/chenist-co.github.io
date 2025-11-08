# Setting up Custom Domain for GitHub Pages with Cloudflare

This guide explains how to configure chen.ist and www.chen.ist with Cloudflare DNS for your GitHub Pages site.

## Cloudflare DNS Configuration

**IMPORTANT:** For GitHub Pages to work properly with Cloudflare, you must disable proxying (use "DNS only" mode - gray cloud icon).

### Step 1: Configure Apex Domain (chen.ist)

Add these A records in your Cloudflare DNS settings:

| Type | Name | Content | Proxy Status | TTL |
|------|------|---------|--------------|-----|
| A | @ | 185.199.108.153 | DNS only (gray) | Auto |
| A | @ | 185.199.109.153 | DNS only (gray) | Auto |
| A | @ | 185.199.110.153 | DNS only (gray) | Auto |
| A | @ | 185.199.111.153 | DNS only (gray) | Auto |

### Step 2: Configure www Subdomain (www.chen.ist)

Add this CNAME record:

| Type | Name | Content | Proxy Status | TTL |
|------|------|---------|--------------|-----|
| CNAME | www | chenist-co.github.io | DNS only (gray) | Auto |

**Note:** The content should be `chenist-co.github.io` (without trailing dot in Cloudflare)

## How to Configure in Cloudflare

1. Log in to your Cloudflare dashboard
2. Select your domain (chen.ist)
3. Go to **DNS** > **Records**
4. Click **Add record** for each entry above
5. **CRITICAL:** Click the orange cloud icon to make it gray (DNS only) for each record
6. Save your changes

## GitHub Repository Configuration

The repository is already configured with:
- CNAME file containing "chen.ist" ✓
- Quarto config with site-url: https://chen.ist ✓

If you need to verify GitHub Pages settings:
1. Go to https://github.com/chenist-co/chenist-co.github.io
2. Navigate to **Settings** > **Pages**
3. Ensure "Custom domain" shows "chen.ist"
4. **Check "Enforce HTTPS"** after DNS propagation (may take up to 24 hours)

## Domain Behavior

With this configuration:
- **chen.ist** → Your main site (apex domain)
- **www.chen.ist** → Automatically redirects to chen.ist
- Both domains will work and point to your GitHub Pages site

## Verify Setup

After configuring DNS in Cloudflare, verify using these commands:

```bash
# Check apex domain A records
dig chen.ist +noall +answer

# Check www subdomain CNAME
dig www.chen.ist +noall +answer

# Verify both domains resolve
curl -I https://chen.ist
curl -I https://www.chen.ist
```

Expected results:
- chen.ist should show the 4 A records (185.199.108-111.153)
- www.chen.ist should show CNAME to chenist-co.github.io

## Timeline

- **DNS propagation:** 5 minutes to 48 hours (typically under 1 hour with Cloudflare)
- **HTTPS certificate:** Available 24 hours after DNS propagation
- **Initial setup:** Check back in 1 hour to verify the site is accessible

## Troubleshooting

### Site not loading after DNS configuration

1. **Verify DNS in Cloudflare:**
   - Confirm all 4 A records are present for @ (apex)
   - Confirm CNAME record exists for www
   - **Ensure Proxy Status is "DNS only" (gray cloud)** - this is critical!

2. **Check GitHub Pages:**
   - Go to repository Settings > Pages
   - Verify custom domain shows "chen.ist"
   - Check for any warning messages
   - Re-save the custom domain if needed

3. **Clear DNS cache:**
   ```bash
   # On your local machine
   sudo dnsmasq --clear-cache  # macOS/Linux
   ipconfig /flushdns          # Windows
   ```

4. **HTTPS issues:**
   - Don't enable "Enforce HTTPS" until the certificate is provisioned
   - Can take up to 24 hours after DNS is working
   - You'll see a checkmark in GitHub Pages settings when ready

### Cloudflare-specific issues

- **ERR_TOO_MANY_REDIRECTS:** Proxy status is enabled (orange cloud) - change to DNS only (gray cloud)
- **SSL/TLS mode:** Set to "Full" or "Flexible" in Cloudflare SSL/TLS settings
- **Always Use HTTPS:** Can be enabled in Cloudflare SSL/TLS > Edge Certificates after GitHub HTTPS is working

## Why DNS Only Mode?

GitHub Pages serves content directly and handles HTTPS certificates via Let's Encrypt. When Cloudflare proxy is enabled:
- Cloudflare can't verify domain ownership for GitHub
- Creates redirect loops
- Prevents HTTPS certificate issuance

By using "DNS only" mode, Cloudflare only manages DNS resolution, allowing GitHub Pages to work properly.