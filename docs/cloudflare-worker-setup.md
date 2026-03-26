# Cloudflare Worker: Subdomain-Based Language Routing for chen.ist

This document describes how to set up subdomain-based language routing so that:

- `chen.ist` serves English content (root `/`)
- `ro.chen.ist` serves Romanian content from `/ro/*`
- `de.chen.ist` serves German content from `/de/*`
- `se.chen.ist` serves Swedish content from `/sv/*`

The site is hosted on GitHub Pages at `chenist-co.github.io` with custom domain `chen.ist`.

---

## 1. Cloudflare Worker Script

Create a Worker named `lang-router` with the following script:

```javascript
/**
 * Cloudflare Worker: Subdomain-based language routing for chen.ist
 *
 * Routes language subdomains to the corresponding path prefix on the origin.
 *   ro.chen.ist  ->  chen.ist/ro/
 *   de.chen.ist  ->  chen.ist/de/
 *   se.chen.ist  ->  chen.ist/sv/   (Swedish subdomain uses /sv/ path)
 *
 * All other requests (including chen.ist itself) pass through unchanged.
 */

const SUBDOMAIN_TO_PATH = {
  'ro': '/ro',
  'de': '/de',
  'se': '/sv',
};

const ORIGIN = 'https://chen.ist';

addEventListener('fetch', (event) => {
  event.respondWith(handleRequest(event.request));
});

async function handleRequest(request) {
  const url = new URL(request.url);
  const hostname = url.hostname;

  // Extract subdomain: "ro.chen.ist" -> "ro"
  const parts = hostname.split('.');
  let subdomain = null;

  if (parts.length === 3 && parts[1] === 'chen' && parts[2] === 'ist') {
    subdomain = parts[0];
  }

  // If no language subdomain match, pass through unchanged
  const pathPrefix = subdomain ? SUBDOMAIN_TO_PATH[subdomain] : null;
  if (!pathPrefix) {
    return fetch(request);
  }

  // Build the rewritten URL
  // e.g., ro.chen.ist/services.html -> chen.ist/ro/services.html
  let path = url.pathname;

  // Prevent double-prefixing if someone visits ro.chen.ist/ro/something
  if (path.startsWith(pathPrefix + '/') || path === pathPrefix) {
    return fetch(request);
  }

  // Append path prefix to the origin
  const newPath = pathPrefix + (path === '/' ? '/index.html' : path);
  const originUrl = new URL(newPath, ORIGIN);
  originUrl.search = url.search;

  // Fetch from origin with the rewritten URL
  const originRequest = new Request(originUrl.toString(), {
    method: request.method,
    headers: request.headers,
    redirect: 'follow',
  });

  let response = await fetch(originRequest, {
    cf: {
      // Cache on Cloudflare edge
      cacheTtl: 300,
      cacheEverything: true,
    },
  });

  // If the direct path fails, try appending /index.html for directory URLs
  if (response.status === 404 && !path.includes('.') && !path.endsWith('/')) {
    const dirUrl = new URL(pathPrefix + path + '/index.html', ORIGIN);
    dirUrl.search = url.search;

    const dirRequest = new Request(dirUrl.toString(), {
      method: request.method,
      headers: request.headers,
      redirect: 'follow',
    });

    const dirResponse = await fetch(dirRequest, {
      cf: { cacheTtl: 300, cacheEverything: true },
    });

    if (dirResponse.status === 200) {
      response = dirResponse;
    }
  }

  // Clone response and set headers for proper caching and CORS
  const newResponse = new Response(response.body, response);

  // Add canonical hint so search engines know the relationship
  if (response.status === 200) {
    newResponse.headers.set('X-Robots-Tag', 'noindex');
    // Optional: if you want search engines to index subdomains instead,
    // remove the line above and handle canonical tags in your HTML.
  }

  return newResponse;
}
```

> **Note on X-Robots-Tag**: The script sets `X-Robots-Tag: noindex` on subdomain
> responses by default to avoid duplicate content issues with search engines
> (since the same content exists at both `chen.ist/ro/` and `ro.chen.ist/`).
> Remove this header if you want subdomains to be indexed instead and plan to
> add proper `<link rel="canonical">` tags in your HTML.

---

## 2. DNS Setup (Cloudflare Dashboard)

Go to **Cloudflare Dashboard > chen.ist > DNS > Records** and add these CNAME records:

| Type  | Name | Target              | Proxy status |
|-------|------|---------------------|--------------|
| CNAME | `ro` | `chen.ist`          | Proxied      |
| CNAME | `de` | `chen.ist`          | Proxied      |
| CNAME | `se` | `chen.ist`          | Proxied      |

**Important**: All three records must be set to **Proxied** (orange cloud icon), not DNS-only. The Worker only runs on proxied traffic.

The existing DNS records for `chen.ist` itself (pointing to GitHub Pages) should remain unchanged.

### Verify DNS records

After adding, your DNS records should include at minimum:

```
chen.ist        CNAME   chenist-co.github.io    Proxied
ro.chen.ist     CNAME   chen.ist                Proxied
de.chen.ist     CNAME   chen.ist                Proxied
se.chen.ist     CNAME   chen.ist                Proxied
```

---

## 3. Create the Worker (Cloudflare Dashboard)

### Step 1: Navigate to Workers

