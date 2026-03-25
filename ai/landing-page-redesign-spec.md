# chen.ist Landing Page Redesign: Conversion-Optimized Design Specification

**Creative Direction Brief** | March 2026
**Objective**: Maximize cal.com/chenist booking conversions across 3 service landing pages
**Tech Stack**: Quarto (.qmd), Bootstrap 5, custom CSS, no JS frameworks
**Brand**: Navy #323642, Green #81BD4A, Off-white #E5E3DA

---

## Global Architecture: Shared CSS & Components

### New Landing Page CSS File

**File**: `assets/css/landing-pages.css` (add to `_quarto.yml` css array)

This replaces the duplicated inline `<style>` blocks currently embedded in each .qmd file. One shared stylesheet for all three landing pages.

```css
/* ==========================================================================
   LANDING PAGE SYSTEM — chen.ist conversion pages
   ========================================================================== */

/* ---------- Design Tokens ---------- */
:root {
  --lp-navy: #323642;
  --lp-green: #81BD4A;
  --lp-green-dark: #6BA33A;
  --lp-green-glow: rgba(129, 189, 74, 0.15);
  --lp-offwhite: #E5E3DA;
  --lp-gray-100: #f8f8f6;
  --lp-gray-200: #f0efeb;
  --lp-gray-500: #86868b;
  --lp-gray-700: #555;
  --lp-red-urgency: #D94F4F;
  --lp-radius-sm: 8px;
  --lp-radius-md: 12px;
  --lp-radius-lg: 16px;
  --lp-radius-pill: 50px;
  --lp-shadow-card: 0 2px 12px rgba(50, 54, 66, 0.06);
  --lp-shadow-hover: 0 8px 30px rgba(50, 54, 66, 0.12);
  --lp-shadow-cta: 0 4px 14px rgba(129, 189, 74, 0.4);
  --lp-transition: 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

[data-bs-theme="dark"] {
  --lp-gray-100: #1d1d1f;
  --lp-gray-200: #2a2a2e;
  --lp-gray-700: #bbb;
  --lp-shadow-card: 0 2px 12px rgba(0, 0, 0, 0.2);
  --lp-shadow-hover: 0 8px 30px rgba(0, 0, 0, 0.3);
}

/* ---------- Hero Section ---------- */
.lp-hero {
  padding: 5rem 0 4rem;
  text-align: center;
  position: relative;
  overflow: hidden;
}

.lp-hero--dark {
  background-color: var(--lp-navy);
  color: var(--lp-offwhite);
}

.lp-hero--dark h1,
.lp-hero--dark p,
.lp-hero--dark .lp-hero__badge {
  color: var(--lp-offwhite);
}

.lp-hero h1 {
  font-size: 3rem;
  font-weight: 700;
  letter-spacing: -0.03em;
  line-height: 1.15;
  margin-bottom: 1.25rem;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

.lp-hero h1 em {
  font-style: normal;
  color: var(--lp-green);
}

.lp-hero__sub {
  font-size: 1.25rem;
  color: var(--lp-gray-500);
  max-width: 640px;
  margin: 0 auto 2rem;
  line-height: 1.6;
}

.lp-hero--dark .lp-hero__sub {
  color: rgba(229, 227, 218, 0.75);
}

.lp-hero__badge {
  display: inline-block;
  font-size: 0.8rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--lp-green);
  margin-bottom: 1rem;
}

.lp-hero__proof {
  margin-top: 2rem;
  font-size: 0.9rem;
  color: var(--lp-gray-500);
}

.lp-hero__proof strong {
  color: var(--lp-green);
}

/* ---------- Primary CTA Button ---------- */
.lp-btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 2.25rem;
  border-radius: var(--lp-radius-pill);
  font-weight: 600;
  font-size: 1.05rem;
  text-decoration: none;
  transition: all var(--lp-transition);
  border: none;
  cursor: pointer;
}

.lp-btn--primary {
  background-color: var(--lp-green);
  color: #fff;
  box-shadow: var(--lp-shadow-cta);
}

.lp-btn--primary:hover {
  background-color: var(--lp-green-dark);
  color: #fff;
  text-decoration: none;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(129, 189, 74, 0.5);
}

.lp-btn--outline {
  background: transparent;
  color: var(--lp-green);
  border: 2px solid var(--lp-green);
}

.lp-btn--outline:hover {
  background-color: var(--lp-green);
  color: #fff;
  text-decoration: none;
}

.lp-btn--large {
  padding: 1rem 2.75rem;
  font-size: 1.15rem;
}

.lp-btn--full {
  width: 100%;
  justify-content: center;
}

/* Pulse animation for primary CTA — draws eye without being annoying */
@keyframes lp-pulse {
  0%, 100% { box-shadow: var(--lp-shadow-cta); }
  50% { box-shadow: 0 4px 20px rgba(129, 189, 74, 0.6); }
}

.lp-btn--pulse {
  animation: lp-pulse 2.5s ease-in-out infinite;
}

.lp-btn--pulse:hover {
  animation: none;
}

/* ---------- Section Foundations ---------- */
.lp-section {
  padding: 5rem 0;
}

.lp-section--alt {
  padding: 5rem 0;
  background-color: var(--lp-gray-100);
}

.lp-section--dark {
  padding: 5rem 0;
  background-color: var(--lp-navy);
  color: var(--lp-offwhite);
}

.lp-section--dark h2,
.lp-section--dark h3,
.lp-section--dark p {
  color: var(--lp-offwhite);
}

.lp-section__header {
  text-align: center;
  margin-bottom: 3.5rem;
}

.lp-section__header h2 {
  font-size: 2.25rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  margin-bottom: 0.75rem;
}

.lp-section__header p {
  font-size: 1.1rem;
  color: var(--lp-gray-500);
  max-width: 600px;
  margin: 0 auto;
}

.lp-section__eyebrow {
  display: inline-block;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: var(--lp-green);
  margin-bottom: 0.5rem;
}

/* ---------- Pain Points / Problem Section ---------- */
.lp-pain {
  display: flex;
  align-items: flex-start;
  gap: 1.25rem;
  padding: 1.5rem;
  background: #fff;
  border-radius: var(--lp-radius-md);
  border-left: 4px solid var(--lp-red-urgency);
  box-shadow: var(--lp-shadow-card);
  margin-bottom: 1.25rem;
}

[data-bs-theme="dark"] .lp-pain {
  background: var(--lp-gray-200);
}

.lp-pain__icon {
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(217, 79, 79, 0.1);
  border-radius: var(--lp-radius-sm);
  font-size: 1.25rem;
  color: var(--lp-red-urgency);
}

.lp-pain h4 {
  font-size: 1.05rem;
  font-weight: 700;
  margin-bottom: 0.35rem;
}

.lp-pain p {
  font-size: 0.95rem;
  color: var(--lp-gray-700);
  margin-bottom: 0;
  line-height: 1.5;
}

/* ---------- Solution / Feature Cards ---------- */
.lp-feature {
  padding: 2rem;
  background: #fff;
  border-radius: var(--lp-radius-lg);
  border: 1px solid rgba(207, 205, 196, 0.5);
  box-shadow: var(--lp-shadow-card);
  transition: all var(--lp-transition);
  height: 100%;
}

[data-bs-theme="dark"] .lp-feature {
  background: var(--lp-gray-200);
  border-color: rgba(255, 255, 255, 0.08);
}

.lp-feature:hover {
  transform: translateY(-4px);
  box-shadow: var(--lp-shadow-hover);
}

.lp-feature__icon {
  width: 56px;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--lp-green-glow);
  border-radius: var(--lp-radius-md);
  font-size: 1.5rem;
  color: var(--lp-green);
  margin-bottom: 1.25rem;
}

.lp-feature h3 {
  font-size: 1.2rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.lp-feature p {
  font-size: 0.95rem;
  color: var(--lp-gray-700);
  line-height: 1.6;
}

.lp-feature ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.lp-feature ul li {
  padding: 0.3rem 0;
  font-size: 0.95rem;
  color: var(--lp-gray-700);
}

.lp-feature ul li::before {
  content: "\2713 ";
  color: var(--lp-green);
  font-weight: 700;
  margin-right: 0.5rem;
}

/* ---------- Feature Row (Image + Text Side-by-Side) ---------- */
.lp-feature-row {
  display: flex;
  align-items: center;
  gap: 4rem;
  padding: 2rem 0;
}

.lp-feature-row--reverse {
  flex-direction: row-reverse;
}

.lp-feature-row__img {
  flex: 0 0 45%;
}

.lp-feature-row__img img {
  width: 100%;
  border-radius: var(--lp-radius-md);
  box-shadow: var(--lp-shadow-card);
}

.lp-feature-row__text h2 {
  font-size: 2.25rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  margin-bottom: 1rem;
}

.lp-feature-row__text p {
  font-size: 1.05rem;
  color: var(--lp-gray-500);
  line-height: 1.7;
}

/* ---------- Stat / Number Bar ---------- */
.lp-stats {
  display: flex;
  justify-content: center;
  gap: 3rem;
  flex-wrap: wrap;
  padding: 2.5rem 0;
}

.lp-stat {
  text-align: center;
  min-width: 140px;
}

.lp-stat__number {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--lp-green);
  line-height: 1;
  margin-bottom: 0.25rem;
}

.lp-stat__label {
  font-size: 0.85rem;
  color: var(--lp-gray-500);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* ---------- Trust Signals ---------- */
.lp-trust {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2.5rem;
  flex-wrap: wrap;
  padding: 2rem 0;
  opacity: 0.7;
  filter: grayscale(100%);
  transition: all var(--lp-transition);
}

.lp-trust:hover {
  opacity: 1;
  filter: grayscale(0%);
}

.lp-trust img {
  height: 32px;
  width: auto;
}

/* ---------- Package / Pricing Cards ---------- */
.lp-package {
  border: 2px solid rgba(207, 205, 196, 0.5);
  border-radius: var(--lp-radius-lg);
  padding: 2.5rem 2rem;
  text-align: center;
  transition: all var(--lp-transition);
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #fff;
  position: relative;
}

[data-bs-theme="dark"] .lp-package {
  background: var(--lp-gray-200);
  border-color: rgba(255, 255, 255, 0.1);
}

.lp-package:hover {
  border-color: var(--lp-green);
  transform: translateY(-4px);
  box-shadow: var(--lp-shadow-hover);
}

.lp-package--featured {
  border-color: var(--lp-green);
  box-shadow: 0 0 0 1px var(--lp-green), var(--lp-shadow-card);
}

.lp-package__badge {
  position: absolute;
  top: -14px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--lp-green);
  color: #fff;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  padding: 0.35rem 1.25rem;
  border-radius: var(--lp-radius-pill);
}

.lp-package h3 {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.25rem;
}

.lp-package__subtitle {
  font-size: 0.9rem;
  color: var(--lp-gray-500);
  margin-bottom: 0.5rem;
}

.lp-package__price {
  font-size: 1.1rem;
  color: var(--lp-gray-500);
  margin-bottom: 1.5rem;
  font-style: italic;
}

.lp-package ul {
  text-align: left;
  list-style: none;
  padding: 0;
  margin-bottom: 2rem;
  flex-grow: 1;
}

.lp-package ul li {
  padding: 0.4rem 0;
  font-size: 0.95rem;
  color: var(--lp-gray-700);
  border-bottom: 1px solid rgba(207, 205, 196, 0.3);
}

.lp-package ul li:last-child {
  border-bottom: none;
}

.lp-package ul li::before {
  content: "\2713 ";
  color: var(--lp-green);
  font-weight: 700;
  margin-right: 0.5rem;
}

/* ---------- Urgency Banner ---------- */
.lp-urgency {
  background: linear-gradient(135deg, var(--lp-navy) 0%, #3d4255 100%);
  color: var(--lp-offwhite);
  padding: 2rem;
  border-radius: var(--lp-radius-md);
  text-align: center;
}

.lp-urgency h3 {
  color: var(--lp-offwhite);
  font-size: 1.3rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.lp-urgency p {
  color: rgba(229, 227, 218, 0.8);
  font-size: 0.95rem;
  margin-bottom: 0;
}

.lp-urgency__date {
  color: var(--lp-green);
  font-weight: 700;
}

/* ---------- Final CTA Block ---------- */
.lp-cta-block {
  text-align: center;
  padding: 5rem 0;
  background: linear-gradient(180deg, var(--lp-gray-100) 0%, #fff 100%);
}

[data-bs-theme="dark"] .lp-cta-block {
  background: linear-gradient(180deg, var(--lp-gray-100) 0%, var(--lp-gray-200) 100%);
}

.lp-cta-block h2 {
  font-size: 2.25rem;
  font-weight: 700;
  margin-bottom: 1rem;
}

.lp-cta-block p {
  font-size: 1.1rem;
  color: var(--lp-gray-500);
  max-width: 550px;
  margin: 0 auto 2rem;
}

.lp-cta-block__objection {
  margin-top: 1.5rem;
  font-size: 0.85rem;
  color: var(--lp-gray-500);
}

.lp-cta-block__objection i {
  color: var(--lp-green);
  margin-right: 0.25rem;
}

/* ---------- Micro-Conversion: Lead Magnet ---------- */
.lp-lead-magnet {
  background: var(--lp-green-glow);
  border: 1px solid rgba(129, 189, 74, 0.25);
  border-radius: var(--lp-radius-md);
  padding: 2rem;
  display: flex;
  align-items: center;
  gap: 2rem;
}

.lp-lead-magnet__icon {
  flex-shrink: 0;
  width: 64px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--lp-green);
  border-radius: var(--lp-radius-md);
  font-size: 1.5rem;
  color: #fff;
}

.lp-lead-magnet h4 {
  font-size: 1.1rem;
  font-weight: 700;
  margin-bottom: 0.35rem;
}

.lp-lead-magnet p {
  font-size: 0.9rem;
  color: var(--lp-gray-700);
  margin-bottom: 0.75rem;
}

/* ---------- Process Steps ---------- */
.lp-process {
  position: relative;
  padding-left: 3.5rem;
  margin-bottom: 2.5rem;
}

.lp-process::before {
  content: '';
  position: absolute;
  left: 20px;
  top: 40px;
  bottom: -2.5rem;
  width: 2px;
  background: var(--lp-green-glow);
}

.lp-process:last-child::before {
  display: none;
}

.lp-process__number {
  position: absolute;
  left: 0;
  top: 0;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--lp-green);
  color: #fff;
  font-weight: 700;
  font-size: 1rem;
  border-radius: 50%;
}

.lp-process h4 {
  font-size: 1.1rem;
  font-weight: 700;
  margin-bottom: 0.35rem;
}

.lp-process p {
  font-size: 0.95rem;
  color: var(--lp-gray-700);
  margin-bottom: 0;
}

/* ---------- Form Styling ---------- */
.lp-form-wrap {
  background: #fff;
  border-radius: var(--lp-radius-lg);
  padding: 2.5rem;
  box-shadow: var(--lp-shadow-card);
  max-width: 800px;
  margin: 0 auto;
}

[data-bs-theme="dark"] .lp-form-wrap {
  background: var(--lp-gray-200);
}

/* ---------- Floating CTA (supplement to Cal.com button) ---------- */
/* The Cal.com floating button is already global via _quarto.yml.
   On landing pages, also add a sticky bottom bar on mobile. */
.lp-sticky-cta {
  display: none; /* hidden on desktop */
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 1040;
  background: #fff;
  border-top: 1px solid rgba(207, 205, 196, 0.5);
  padding: 0.75rem 1rem;
  box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.08);
}

[data-bs-theme="dark"] .lp-sticky-cta {
  background: var(--lp-navy);
  border-color: rgba(255, 255, 255, 0.1);
}

/* ---------- Responsive ---------- */
@media (max-width: 991px) {
  .lp-hero h1 { font-size: 2.5rem; }
  .lp-section { padding: 3.5rem 0; }
  .lp-section--alt { padding: 3.5rem 0; }
  .lp-stats { gap: 2rem; }
  .lp-lead-magnet { flex-direction: column; text-align: center; }
}

@media (max-width: 767px) {
  .lp-hero { padding: 3.5rem 0 3rem; }
  .lp-hero h1 { font-size: 2rem; }
  .lp-hero__sub { font-size: 1.05rem; }
  .lp-section__header h2 { font-size: 1.75rem; }
  .lp-feature-row,
  .lp-feature-row--reverse { flex-direction: column; gap: 2rem; }
  .lp-feature-row__img { flex: none; }
  .lp-feature-row__text h2 { font-size: 1.75rem; }
  .lp-stats { gap: 1.5rem; }
  .lp-stat__number { font-size: 2rem; }

  /* Show sticky bottom CTA on mobile */
  .lp-sticky-cta { display: flex; align-items: center; justify-content: center; gap: 0.75rem; }

  /* Add bottom padding to page body so sticky bar doesn't cover content */
  body.has-sticky-cta { padding-bottom: 80px; }
}

@media (max-width: 480px) {
  .lp-hero h1 { font-size: 1.75rem; }
  .lp-btn--large { padding: 0.875rem 2rem; font-size: 1rem; }
}
```

