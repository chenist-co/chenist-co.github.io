<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html lang="en">
      <head>
        <title><xsl:value-of select="/rss/channel/title"/> — RSS Feed</title>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <link rel="preconnect" href="https://fonts.googleapis.com"/>
        <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700&amp;family=Source+Code+Pro&amp;display=swap" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"/>
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }
          body { font-family: 'Open Sans', -apple-system, system-ui, sans-serif; background: #0a0a0a; color: #e5e5e5; min-height: 100vh; }

          /* Navbar */
          .nav { background: #0a0a0a; border-bottom: 1px solid rgba(255,255,255,0.06); padding: 0 1.5rem; height: 60px; display: flex; align-items: center; justify-content: space-between; max-width: 100%; }
          .nav-brand { font-family: 'Source Code Pro', monospace; font-size: 1.15rem; font-weight: 700; color: #fff; text-decoration: none; letter-spacing: 0.06em; text-transform: uppercase; }
          .nav-brand .dot { color: #81BD4A; }
          .nav-home { color: rgba(255,255,255,0.5); text-decoration: none; font-size: 0.85rem; transition: color 0.15s; }
          .nav-home:hover { color: #81BD4A; }

          /* Hero */
          .hero { padding: 5rem 1.5rem 3rem; text-align: center; position: relative; overflow: hidden; }
          .hero::before { content: ''; position: absolute; inset: 0; background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='692' height='692' viewBox='0 0 800 800'%3E%3Crect fill='none' width='800' height='800'/%3E%3Cg fill='none' stroke='%2381BD4A' stroke-width='1.5' stroke-opacity='0.1'%3E%3Cpath d='M769 229L1037 260.9M927 880L731 737 520 660 309 538 40 599 295 764 126.5 879.5 40 599-197 493 102 382-31 229 126.5 79.5-69-63'/%3E%3Cpath d='M520 660L578 842 731 737 840 599 603 493 520 660 295 764 309 538 390 382 539 269 769 229 577.5 41.5 370 105 295 -36 126.5 79.5 237 261 102 382 40 599 -69 737 127 880'/%3E%3C/g%3E%3Cg fill='%2381BD4A' fill-opacity='0.07'%3E%3Ccircle cx='769' cy='229' r='5'/%3E%3Ccircle cx='539' cy='269' r='5'/%3E%3Ccircle cx='603' cy='493' r='5'/%3E%3Ccircle cx='731' cy='737' r='5'/%3E%3Ccircle cx='295' cy='764' r='5'/%3E%3Ccircle cx='102' cy='382' r='5'/%3E%3C/g%3E%3C/svg%3E"); pointer-events: none; }
          .hero * { position: relative; }
          .hero .badge { display: inline-flex; align-items: center; gap: 0.4rem; background: rgba(242,101,34,0.12); color: #f26522; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; padding: 0.35rem 1rem; border-radius: 980px; margin-bottom: 1.25rem; }
          .hero h1 { font-size: clamp(2rem, 5vw, 3.5rem); font-weight: 700; letter-spacing: -0.04em; line-height: 1.1; margin-bottom: 0.75rem; }
          .hero .dot { color: #81BD4A; }
          .hero p { font-size: 1.05rem; color: rgba(255,255,255,0.5); max-width: 460px; margin: 0 auto 2rem; line-height: 1.5; }

          /* URL box */
          .url-box { display: inline-flex; align-items: center; gap: 0.5rem; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 0.65rem 1.25rem; font-family: 'Source Code Pro', monospace; font-size: 0.82rem; color: rgba(255,255,255,0.5); cursor: pointer; transition: border-color 0.15s; }
          .url-box:hover { border-color: #81BD4A; }
          .copied { color: #81BD4A; font-size: 0.78rem; font-weight: 600; display: none; margin-top: 0.5rem; }

          /* Subscribe buttons */
          .subscribe { display: flex; justify-content: center; gap: 0.5rem; flex-wrap: wrap; margin-top: 1.5rem; }
          .btn { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.55rem 1.5rem; border-radius: 980px; font-size: 0.85rem; font-weight: 600; text-decoration: none; transition: all 0.15s; }
          .btn-rss { background: #f26522; color: #fff; }
          .btn-rss:hover { background: #d4551b; }
          .btn-sub { background: #ff6719; color: #fff; }
          .btn-sub:hover { background: #e55a15; }
          .btn-out { background: transparent; color: rgba(255,255,255,0.6); border: 1.5px solid rgba(255,255,255,0.15); }
          .btn-out:hover { border-color: #0a66c2; color: #0a66c2; }

          /* Readers */
          .readers { max-width: 700px; margin: 2rem auto 0; padding: 0 1.5rem; }
          .readers h3 { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: rgba(255,255,255,0.25); text-align: center; margin-bottom: 1rem; }
          .readers-grid { display: flex; justify-content: center; gap: 0.5rem; flex-wrap: wrap; }
          .reader { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.4rem 1rem; border-radius: 10px; border: 1px solid rgba(255,255,255,0.06); font-size: 0.8rem; font-weight: 500; color: rgba(255,255,255,0.45); text-decoration: none; transition: all 0.15s; }
          .reader:hover { border-color: rgba(129,189,74,0.3); color: #81BD4A; }

          /* Articles */
          .articles { max-width: 800px; margin: 3rem auto 0; padding: 0 1.5rem; }
          .articles-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 0.6rem; }
          .label { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; color: rgba(255,255,255,0.3); }
          .count { font-size: 0.75rem; color: rgba(255,255,255,0.2); }

          .article { display: block; padding: 1.75rem 0; border-bottom: 1px solid rgba(255,255,255,0.04); text-decoration: none; color: inherit; transition: background 0.15s; }
          .article:last-child { border-bottom: none; }
          .article:hover .article-title { color: #81BD4A; }
          .article-date { font-size: 0.75rem; color: rgba(255,255,255,0.3); margin-bottom: 0.3rem; }
          .article-title { font-size: 1.15rem; font-weight: 700; letter-spacing: -0.02em; line-height: 1.3; margin-bottom: 0.4rem; color: #fff; transition: color 0.15s; }
          .article-cats { display: flex; gap: 0.3rem; flex-wrap: wrap; margin-top: 0.5rem; }
          .article-cat { display: inline-block; padding: 0.15rem 0.55rem; border-radius: 980px; font-size: 0.65rem; font-weight: 600; background: rgba(129,189,74,0.08); color: #81BD4A; }
          .article-arrow { color: #81BD4A; font-size: 0.85rem; float: right; margin-top: 0.3rem; opacity: 0.4; transition: opacity 0.15s; }
          .article:hover .article-arrow { opacity: 1; }

          /* Footer */
          .foot { text-align: center; padding: 4rem 1.5rem 3rem; color: rgba(255,255,255,0.15); font-size: 0.78rem; }
          .foot a { color: #81BD4A; text-decoration: none; }
          .foot a:hover { text-decoration: underline; }

          @media (max-width: 600px) { .hero { padding: 3rem 1.5rem 2rem; } .subscribe { flex-direction: column; align-items: center; } }
        </style>
      </head>
      <body>
        <div class="nav">
          <a href="/" class="nav-brand">CHEN<span class="dot">.</span>IST</a>
          <a href="/" class="nav-home"><i class="bi bi-house me-1"></i> Home</a>
        </div>

        <div class="hero">
          <div class="badge"><i class="bi bi-rss"></i> RSS Feed</div>
          <h1>chen<span class="dot">.</span>ist Blog</h1>
          <p><xsl:value-of select="/rss/channel/description"/></p>

          <div class="url-box" id="url-box">
            <i class="bi bi-rss" style="color:#f26522;"></i>
            <span id="feed-url">https://chen.ist/blog.xml</span>
            <i class="bi bi-clipboard" style="color:rgba(255,255,255,0.3);margin-left:0.5rem;"></i>
          </div>
          <div class="copied" id="copied"><i class="bi bi-check-circle-fill"></i> Copied to clipboard</div>

          <div class="subscribe">
            <a class="btn btn-rss" href="/blog.xml"><i class="bi bi-rss"></i> Raw RSS</a>
            <a class="btn btn-sub" href="https://alinmechenici.substack.com" target="_blank"><i class="bi bi-envelope"></i> Substack</a>
            <a class="btn btn-out" href="https://linkedin.com/in/chenistsec" target="_blank"><i class="bi bi-linkedin"></i> Follow</a>
          </div>

          <div class="readers">
            <h3>Add to your reader</h3>
            <div class="readers-grid">
              <a class="reader" href="https://feedly.com/i/subscription/feed%2Fhttps%3A%2F%2Fchen.ist%2Fblog.xml" target="_blank"><i class="bi bi-journal-text" style="color:#81BD4A;"></i> Feedly</a>
              <a class="reader" href="https://www.inoreader.com/?add_feed=https://chen.ist/blog.xml" target="_blank"><i class="bi bi-inbox" style="color:#81BD4A;"></i> Inoreader</a>
              <a class="reader" href="https://newsblur.com/?url=https://chen.ist/blog.xml" target="_blank"><i class="bi bi-newspaper" style="color:#81BD4A;"></i> NewsBlur</a>
            </div>
          </div>
        </div>

        <div class="articles">
          <div class="articles-header">
            <span class="label">Latest Articles</span>
            <span class="count"><xsl:value-of select="count(/rss/channel/item)"/> articles</span>
          </div>
          <xsl:for-each select="/rss/channel/item">
            <a class="article" href="{link}">
              <span class="article-arrow"><i class="bi bi-arrow-right"></i></span>
              <div class="article-date"><xsl:value-of select="pubDate"/></div>
              <div class="article-title"><xsl:value-of select="title"/></div>
              <div class="article-cats">
                <xsl:for-each select="category">
                  <span class="article-cat"><xsl:value-of select="."/></span>
                </xsl:for-each>
              </div>
            </a>
          </xsl:for-each>
        </div>

        <div class="foot">
          <p style="margin-bottom:0.75rem;">This is an RSS feed. Copy the URL above into your feed reader to subscribe.</p>
          <p><a href="/"><i class="bi bi-arrow-left me-1"></i> Back to chen.ist</a></p>
        </div>

        <script>
          document.getElementById('url-box').addEventListener('click', function() {
            var url = document.getElementById('feed-url').textContent;
            navigator.clipboard.writeText(url).then(function() {
              var el = document.getElementById('copied');
              el.style.display = 'block';
              setTimeout(function() { el.style.display = 'none'; }, 2000);
            });
          });
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
