#!/bin/bash
# Cross-platform sed -i (macOS needs '', Linux doesn't)
sedi() { if [[ "$OSTYPE" == "darwin"* ]]; then sed -i '' "$@"; else sed -i "$@"; fi; }

# Expose Alin's iCal feed at the short path /alinmechenici.ics (source stays at /assets/files/)
if [ -f "_site/assets/files/alin-mechenici.ics" ]; then
  cp "_site/assets/files/alin-mechenici.ics" "_site/alinmechenici.ics"
  echo "Copied: _site/alinmechenici.ics"
fi

# Inject XSL stylesheet reference into RSS XML feeds
for f in _site/blog.xml _site/ro/blog.xml _site/de/blog.xml _site/sv/blog.xml; do
  if [ -f "$f" ]; then
    sedi 's|<?xml version="1.0" encoding="UTF-8"?>|<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="/feed.xsl"?>|' "$f"
    echo "Styled: $f"
  fi
done

# Create blog directory redirects (can't use .qmd or they pollute listings)
# EN blog redirect
mkdir -p "_site/blog"
cat > "_site/blog/index.html" << REDIRECT
<!DOCTYPE html>
<html><head><meta http-equiv="refresh" content="0; url=/blog.html"><title>Redirecting...</title></head>
<body>Redirecting to <a href="/blog.html">blog</a>...</body></html>
REDIRECT
echo "Redirect: _site/blog/index.html"

for lang_path in "ro/blog" "de/blog" "sv/blog"; do
  lang=$(echo "$lang_path" | cut -d'/' -f1)
  blog_name=$(echo "$lang_path" | cut -d'/' -f2)
  mkdir -p "_site/$lang_path"
  cat > "_site/$lang_path/index.html" << REDIRECT
<!DOCTYPE html>
<html><head><meta http-equiv="refresh" content="0; url=/$lang/$blog_name.html"><title>Redirecting...</title></head>
<body>Redirecting to <a href="/$lang/$blog_name.html">blog</a>...</body></html>
REDIRECT
  echo "Redirect: _site/$lang_path/index.html"
done