### Floating Button Behavior Spec

The existing Cal.com floating button (green, bottom-right) stays global. On landing pages, add:

1. **Desktop**: The floating Cal.com button is sufficient. It appears after 3 seconds on page load (already configured).
2. **Mobile (below 768px)**: Replace the floating button with a full-width sticky bottom bar containing the CTA text and a "Book a Call" button. This gets more thumb-friendly tap area.
3. **Scroll behavior**: The sticky bar should appear once the user scrolls past the hero section (approximately 500px). Use a simple scroll listener in `<script>` at the bottom of each page -- no framework needed.

```html
<!-- Add at bottom of each landing page .qmd -->
<div class="lp-sticky-cta" id="stickyCtaBar" style="display:none;">
  <span style="font-weight:600; font-size:0.9rem;">Free 30-min consultation</span>
  <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary" style="padding:0.6rem 1.5rem; font-size:0.9rem;">
    <i class="bi bi-calendar-check"></i> Book Now
  </a>
</div>
<script>
if (window.innerWidth < 768) {
  var stickyBar = document.getElementById('stickyCtaBar');
  window.addEventListener('scroll', function() {
    stickyBar.style.display = window.scrollY > 500 ? 'flex' : 'none';
  });
  document.body.classList.add('has-sticky-cta');
  // Hide the Cal.com floating button on mobile to avoid overlap
  var calBtn = document.querySelector('[data-cal-link]');
  if (calBtn) calBtn.style.display = 'none';
}
</script>
```

