#!/bin/bash
# Inject XSL stylesheet reference into RSS XML feeds
for f in _site/blog.xml _site/ro/blog.xml _site/de/blog.xml _site/sv/blogg.xml; do
  if [ -f "$f" ]; then
    sed -i '' 's|<?xml version="1.0" encoding="UTF-8"?>|<?xml version="1.0" encoding="UTF-8"?><?xml-stylesheet type="text/xsl" href="/feed.xsl"?>|' "$f"
    echo "Styled: $f"
  fi
done

# Create blog directory redirects (can't use .qmd or they pollute listings)
for lang_path in "ro/blog" "de/blog" "sv/blogg"; do
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
