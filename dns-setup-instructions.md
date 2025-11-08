# Setting up Custom Domain for GitHub Pages with Cloudflare

This guide explains how to configure chen.ist and www.chen.ist with Cloudflare DNS for your GitHub Pages site.

## Prerequisites: Verify Domain with GitHub

**IMPORTANT:** Since the repository is owned by the `chenist-co` **organization**, you must verify the domain at the organization level, not your personal account.

### Get Verification Code from GitHub Organization

1. Go to your **organization settings** (not personal account settings):
   - Visit: https://github.com/organizations/chenist-co/settings/pages
   - Or: Click your profile → **Your organizations** → **chenist-co** → **Settings** → **Pages**

2. Scroll down to **Verified domains**

3. Click **Add a domain**

4. Enter `chen.ist` and click **Add domain**

5. GitHub will show you a TXT record like:
   ```
   Name: _github-pages-challenge-chenist-co
   Value: 01e35f3149aaf97c2579a155192536
   ```
   **Copy both the name and value** - you'll need them for Cloudflare

### Add Verification TXT Record to Cloudflare

5. Log in to Cloudflare → Select chen.ist → Go to **DNS** > **Records**

6. Click **Add record** and enter:
   - **Type:** TXT
   - **Name:** `_github-pages-challenge-chenist-co` (or the exact subdomain GitHub provided)
   - **Content:** (paste the verification code from GitHub)
   - **Proxy status:** DNS only (gray cloud)
   - **TTL:** Auto

7. Click **Save**

8. Go back to GitHub and click **Verify** (may take a few minutes for DNS to propagate)

9. Once verified, you'll see a green checkmark ✓

**Note:** Keep the TXT record in Cloudflare - don't delete it after verification.

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

### Enable Custom Domain in GitHub Pages

**IMPORTANT:** Only do this AFTER domain verification is complete (green checkmark in account settings).

1. Go to https://github.com/chenist-co/chenist-co.github.io
2. Navigate to **Settings** > **Pages**
3. Under **Custom domain**, enter: `chen.ist`
4. Click **Save**
5. GitHub will check DNS and show "DNS check successful" when ready
6. Wait 24 hours, then enable **Enforce HTTPS** (once certificate is provisioned)

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