1. Log in to the [Cloudflare Dashboard](https://dash.cloudflare.com).
2. Select the **chen.ist** domain from your account.
3. In the left sidebar, click **Workers & Pages**.
4. Click **Create**.
5. Select **"Create Worker"**.

### Step 2: Configure the Worker

1. Name the Worker: `lang-router`
2. Click **Deploy** to create it with the default "Hello World" code.
3. After deployment, click **Edit Code**.
4. Replace the entire contents with the Worker script from Section 1 above.
5. Click **Save and Deploy**.

### Step 3: Alternatively, deploy via Wrangler CLI

If you prefer the command line:

```bash
# Install Wrangler if not already installed
npm install -g wrangler

# Authenticate
wrangler login

# Create the project directory
mkdir -p cloudflare-worker && cd cloudflare-worker

# Create wrangler.toml
cat > wrangler.toml << 'EOF'
name = "lang-router"
main = "worker.js"
compatibility_date = "2024-01-01"

# Routes are configured per-zone
# These tell Cloudflare which requests should trigger this Worker
[[routes]]
pattern = "ro.chen.ist/*"
zone_name = "chen.ist"

[[routes]]
pattern = "de.chen.ist/*"
zone_name = "chen.ist"

[[routes]]
pattern = "se.chen.ist/*"
zone_name = "chen.ist"
EOF

# Save the Worker script as worker.js (copy from Section 1)
# Then deploy:
wrangler deploy
```

---

## 4. Worker Route Configuration

If you created the Worker through the dashboard (not Wrangler), you need to add routes manually.

### Add routes via Dashboard

1. Go to **Cloudflare Dashboard > chen.ist > Workers Routes**.
2. Click **Add Route** and create these three routes:

| Route Pattern      | Worker        |
|--------------------|---------------|
| `ro.chen.ist/*`    | `lang-router` |
| `de.chen.ist/*`    | `lang-router` |
| `se.chen.ist/*`    | `lang-router` |

**Do not** add a route for `chen.ist/*` -- the main domain should continue to serve directly from GitHub Pages without Worker intervention.

### Alternatively, add routes via API

```bash
# Get your Zone ID from the dashboard Overview page
ZONE_ID="your-zone-id"
API_TOKEN="your-api-token"
WORKER_NAME="lang-router"

for pattern in "ro.chen.ist/*" "de.chen.ist/*" "se.chen.ist/*"; do
  curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/workers/routes" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"pattern\": \"$pattern\", \"script\": \"$WORKER_NAME\"}"
done
```

---

## 5. Testing

### Quick smoke test with curl

```bash
# Test Romanian subdomain
curl -sI https://ro.chen.ist/ | head -20

# Test that content comes from /ro/ path
curl -s https://ro.chen.ist/ | grep -i "<title>"

# Test German subdomain
curl -sI https://de.chen.ist/ | head -20

# Test Swedish subdomain
curl -sI https://se.chen.ist/ | head -20

# Test a subpage
curl -sI https://ro.chen.ist/services.html

# Test that the main domain still works
curl -sI https://chen.ist/ | head -20

# Verify query strings are preserved
curl -sI "https://ro.chen.ist/services.html?ref=test"
```

### What to verify

1. **Status codes**: All subdomain requests should return `200 OK`.
2. **Content correctness**: `ro.chen.ist/` should return the same content as `chen.ist/ro/index.html`.
3. **Subpages**: `de.chen.ist/services.html` should match `chen.ist/de/services.html`.
4. **Main domain**: `chen.ist` should be unaffected and serve English content.
5. **Query strings**: `se.chen.ist/page?foo=bar` should forward the query string.
6. **Assets**: CSS, JS, and images should load correctly (check browser console for errors).

### Browser testing

1. Open `https://ro.chen.ist` in your browser.
2. Open DevTools (F12) and check the Network tab for any failed requests.
3. Verify that navigation links within the site work correctly.
4. Check that all CSS/JS/images load properly.

### Common issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| `522` or `523` error | DNS record not proxied | Set CNAME to Proxied (orange cloud) |
| `404` on subdomain | Worker route not configured | Add the route in Workers Routes |
| Redirect loop | GitHub Pages redirecting | Ensure CNAME file only contains `chen.ist` |
| Mixed content | Assets loaded over HTTP | Ensure all asset URLs are relative or protocol-relative |
| CSS/JS missing | Assets reference absolute paths to `chen.ist` | Use relative paths in your HTML templates |

---

## 6. Optional: Asset Handling

If your site uses absolute URLs for CSS, JS, or images (e.g., `/assets/style.css`), these
will work correctly because the Worker only rewrites paths on the language subdomains and
assets typically live at the root level.

However, if language-specific pages reference assets with language-prefixed paths
(e.g., `/ro/assets/style.css`), the Worker will correctly route these since it prepends
the language path prefix to all requests on that subdomain.

### Relative links between pages

Internal links in your language pages should use relative paths. For example, in
`/ro/services.html`, a link to the contact page should be:

```html
<!-- On ro.chen.ist, this works as-is -->
<a href="contact.html">Contact</a>

<!-- Avoid absolute paths that include the language prefix -->
<!-- This would break: <a href="/ro/contact.html"> -->
```

If your Quarto site generates absolute paths with the language prefix, the Worker handles
this correctly because it passes through requests that already have the prefix
(the double-prefix guard in the script).

---

## 7. GitHub Pages Configuration

No changes are needed to your GitHub Pages setup. The existing `CNAME` file should
remain as-is with `chen.ist` only. GitHub Pages does not need to know about the
subdomains because Cloudflare's Worker handles the routing before the request reaches
GitHub Pages.

Your current `CNAME` file:
```
chen.ist
```

This is correct. Do not add subdomains to this file.
