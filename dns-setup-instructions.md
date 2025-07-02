# Setting up Custom Domain for GitHub Pages

To set up your custom domain (chen.ist) with GitHub Pages, you need to configure the following DNS records with your domain registrar:

## Option 1: Apex Domain Setup (chen.ist)

Add these A records pointing to GitHub's IP addresses:
```
A   @   185.199.108.153
A   @   185.199.109.153
A   @   185.199.110.153
A   @   185.199.111.153
```

## Option 2: www Subdomain Setup (www.chen.ist)

Add a CNAME record:
```
CNAME   www   chenist-co.github.io.
```

## Optional: Set up both apex domain and www subdomain

If you want both chen.ist and www.chen.ist to work:
1. Configure the A records for the apex domain as shown in Option 1
2. Add the www CNAME record as shown in Option 2
3. In GitHub repository settings, set your custom domain to your preferred version (either chen.ist or www.chen.ist)

## Verify Setup

1. After configuring DNS, it may take up to 24 hours for changes to propagate
2. You can verify your DNS configuration using:
   ```
   dig chen.ist +noall +answer
   dig www.chen.ist +noall +answer
   ```

## GitHub Repository Settings

1. Go to your repository on GitHub
2. Navigate to Settings > Pages
3. Under "Custom domain", enter your domain (chen.ist)
4. Check "Enforce HTTPS" after DNS propagation is complete (may take up to 24 hours)

## Troubleshooting

If your site doesn't work after DNS propagation:
1. Verify your DNS settings are correct
2. Make sure the CNAME file in your repository contains only "chen.ist"
3. Check that your custom domain is correctly set in GitHub Pages settings
4. Ensure your site is being published from the correct branch (gh-pages)