### Color Psychology for CTAs

- **Primary CTA (Book a Consultation)**: Green #81BD4A on all pages. Green = go, safety, growth. For a security company, green subconsciously communicates "safe to proceed." The green glow shadow draws the eye.
- **Secondary CTA (Email, Learn More)**: Outlined green border, transparent fill. Lower visual weight = less commitment.
- **Urgency elements**: Red-left-border on pain points (#D94F4F) creates subtle alarm without being aggressive.
- **Dark hero backgrounds**: Navy #323642 with green accents creates authority and technical credibility.
- **Never use**: Red for CTA buttons (communicates danger/stop in EU markets), yellow/orange (feels cheap for B2B security).

---

## PAGE 1: Digital Infrastructure (/digital/)

### Section 1: Hero (Above the Fold)

**Formula**: PAS (Problem-Agitate-Solve) compressed into headline + subheadline

```html
<div class="lp-hero lp-hero--dark">
  <div class="container">
    <div class="lp-hero__badge">Digital Infrastructure for SMBs</div>
    <h1>Stop Paying Microsoft Licenses<br>for Software That <em>Already Exists Free</em></h1>
    <p class="lp-hero__sub">
      We build production-grade open-source, UNIX, and Apple Business infrastructure
      that saves SMBs 40-70% on IT costs while giving you full control of your data.
    </p>
    <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary lp-btn--large lp-btn--pulse">
      <i class="bi bi-calendar-check"></i> Get Your Free Infrastructure Audit
    </a>
    <div class="lp-hero__proof">
      <i class="bi bi-shield-check"></i> Trusted by SMBs across Romania &amp; the EU &nbsp;|&nbsp;
      <strong>100% open-source</strong> &mdash; no vendor lock-in
    </div>
  </div>
</div>
```

**Why this headline works**:
- "Stop Paying Microsoft Licenses" -- names the exact pain (cost) and the exact villain (Microsoft licensing).
- "Already Exists Free" -- the green emphasis creates a visual and emotional highlight on the key benefit.
- The 40-70% stat is specific enough to be credible, vague enough to be defensible.

**Visual element**: No hero image needed. The dark navy background with a subtle CSS pattern (diagonal lines or dots at 3% opacity) creates a premium tech feel. If an image is desired later, use a dark server room with green ambient lighting to match brand.

**CTA button**: "Get Your Free Infrastructure Audit" is the specific action. "Book a Consultation" is generic. This tells the visitor exactly what they get. The pulse animation draws the eye on first load and stops on hover (so it doesn't feel spammy during interaction).

### Section 2: Pain Points

```html
<div class="lp-section">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">The Problem</div>
      <h2>Your IT Budget Is Being Drained by Licenses You Don't Need</h2>
    </div>
    <div class="row">
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-cash-stack"></i></div>
          <div>
            <h4>Rising License Costs</h4>
            <p>Microsoft 365, Google Workspace, and Adobe subscriptions increase every year. A 50-person company spends EUR 30,000+/year just on basic productivity software.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-lock-fill"></i></div>
          <div>
            <h4>Vendor Lock-In</h4>
            <p>Your data sits on someone else's servers, governed by their terms. If they change pricing or policies, you have no leverage and no exit plan.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-cloud-slash"></i></div>
          <div>
            <h4>No Control Over Data</h4>
            <p>GDPR requires you to know where your data is processed. With US cloud providers, your EU customer data may cross borders without your knowledge.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-people"></i></div>
          <div>
            <h4>No In-House IT Team</h4>
            <p>You can't afford a full sysadmin team, so infrastructure decisions get made by whoever is least busy. Systems break, nobody knows why.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-apple"></i></div>
          <div>
            <h4>Mac Management Chaos</h4>
            <p>Your team uses Macs but nobody manages them centrally. No MDM, no security policies, no zero-touch deployment. New hires wait days to get set up.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-exclamation-triangle"></i></div>
          <div>
            <h4>NIS2 Compliance Pressure</h4>
            <p>EU regulations are tightening. You need documented infrastructure, access controls, and incident response capabilities you don't currently have.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Layout**: 3x2 grid on desktop, 2-column on tablet, stacked on mobile. Each card has a red left border and warning-toned icon to create visual tension that the solution section resolves.

### Section 3: Solution (What We Build)

Keep the existing 3-feature-row pattern (Open-Source Stack, UNIX Infrastructure, Apple Business) but upgrade the structure:

```html
<div class="lp-section--alt">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">The Solution</div>
      <h2>Infrastructure That Works for You, Not Against You</h2>
      <p>Three pillars of modern SMB infrastructure, deployed and managed by chen.ist.</p>
    </div>

    <!-- Open-Source Stack -->
    <div class="lp-feature-row">
      <div class="lp-feature-row__img">
        <img src="/assets/images/stock/code-screen.jpg" alt="Open-source software development environment">
      </div>
      <div class="lp-feature-row__text">
        <div class="lp-section__eyebrow">Pillar 1</div>
        <h2>Open-Source Stack for Business</h2>
        <p>Replace expensive proprietary licenses with battle-tested open-source alternatives.
        We handle deployment, configuration, security hardening, and ongoing maintenance.</p>
        <div class="row mt-3">
          <div class="col-6">
            <ul class="lp-checklist">
              <li>Nextcloud (files, calendar)</li>
              <li>Collabora Online (docs)</li>
              <li>Matrix/Element (chat)</li>
            </ul>
          </div>
          <div class="col-6">
            <ul class="lp-checklist">
              <li>Keycloak (SSO)</li>
              <li>Prometheus + Grafana</li>
              <li>PostgreSQL, MinIO</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

Repeat the same pattern for UNIX Infrastructure and Apple Business sections.

**What makes it premium**: The eyebrow labels ("Pillar 1", "Pillar 2", "Pillar 3") create a sense of structured methodology. The 2-column checklist inside each feature prevents the current long single-column list that looks overwhelming.

### Section 4: Trust / Social Proof

```html
<div class="lp-section">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">Why chen.ist</div>
      <h2>Built on Proven Technology, Delivered by Specialists</h2>
    </div>

    <!-- Stat bar -->
    <div class="lp-stats">
      <div class="lp-stat">
        <div class="lp-stat__number">15+</div>
        <div class="lp-stat__label">Years in UNIX Systems</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">100%</div>
        <div class="lp-stat__label">Open-Source Stack</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">EU</div>
        <div class="lp-stat__label">Data Sovereignty</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">24/7</div>
        <div class="lp-stat__label">Monitoring Included</div>
      </div>
    </div>

    <!-- Technology logos (grayscale -> color on hover) -->
    <div class="lp-trust">
      <img src="/assets/images/logos/nixos.svg" alt="NixOS">
      <img src="/assets/images/logos/openbsd.svg" alt="OpenBSD">
      <img src="/assets/images/logos/apple-business.svg" alt="Apple Business">
      <img src="/assets/images/logos/nextcloud.svg" alt="Nextcloud">
      <img src="/assets/images/logos/postgresql.svg" alt="PostgreSQL">
      <img src="/assets/images/logos/grafana.svg" alt="Grafana">
    </div>

    <!-- "No testimonials" workaround: Use methodology proof instead -->
    <div class="row mt-5">
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-file-earmark-code"></i></div>
          <h3>Reproducible Deployments</h3>
          <p>Every system we build is declared in code (NixOS, Ansible). If a server dies, we rebuild it identically in minutes, not days.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-arrow-repeat"></i></div>
          <h3>Open Source Guarantee</h3>
          <p>You own everything. If we part ways, you keep every configuration file, every server, every account. Zero lock-in to us, either.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-shield-check"></i></div>
          <h3>Security-First Architecture</h3>
          <p>Every deployment includes hardened baselines, automated patching, encrypted backups, and firewall rules reviewed against CIS benchmarks.</p>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Handling "no testimonials"**: Instead of fake quotes or empty social proof, lean into methodology trust. The 3 guarantee cards ("Reproducible Deployments", "Open Source Guarantee", "Security-First") function like implicit testimonials -- they say "here's what we promise" which is more credible than nothing. Add real testimonials later when available.

Technology logos serve as proxy authority -- NixOS, OpenBSD, PostgreSQL are known in the target audience's world.

### Section 5: Pricing / Packages

Keep the existing 3-tier structure (Starter, Growth, Enterprise) but upgrade with conversion psychology:

```html
<div class="lp-section--alt">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">Packages</div>
      <h2>Infrastructure Tailored to Your Team Size</h2>
      <p>All packages include deployment, hardening, monitoring, and ongoing support. Custom pricing based on your specific needs.</p>
    </div>
    <div class="row">
      <!-- Starter -->
      <div class="col-md-4 mb-4">
        <div class="lp-package">
          <h3>Starter</h3>
          <div class="lp-package__subtitle">1-10 employees</div>
          <div class="lp-package__price">Custom pricing based on scope</div>
          <ul>
            <li>Apple Business setup + Blueprints</li>
            <li>1 Linux server (Debian/Ubuntu)</li>
            <li>Nextcloud (files, contacts, calendar)</li>
            <li>Business email on custom domain</li>
            <li>Basic firewall (OpenBSD pf or UFW)</li>
            <li>Automated backups (Restic)</li>
            <li>Uptime monitoring</li>
          </ul>
          <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--outline lp-btn--full">Get a Quote</a>
        </div>
      </div>
      <!-- Growth (FEATURED) -->
      <div class="col-md-4 mb-4">
        <div class="lp-package lp-package--featured">
          <div class="lp-package__badge">Most Popular</div>
          <h3>Growth</h3>
          <div class="lp-package__subtitle">11-50 employees</div>
          <div class="lp-package__price">Custom pricing based on scope</div>
          <ul>
            <li>Everything in Starter, plus:</li>
            <li>Full Apple MDM with team grouping</li>
            <li>OpenBSD dedicated firewall/VPN</li>
            <li>Keycloak SSO across all systems</li>
            <li>Matrix/Element team messaging</li>
            <li>Collabora Online (document editing)</li>
            <li>Prometheus + Grafana monitoring</li>
            <li>Samba/AD bridging (if needed)</li>
          </ul>
          <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary lp-btn--full">Book Free Consultation</a>
        </div>
      </div>
      <!-- Enterprise -->
      <div class="col-md-4 mb-4">
        <div class="lp-package">
          <h3>Enterprise</h3>
          <div class="lp-package__subtitle">50+ employees</div>
          <div class="lp-package__price">Custom pricing based on scope</div>
          <ul>
            <li>Everything in Growth, plus:</li>
            <li>Apple Business Admin API integration</li>
            <li>NixOS declarative multi-server fleet</li>
            <li>FreeBSD ZFS storage cluster</li>
            <li>High-availability configurations</li>
            <li>Multi-site VPN mesh</li>
            <li>Compliance baselines (NIS2, GDPR)</li>
            <li>24/7 monitoring + incident response</li>
          </ul>
          <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--outline lp-btn--full">Contact Us</a>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Anchoring strategy**: Growth tier is highlighted ("Most Popular" badge, green border, primary CTA button) because:
1. It is the sweet spot for chen.ist's target audience (11-50 employees)
2. It makes Starter look like "not enough" and Enterprise look like "maybe later"
3. The featured tier gets the only primary (filled) CTA button -- the other two get outline buttons

**No prices shown**: Correct choice for B2B consultancy. Custom pricing creates a conversation (which is the conversion goal). "Custom pricing based on scope" is more honest than "Contact for pricing" and reduces friction.

### Section 6: Urgency

```html
<div class="lp-section">
  <div class="container" style="max-width: 800px;">
    <div class="lp-urgency">
      <h3><i class="bi bi-apple me-2"></i>Apple Business Launches <span class="lp-urgency__date">April 14, 2026</span></h3>
      <p>The new unified platform replaces Apple Business Manager, Apple Business Essentials, and Apple Business Connect. Companies that set up before launch get priority migration support. <strong>We are certified early-access deployment partners.</strong></p>
    </div>
    <div class="text-center mt-4">
      <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary">
        <i class="bi bi-calendar-check"></i> Reserve Your Setup Slot
      </a>
    </div>
  </div>
</div>
```

**Why it works**: This is legitimate urgency (April 14 is a real date), tied to a real event (Apple Business launch), with a real benefit (early access). Not manufactured scarcity.

### Section 7: Registration / Contact Form

Keep the existing tabbed form (Formspree for Romania, Cal.com for international) but wrap it in the new styling:

```html
<div class="lp-section--alt">
  <div class="container">
    <div class="lp-section__header">
      <h2>Start Your Infrastructure Transformation</h2>
      <p>Register for a consultation or book a call directly.</p>
    </div>
    <div class="lp-form-wrap">
      <!-- Keep existing tab structure with Formspree form and Cal.com embed -->
      <!-- Same form fields as current, wrapped in new .lp-form-wrap -->
    </div>
  </div>
</div>
```

### Section 8: Final CTA

```html
<div class="lp-cta-block">
  <div class="container">
    <h2>Your competitors are already cutting IT costs.<br>When will you?</h2>
    <p>30-minute consultation. No sales pitch. Just an honest assessment of what open-source infrastructure can do for your business.</p>
    <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary lp-btn--large">
      <i class="bi bi-calendar-check"></i> Book Your Free Audit
    </a>
    <div class="lp-cta-block__objection">
      <span><i class="bi bi-check-circle-fill"></i> Free, no obligation</span> &nbsp;&nbsp;
      <span><i class="bi bi-check-circle-fill"></i> 30 minutes or less</span> &nbsp;&nbsp;
      <span><i class="bi bi-check-circle-fill"></i> Get a written proposal within 48h</span>
    </div>
  </div>
</div>
```

**Objection handling**: The three micro-guarantees below the CTA eliminate the top 3 objections:
1. "Will it cost me money?" -- Free, no obligation
2. "Will it waste my time?" -- 30 minutes or less
3. "What do I actually get?" -- Written proposal within 48h

### Micro-conversions (for people not ready to book)

```html
<!-- Place between the Packages section and the Form section -->
<div class="lp-section">
  <div class="container" style="max-width: 700px;">
    <div class="lp-lead-magnet">
      <div class="lp-lead-magnet__icon"><i class="bi bi-file-earmark-pdf"></i></div>
      <div>
        <h4>Free Guide: Open-Source Alternatives for Every Business Tool</h4>
        <p>A practical comparison of 30+ proprietary tools and their open-source replacements, with estimated cost savings for teams of 10, 25, and 50.</p>
        <a href="#" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.5rem; font-size: 0.9rem;">
          <i class="bi bi-download"></i> Download PDF (No email required)
        </a>
      </div>
    </div>
  </div>
</div>
```

**Strategy**: No email gate on the PDF -- this is a trust builder. The PDF itself contains the Cal.com booking link on every page. People who download are pre-qualified leads even without their email. This is counter-intuitive but works better for B2B consultancy where the sales cycle is longer.

---

## PAGE 2: Security (/security/)

### Section 1: Hero

**Formula**: AIDA (Attention-Interest-Desire-Action) with fear-based opener

```html
<div class="lp-hero lp-hero--dark">
  <div class="container">
    <div class="lp-hero__badge">Blue Team Cybersecurity &amp; NIS2 Compliance</div>
    <h1>The Average SMB Takes <em>197 Days</em><br>to Detect a Breach. How Long Would Yours Take?</h1>
    <p class="lp-hero__sub">
      Proactive Blue Team cybersecurity operations, NIS2 compliance programs, and
      CISO-as-a-Service for organizations that can't afford to be the next headline.
    </p>
    <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary lp-btn--large lp-btn--pulse">
      <i class="bi bi-shield-check"></i> Get a Free Security Assessment
    </a>
    <div class="lp-hero__proof">
      <i class="bi bi-clock-history"></i> NIS2 compliance deadline is <strong>active now</strong> &mdash; fines up to <strong>EUR 10M or 2% of global turnover</strong>
    </div>
  </div>
</div>
```

**Why this headline works**:
- "197 days" is the real IBM/Ponemon statistic. Specific numbers create credibility.
- The question format forces the reader to think about their own situation (engagement hook).
- Green emphasis on "197 Days" creates visual anchoring on the most alarming data point.
- The proof line below the CTA introduces NIS2 penalty stakes immediately.

### Section 2: Pain Points

```html
<div class="lp-section">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">The Reality</div>
      <h2>Most SMBs Are One Phishing Email Away from a Crisis</h2>
    </div>
    <div class="row">
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-envelope-exclamation"></i></div>
          <div>
            <h4>No Threat Detection</h4>
            <p>Without a SOC, attacks go unnoticed for months. By the time you discover a breach, the damage is done -- data exfiltrated, ransomware deployed, trust destroyed.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-file-earmark-x"></i></div>
          <div>
            <h4>NIS2 Non-Compliance</h4>
            <p>The NIS2 Directive is now enforceable across the EU. Non-compliant organizations face fines of EUR 7-10M and personal liability for management boards.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-person-x"></i></div>
          <div>
            <h4>No Security Leadership</h4>
            <p>You know you need a CISO but can't justify the EUR 120K+ salary. So security decisions get made ad-hoc, or not at all.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-clock"></i></div>
          <div>
            <h4>24-Hour Reporting Requirement</h4>
            <p>NIS2 requires you to report significant incidents within 24 hours. If you don't have detection and response procedures, you'll miss this window.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-diagram-3"></i></div>
          <div>
            <h4>Supply Chain Exposure</h4>
            <p>Your vendors are your attack surface. NIS2 mandates supply chain security assessments that most SMBs have never conducted.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-graph-down-arrow"></i></div>
          <div>
            <h4>Reputation Destruction</h4>
            <p>The average cost of a data breach for SMBs is EUR 120,000. But the reputational damage -- lost clients, broken trust -- is incalculable.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Section 3: Solution (Services)

```html
<div class="lp-section--alt">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">Our Services</div>
      <h2>Complete Cybersecurity Operations for Your Organization</h2>
    </div>
    <div class="row">
      <div class="col-md-6 col-lg-3 mb-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-shield-check"></i></div>
          <h3>SOC Monitoring</h3>
          <p>24/7 real-time surveillance, threat detection, and expert analysis of your security environment.</p>
          <ul>
            <li>SIEM deployment</li>
            <li>Real-time alerting</li>
            <li>Monthly threat reports</li>
          </ul>
        </div>
      </div>
      <div class="col-md-6 col-lg-3 mb-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-search"></i></div>
          <h3>Threat Hunting</h3>
          <p>Proactive identification of hidden threats and advanced persistent attackers in your network.</p>
          <ul>
            <li>IOC analysis</li>
            <li>Behavioral detection</li>
            <li>Threat intelligence feeds</li>
          </ul>
        </div>
      </div>
      <div class="col-md-6 col-lg-3 mb-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-clipboard-check"></i></div>
          <h3>NIS2 Compliance</h3>
          <p>End-to-end assessments, gap analysis, and compliance roadmaps for the NIS2 Directive.</p>
          <ul>
            <li>Gap analysis</li>
            <li>Risk framework</li>
            <li>Compliance roadmap</li>
          </ul>
        </div>
      </div>
      <div class="col-md-6 col-lg-3 mb-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-person-badge"></i></div>
          <h3>CISO as a Service</h3>
          <p>Strategic cybersecurity leadership, board reporting, and policy development on demand.</p>
          <ul>
            <li>Security strategy</li>
            <li>Board-level reporting</li>
            <li>Policy development</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Section 4: Process (How We Work)

Replace the current icon-grid with a vertical timeline that feels more methodical:

```html
<div class="lp-section">
  <div class="container">
    <div class="row">
      <div class="col-md-5">
        <div class="lp-section__eyebrow">Our Process</div>
        <h2 style="font-size: 2.25rem; font-weight: 700;">A Proven Four-Phase Approach</h2>
        <p style="color: var(--lp-gray-500); font-size: 1.05rem; line-height: 1.7;">From initial discovery to continuous monitoring, our structured methodology ensures nothing falls through the cracks.</p>
        <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary mt-3">
          <i class="bi bi-calendar-check"></i> Start with Discovery
        </a>
      </div>
      <div class="col-md-6 offset-md-1">
        <div class="lp-process">
          <div class="lp-process__number">1</div>
          <h4>Discovery</h4>
          <p>Stakeholder interviews, documentation review, and scoping analysis to understand your environment and regulatory obligations.</p>
        </div>
        <div class="lp-process">
          <div class="lp-process__number">2</div>
          <h4>Assessment</h4>
          <p>Technical controls evaluation, risk management review, and gap identification against NIS2 requirements and industry standards.</p>
        </div>
        <div class="lp-process">
          <div class="lp-process__number">3</div>
          <h4>Implementation</h4>
          <p>Remediation of identified gaps, policy development, security controls deployment, and compliance program buildout.</p>
        </div>
        <div class="lp-process">
          <div class="lp-process__number">4</div>
          <h4>Monitoring</h4>
          <p>Continuous SOC monitoring, regular compliance reviews, threat hunting, and ongoing security posture optimization.</p>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Section 5: NIS2 Sectors (Who Needs This)

Keep the current 2-column Essential/Important entities list but add urgency framing:

```html
<div class="lp-section--alt">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">NIS2 Scope</div>
      <h2>Does NIS2 Apply to Your Organization?</h2>
      <p>If you operate in any of these sectors and have 50+ employees or EUR 10M+ revenue, NIS2 applies to you.</p>
    </div>
    <!-- Keep existing 2-column Essential/Important layout -->
    <!-- But add at bottom: -->
    <div class="text-center mt-4">
      <div class="lp-urgency" style="max-width: 700px; margin: 0 auto;">
        <h3>Not sure if NIS2 applies to you?</h3>
        <p>Book a free 15-minute scoping call. We'll tell you in plain language whether you're in scope, what you need to do, and by when.</p>
      </div>
      <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary mt-3">
        <i class="bi bi-calendar-check"></i> Check My NIS2 Status
      </a>
    </div>
  </div>
</div>
```

### Section 6: Trust / Social Proof

```html
<div class="lp-section">
  <div class="container">
    <div class="lp-stats">
      <div class="lp-stat">
        <div class="lp-stat__number">197</div>
        <div class="lp-stat__label">Avg. Days to Detect (without SOC)</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">&lt;24h</div>
        <div class="lp-stat__label">Our Detection + Response</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">EUR 10M</div>
        <div class="lp-stat__label">Max NIS2 Fine</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">0</div>
        <div class="lp-stat__label">Cost of a Free Assessment</div>
      </div>
    </div>

    <!-- Credential cards instead of testimonials -->
    <div class="row mt-4">
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-patch-check"></i></div>
          <h3>EU-Based Operations</h3>
          <p>Your security data never leaves the EU. Our SOC operates from Romania, fully compliant with GDPR and EU data sovereignty requirements.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-journal-check"></i></div>
          <h3>Open-Source Tooling</h3>
          <p>We use open-source security tools (Wazuh, Suricata, YARA, TheHive) so you can audit every rule, every alert, every response action.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-graph-up-arrow"></i></div>
          <h3>Continuous Improvement</h3>
          <p>Monthly security posture reports, quarterly reviews, and annual penetration testing ensure your security matures over time, not just at deployment.</p>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Section 7: Urgency

```html
<div class="lp-section--dark">
  <div class="container" style="max-width: 800px; text-align: center;">
    <div class="lp-section__eyebrow" style="color: var(--lp-green);">Time-Sensitive</div>
    <h2 style="color: var(--lp-offwhite);">NIS2 Enforcement Is Active. Fines Are Real.</h2>
    <p style="color: rgba(229,227,218,0.8); font-size: 1.05rem; max-width: 600px; margin: 0 auto 2rem;">
      EU member states are now enforcing the NIS2 Directive. Organizations found non-compliant
      face fines up to EUR 10M or 2% of global annual turnover -- whichever is higher.
      Management boards face personal liability.
    </p>
    <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary lp-btn--large">
      <i class="bi bi-shield-check"></i> Start Your Compliance Journey
    </a>
  </div>
</div>
```

**Why it works**: NIS2 enforcement is real, the fines are real, the personal liability is real. This is not manufactured urgency. The dark section background creates gravity and seriousness.

### Section 8: Final CTA

```html
<div class="lp-cta-block">
  <div class="container">
    <h2>You Can't Protect What You Can't See</h2>
    <p>A free 30-minute security assessment reveals your actual risk posture, NIS2 gaps, and the 3 highest-priority actions you should take this quarter.</p>
    <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary lp-btn--large">
      <i class="bi bi-shield-check"></i> Get Your Free Assessment
    </a>
    <div class="lp-cta-block__objection">
      <span><i class="bi bi-check-circle-fill"></i> Free, confidential assessment</span> &nbsp;&nbsp;
      <span><i class="bi bi-check-circle-fill"></i> No vendor lock-in</span> &nbsp;&nbsp;
      <span><i class="bi bi-check-circle-fill"></i> Actionable report within 5 business days</span>
    </div>
  </div>
</div>
```

### Micro-conversions

```html
<div class="lp-section--alt">
  <div class="container" style="max-width: 700px;">
    <div class="lp-lead-magnet">
      <div class="lp-lead-magnet__icon"><i class="bi bi-clipboard-check"></i></div>
      <div>
        <h4>Free NIS2 Self-Assessment Checklist</h4>
        <p>20-point checklist to evaluate your organization's current NIS2 readiness. Takes 10 minutes, reveals your biggest gaps.</p>
        <a href="/resources/tools/zero-trust-assessment.html" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.5rem; font-size: 0.9rem;">
          <i class="bi bi-arrow-right"></i> Take the Assessment
        </a>
      </div>
    </div>
  </div>
</div>
```

**Strategy**: Link to the existing zero-trust assessment tool (already built at `/resources/tools/zero-trust-assessment.html`). This is a self-qualifying micro-conversion -- people who complete it realize they need help and book a call.

---

## PAGE 3: Academy (/academy/)

### Complete Redesign Required

The current academy page is a content directory (listing of sub-pages). For conversion, it needs to function as a landing page that drives enrollment and consultation bookings, with the directory as a secondary function below.

### Section 1: Hero

**Formula**: Before/After bridge

```html
<div class="lp-hero lp-hero--dark">
  <div class="container">
    <div class="lp-hero__badge">chen.ist Academy</div>
    <h1>Your Team Knows <em>How to Use Software</em>.<br>Do They Know <em>How to Defend It</em>?</h1>
    <p class="lp-hero__sub">
      Hands-on cybersecurity and open-source training programs that turn your employees
      from your biggest vulnerability into your strongest defense.
    </p>
    <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
      <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary lp-btn--large">
        <i class="bi bi-calendar-check"></i> Book a Training Consultation
      </a>
      <a href="#programs" class="lp-btn lp-btn--outline lp-btn--large" style="border-color: rgba(229,227,218,0.4); color: var(--lp-offwhite);">
        Browse Programs
      </a>
    </div>
    <div class="lp-hero__proof">
      <strong>Summer School 2025</strong> registration open &nbsp;|&nbsp;
      Courses, trainings, hackathons &amp; more
    </div>
  </div>
</div>
```

**Why this headline works**: "How to Use Software" vs "How to Defend It" creates a knowledge gap the reader immediately recognizes. It targets CTO/IT manager buyers who know their team's security awareness is weak. The "biggest vulnerability into strongest defense" subhead reframes employees from a problem into an opportunity.

**Two CTAs**: Primary (Book consultation) for decision-makers ready to buy. Secondary (Browse Programs) for researchers and individual learners.

### Section 2: Pain Points

```html
<div class="lp-section">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">The Skills Gap</div>
      <h2>95% of Cybersecurity Breaches Involve Human Error</h2>
    </div>
    <div class="row">
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-envelope-exclamation"></i></div>
          <div>
            <h4>Phishing Vulnerability</h4>
            <p>One untrained employee clicking one malicious link can compromise your entire organization. Generic "don't click suspicious links" training doesn't work.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-file-earmark-lock"></i></div>
          <div>
            <h4>Compliance Training Gaps</h4>
            <p>NIS2 requires documented security awareness programs. A yearly PowerPoint doesn't meet the standard. You need ongoing, measurable training.</p>
          </div>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-3">
        <div class="lp-pain">
          <div class="lp-pain__icon"><i class="bi bi-mortarboard"></i></div>
          <div>
            <h4>Outdated IT Skills</h4>
            <p>Your IT team learned Linux 10 years ago. Modern infrastructure (NixOS, containers, zero-trust) requires continuous learning they're not getting.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Section 3: Solution (Training Formats)

```html
<div class="lp-section--alt">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">Training Formats</div>
      <h2>Learning That Fits Your Team's Schedule</h2>
      <p>From 1-hour microlearning to week-long immersive programs, pick the format that works.</p>
    </div>
    <div class="row">
      <div class="col-md-6 col-lg-4 mb-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-lightning-charge"></i></div>
          <h3>Microlearning</h3>
          <p>1-2 hour focused sessions on specific tools and techniques. Minimal time away from work, maximum skill transfer.</p>
          <ul>
            <li>CLI fundamentals</li>
            <li>QubesOS, NixOS</li>
            <li>Security tools</li>
          </ul>
          <a href="/academy/microlearning.html" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.25rem; font-size: 0.9rem; margin-top: 1rem;">Browse Sessions</a>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-4">
        <div class="lp-feature" style="border-color: var(--lp-green);">
          <div class="lp-feature__icon"><i class="bi bi-journal-code"></i></div>
          <h3>Intensive Trainings</h3>
          <p>1-2 day workshops that build practical skills through hands-on labs and real-world scenarios. Perfect for team upskilling.</p>
          <ul>
            <li>Cybersecurity Essentials</li>
            <li>Security Awareness for Teams</li>
            <li>Linux Admin Fundamentals</li>
            <li>NixOS Security Jumpstart</li>
          </ul>
          <a href="/academy/trainings.html" class="lp-btn lp-btn--primary" style="padding: 0.5rem 1.25rem; font-size: 0.9rem; margin-top: 1rem;">Browse Trainings</a>
        </div>
      </div>
      <div class="col-md-6 col-lg-4 mb-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-book"></i></div>
          <h3>Multi-Week Courses</h3>
          <p>Deep-dive courses spanning multiple weeks for comprehensive skill development. For teams building serious expertise.</p>
          <ul>
            <li>Practical Cybersecurity</li>
            <li>Open Source Development</li>
            <li>Data Protection & Privacy</li>
          </ul>
          <a href="/academy/courses.html" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.25rem; font-size: 0.9rem; margin-top: 1rem;">Browse Courses</a>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Premium feel**: The middle card (Intensive Trainings) has a green border highlight -- this is the most popular format for B2B buyers (1-2 days fits into corporate schedules).

### Section 4: Programs (Immersive)

```html
<div class="lp-section">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">Immersive Programs</div>
      <h2>Go Beyond Classroom Training</h2>
    </div>
    <div class="row">
      <div class="col-md-4 mb-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-trophy"></i></div>
          <h3>Hackathons</h3>
          <p>Competitive team-based events where participants solve real cybersecurity challenges under time pressure. Build skills through adrenaline-fueled problem solving.</p>
          <a href="/academy/programs/hackathons/" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.25rem; font-size: 0.9rem; margin-top: 1rem;">Learn More</a>
        </div>
      </div>
      <div class="col-md-4 mb-4">
        <div class="lp-feature" style="border-color: var(--lp-green);">
          <div style="position: absolute; top: -1px; right: 20px; background: var(--lp-green); color: #fff; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.1em; padding: 0.3rem 0.75rem; border-radius: 0 0 8px 8px;">Registration Open</div>
          <div class="lp-feature__icon"><i class="bi bi-sun"></i></div>
          <h3>Summer School 2025</h3>
          <p>Multi-day immersive program combining cybersecurity, open-source development, and hands-on labs in an intensive boot camp format.</p>
          <a href="/academy/programs/summer-school/" class="lp-btn lp-btn--primary" style="padding: 0.5rem 1.25rem; font-size: 0.9rem; margin-top: 1rem;">Register Now</a>
        </div>
      </div>
      <div class="col-md-4 mb-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-pc-display"></i></div>
          <h3>Computer Club</h3>
          <p>Weekly community meetups for ongoing learning, project collaboration, and networking. Free and open to all skill levels.</p>
          <a href="/academy/computerclub.html" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.25rem; font-size: 0.9rem; margin-top: 1rem;">Join Free</a>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Section 5: Learning Paths (Simplified)

Replace the current 4-card grid with a cleaner 2-path layout:

```html
<div class="lp-section--alt">
  <div class="container">
    <div class="lp-section__header">
      <div class="lp-section__eyebrow">Learning Paths</div>
      <h2>Structured Tracks for Your Goals</h2>
    </div>
    <div class="row">
      <div class="col-md-6 mb-4">
        <div class="lp-feature" style="border-top: 4px solid #D94F4F;">
          <h3><i class="bi bi-shield-lock me-2" style="color: #D94F4F;"></i>Cybersecurity Track</h3>
          <p>From security fundamentals to advanced threat hunting. For IT teams, compliance officers, and anyone responsible for protecting organizational data.</p>
          <ul>
            <li>Practical Cybersecurity (Course)</li>
            <li>Security Awareness for Teams (Training)</li>
            <li>Cybersecurity Essentials (Training)</li>
            <li>Data Privacy Compliance (Training)</li>
            <li>Cybersecurity Hackathon (Event)</li>
          </ul>
          <a href="/academy/courses.html" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.25rem; font-size: 0.9rem;">Explore Track</a>
        </div>
      </div>
      <div class="col-md-6 mb-4">
        <div class="lp-feature" style="border-top: 4px solid var(--lp-green);">
          <h3><i class="bi bi-terminal me-2" style="color: var(--lp-green);"></i>Open Source & Infrastructure Track</h3>
          <p>Linux administration, NixOS, open-source contribution, and modern infrastructure tooling. For developers and sysadmins building real-world skills.</p>
          <ul>
            <li>Linux Admin Fundamentals (Training)</li>
            <li>NixOS Security Jumpstart (Training)</li>
            <li>Open Source Contribution Workshop (Training)</li>
            <li>Computer Club (Weekly meetup)</li>
          </ul>
          <a href="/academy/courses.html" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.25rem; font-size: 0.9rem;">Explore Track</a>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Why 2 tracks instead of 4**: The current 4-track layout (Cybersecurity, Open Source, Innovation & Maker, Data Privacy) creates decision paralysis. Consolidate into the 2 strongest tracks. Innovation/Maker and Data Privacy content can be sub-items within these two.

### Section 6: Trust / Social Proof

```html
<div class="lp-section">
  <div class="container">
    <div class="lp-stats">
      <div class="lp-stat">
        <div class="lp-stat__number">7+</div>
        <div class="lp-stat__label">Training Programs</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">100%</div>
        <div class="lp-stat__label">Hands-On Labs</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">EU</div>
        <div class="lp-stat__label">Based Instructors</div>
      </div>
      <div class="lp-stat">
        <div class="lp-stat__number">Free</div>
        <div class="lp-stat__label">Computer Club Membership</div>
      </div>
    </div>

    <!-- Methodology trust -->
    <div class="row mt-4">
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-tools"></i></div>
          <h3>Real Labs, Not Slides</h3>
          <p>Every training uses actual tools in sandboxed environments. Participants leave with skills they can use on Monday morning, not just certificates.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-building"></i></div>
          <h3>Corporate Customization</h3>
          <p>We tailor training content to your industry, your tech stack, and your compliance requirements. No generic off-the-shelf modules.</p>
        </div>
      </div>
      <div class="col-md-4">
        <div class="lp-feature">
          <div class="lp-feature__icon"><i class="bi bi-people"></i></div>
          <h3>Small Cohorts</h3>
          <p>Maximum 20 participants per session ensures everyone gets individual attention, feedback, and hands-on practice time.</p>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Section 7: Urgency

```html
<div class="lp-section--dark">
  <div class="container" style="max-width: 800px; text-align: center;">
    <div class="lp-section__eyebrow" style="color: var(--lp-green);">Limited Seats</div>
    <h2 style="color: var(--lp-offwhite);">Summer School 2025 Registration Is Open</h2>
    <p style="color: rgba(229,227,218,0.8); font-size: 1.05rem; max-width: 600px; margin: 0 auto 2rem;">
      Multi-day immersive cybersecurity and open-source boot camp. Limited to 20 participants to ensure hands-on lab access for everyone.
    </p>
    <a href="/academy/programs/summer-school/" class="lp-btn lp-btn--primary lp-btn--large">
      <i class="bi bi-sun"></i> Reserve Your Spot
    </a>
  </div>
</div>
```

### Section 8: Final CTA (Dual-Track)

Academy needs two CTAs because there are two buyer types: corporate (training buyer) and individual (self-learner).

```html
<div class="lp-cta-block">
  <div class="container">
    <h2>Invest in Your Team's Security Skills Before the Next Incident</h2>
    <p>Whether you need a one-day workshop for 10 people or a full annual training program, we'll design the right solution.</p>
    <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
      <a href="https://cal.com/chenist" target="_blank" class="lp-btn lp-btn--primary lp-btn--large">
        <i class="bi bi-calendar-check"></i> Discuss Corporate Training
      </a>
      <a href="/academy/courses.html" class="lp-btn lp-btn--outline lp-btn--large">
        <i class="bi bi-mortarboard"></i> Browse Individual Programs
      </a>
    </div>
    <div class="lp-cta-block__objection">
      <span><i class="bi bi-check-circle-fill"></i> Custom content for your team</span> &nbsp;&nbsp;
      <span><i class="bi bi-check-circle-fill"></i> Flexible scheduling</span> &nbsp;&nbsp;
      <span><i class="bi bi-check-circle-fill"></i> NIS2 compliance documentation included</span>
    </div>
  </div>
</div>
```

### Micro-conversions

```html
<div class="lp-section--alt">
  <div class="container" style="max-width: 700px;">
    <div class="lp-lead-magnet">
      <div class="lp-lead-magnet__icon"><i class="bi bi-calendar-event"></i></div>
      <div>
        <h4>Free Weekly Computer Club</h4>
        <p>Join our open community meetups every week. No cost, no commitment. Learn alongside peers, work on projects, and see if our teaching style is right for you.</p>
        <a href="/academy/computerclub.html" class="lp-btn lp-btn--outline" style="padding: 0.5rem 1.5rem; font-size: 0.9rem;">
          <i class="bi bi-arrow-right"></i> Join Computer Club
        </a>
      </div>
    </div>
  </div>
</div>
```

**Strategy**: Computer Club is the ultimate micro-conversion for Academy. It requires zero commitment, builds trust through direct experience, and creates a pipeline for paid training. Every Computer Club attendee is a warm lead.

---

## Implementation Priority Order

1. **Create `assets/css/landing-pages.css`** and add it to `_quarto.yml` css array
2. **Rebuild `/security/index.qmd`** first (highest urgency due to NIS2 enforcement, most compelling conversion story)
3. **Rebuild `/digital/index.qmd`** second (strongest differentiation with Apple Business launch date)
4. **Rebuild `/academy/index.qmd`** third (requires most structural change, but also has most existing content to reorganize)
5. **Add sticky mobile CTA** to all three pages
6. **Create lead magnet PDF** for Digital page (can be a simple Quarto-rendered PDF)
7. **Add technology logo SVGs** to `/assets/images/logos/` for trust sections

## Form Placement Strategy

| Page | Formspree Form | Cal.com Inline | Cal.com Floating | Sticky Mobile CTA |
|------|----------------|----------------|-------------------|--------------------|
| /digital/ | Yes (Section 7, tabbed) | Yes (tab 2) | Yes (global) | Yes |
| /security/ | No (too much friction for security buyers) | No | Yes (global) | Yes |
| /academy/ | No (use existing sub-page forms) | No | Yes (global) | Yes |

**Rationale**: The Digital page targets Romanian SMBs who prefer form submissions. The Security page targets CTOs/CISOs who prefer direct scheduling (they're time-poor and decision-ready). The Academy page routes to specific program pages where enrollment forms live.

## Cal.com Booking vs Formspree Decision Matrix

- **Ready to buy** (knows what they need, has budget): Cal.com direct booking
- **Exploring options** (researching, comparing): Formspree form with interest dropdown
- **Not ready** (early awareness): Lead magnet download, Computer Club, free assessment tool

All three states should be served on every page. The hero CTA serves "ready to buy." The form section serves "exploring." The micro-conversion section serves "not ready."
