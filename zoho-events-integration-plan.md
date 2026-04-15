# Zoho Events & Bookings integration plan

Goal: replace the hand-maintained `alin-mechenici.ics` and `Formspree` invite form with a Zoho-backed system that:

1. Lets Alin manage **public events** (hackathons, summer school, conferences) + **private 1:1 bookings** (CISO calls, consults) from one place.
2. Auto-generates the iCal feed at `chen.ist/alinmechenici.ics` from the live Zoho calendar.
3. Captures speaking-invite leads directly into **Bigin CRM** (already in the stack).
4. Keeps the static Quarto site unchanged — no CMS, no database, no server runtime.

---

## Stack decision

| Layer | Tool | Why |
|---|---|---|
| 1:1 bookings (CISO consultancy, general calls) | **Zoho Bookings** (free tier: 1 user, unlimited bookings) | Replaces the current Cal.com link for CISO calls; keeps lead data in-tenant. Cal.com can stay for `/booking/` overflow. |
| Public event calendar | **Zoho Calendar** (free, built into Zoho One/Mail) | Single source of truth for talks, hackathons, trainings. Public share URL → iCal feed. |
| Lead capture (invites) | **Zoho Forms** (free tier: 3 forms, 500 submits/mo) | Replaces Formspree; posts directly to Bigin. |
| CRM | **Zoho Bigin** (already in use) | Auto-creates a Deal in a "Speaking" pipeline when a Forms submission arrives. |
| Automation | **Zoho Flow** (free tier: 5 flows, 1000 tasks/mo) OR plain Zoho API + GitHub Action | Keeps the static site's iCal feed in sync. |

Total cost: **€0** at current volumes. Upgrade path: Zoho One (€37/user/mo) if Alin wants Campaigns, Desk, Sign in the same tenant.

---

## Architecture

```
                    ┌──────────────────────────────┐
                    │   Zoho Calendar              │
                    │   (alin@chen.ist tenant)     │
                    │                              │
  Alin creates ───▶ │ · Public: "chen.ist public"  │──┐
  event via UI      │ · Private: "chen.ist CISO"   │  │
                    └──────────────────────────────┘  │
                                                      │ iCal export URL
                                                      ▼
                    ┌──────────────────────────────┐
                    │ GitHub Action (nightly)      │
                    │ .github/workflows/sync-ics   │
                    │                              │
                    │ 1. curl Zoho iCal export     │
                    │ 2. normalise + stamp         │
                    │ 3. commit if changed         │
                    │ 4. triggers Pages rebuild    │
                    └──────────────────────────────┘
                                                      │
                                                      ▼
                    ┌──────────────────────────────┐
                    │ chen.ist/alinmechenici.ics   │
                    │ (static, served from _site)  │
                    └──────────────────────────────┘

  Visitor fills ──▶ Zoho Forms "invite-alin" ──▶ Zoho Flow ──┐
  invite form                                                │
                                                             ▼
                                              ┌───────────────────────┐
                                              │ Bigin Deal created    │
                                              │ Pipeline: "Speaking"  │
                                              │ Stage: "New invite"   │
                                              │ Owner: Alin           │
                                              └───────────────────────┘

  CISO booking ──▶ Zoho Bookings (cal.zoho.com/alinmechenici/ciso)
                    │
                    ├─▶ Calendar event in "chen.ist CISO" (private)
                    ├─▶ Confirmation email to attendee
                    └─▶ Contact + Deal in Bigin (Pipeline: "CISO leads")
```

---

## Implementation phases

### Phase 1 — Calendar + public iCal (week 1, ~4 h work)

1. **Set up Zoho Calendar** on `alin@chen.ist`.
   - Create two calendars:
     - `chen.ist public` — visible, colour: brand green
     - `chen.ist CISO` — private, colour: amber
   - Backfill the 4 events we have today (weekly ON/OFF + three TBA annuals).

2. **Get the public iCal feed URL**.
   - Calendar Settings → Share → `Make public` → copy the `.ics` subscription link.
   - Looks like: `https://calendar.zoho.com/ical/<hash>/chen.ist_public.ics`
   - Only the `chen.ist public` calendar goes public. CISO stays internal.

3. **Add GitHub Action** `.github/workflows/sync-ics.yml`:

   ```yaml
   name: Sync Zoho iCal → repo
   on:
     schedule: [{ cron: '0 4 * * *' }]   # daily 04:00 UTC
     workflow_dispatch:
   permissions:
     contents: write
   jobs:
     sync:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - name: Fetch Zoho calendar
           env:
             ZOHO_ICAL_URL: ${{ secrets.ZOHO_ICAL_URL }}
           run: |
             curl -sfL "$ZOHO_ICAL_URL" > /tmp/zoho.ics
             # Inject custom X-WR headers + branding
             awk 'NR==4 {
               print "X-WR-CALNAME:Alin Mechenici — chen.ist"
               print "X-WR-CALDESC:Public speaking, training and event schedule."
               print "REFRESH-INTERVAL;VALUE=DURATION:P1D"
               print "X-PUBLISHED-TTL:P1D"
             } { print }' /tmp/zoho.ics > assets/files/alin-mechenici.ics
         - name: Commit if changed
           run: |
             git config user.name "github-actions[bot]"
             git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
             if ! git diff --quiet assets/files/alin-mechenici.ics; then
               git add assets/files/alin-mechenici.ics
               git commit -m "chore: sync Zoho calendar $(date -u +%Y-%m-%d)"
               git push
             fi
   ```

   - Store the iCal URL as GitHub secret `ZOHO_ICAL_URL`.
   - The existing `scripts/style-feeds.sh` already copies the file to `_site/alinmechenici.ics` at build time and stamps DTSTAMP. No change needed there.

4. **Deprecate the hand-written iCal**. Move the current `alin-mechenici.ics` to `.backup` after first successful sync.

**Done state:** Alin creates/edits an event in Zoho Calendar UI → within 24 h, `chen.ist/alinmechenici.ics` reflects it → all iCal subscribers auto-update.

---

### Phase 2 — Dynamic events list on the page (week 2, ~3 h)

The events page currently hard-codes the 4 upcoming events. Replace with a build-time fetch.

Option A (simpler, no secret exposure): **parse the `.ics` file** at Quarto render time.

1. Add a pre-render script `scripts/generate-events-html.sh`:
   - Reads `assets/files/alin-mechenici.ics`
   - Emits `includes/upcoming-events.html` with the 4 language-neutral event cards
   - Quarto `{{< include >}}` pulls it into each language's events page

2. In `_quarto.yml`:
   ```yaml
   pre-render:
     - "scripts/generate-events-html.sh"
   ```

3. In each `*/alinmechenici/events/index.qmd`, replace the hard-coded event rows with:
   ````markdown
   {{< include /includes/upcoming-events.html >}}
   ````

**Done state:** updates to Zoho Calendar flow through to the page on the next daily build — no hand edits.

Option B (richer, later): call Zoho Calendar **API** from the GH Action to get structured JSON and generate locale-specific cards per language. Defer until Phase 1 + A are stable.

---

### Phase 3 — Zoho Bookings for CISO calls (week 2, ~2 h)

1. **Enable Zoho Bookings**, connect to `alin@chen.ist`.
2. Create a service: **"CISO-as-a-Service intro · 30 min · free"**.
   - Duration: 30 min
   - Buffer: 15 min before/after
   - Availability: Mon–Thu 10:00–17:00 EET, max 3 slots/day
   - Syncs to `chen.ist CISO` calendar (private)
3. Configure booking form fields: Name, Email, Company, Company size, NIS2 relevance (dropdown), "What's the goal of this call?"
4. Set Bigin connector:
   - On booking confirmed → create Contact (or match by email)
   - → create Deal in pipeline "CISO leads", stage "Discovery call booked"
5. Get the public URL: `https://cal.zoho.com/alinmechenici/ciso-intro`
6. Update the 4 landing pages: swap `https://cal.com/alinmechenici/ciso?...` for the Zoho Bookings URL.
7. Keep Cal.com for `/booking/` (general call overflow) or migrate that too. Recommendation: migrate. One tool per job.

**Done state:** CISO discovery calls land directly in Bigin with full context, no Zapier, no Cal.com dependency.

---

### Phase 4 — Zoho Forms for speaking invites (week 3, ~2 h)

1. Create form **"invite-alin"** in Zoho Forms.
   - Fields mirror the current Formspree form + the new `budget` field we just added.
   - Redirect on submit: `https://chen.ist/alinmechenici/events/?sent=1`
2. Configure Bigin push:
   - On submit → create Contact
   - → create Deal in pipeline "Speaking", stage "New invite"
   - → assign owner: Alin
   - → tag with `source=alinmechenici-events-<lang>`
3. Optional: add a **Zoho Flow** to also:
   - Send Alin a Slack/WhatsApp notification
   - Auto-reply to the submitter with a "got it, replying within 3 working days" email
4. Replace the `<form action="https://formspree.io/f/mpwkaqev">` in each of the 4 events pages with the Zoho Forms embed OR keep HTML + point `action=` to the Zoho Forms webhook URL.
5. On success, show a success banner on `?sent=1`:
   ```html
   <script>
     if (new URLSearchParams(location.search).get('sent') === '1') {
       document.querySelector('.am-invite-card').insertAdjacentHTML('afterbegin',
         '<div style="background:#dcfce7;color:#166534;padding:1rem;border-radius:10px;margin-bottom:1rem;">✓ Thanks — Alin will reply personally within 3 working days.</div>');
     }
   </script>
   ```

**Done state:** invites go straight into Bigin with a "Speaking" pipeline; Formspree can be cancelled.

---

### Phase 5 — Cleanup & polish (week 3, ~2 h)

- [ ] Remove the manual `alin-mechenici.ics` from the repo (GH Action owns it now)
- [ ] Remove Formspree endpoint references
- [ ] Add a tiny "Managed in Zoho Calendar, synced nightly" note in the page footer
- [ ] Cancel Formspree subscription
- [ ] Update `memory/project_website_status.md` with the new stack

---

## Rollback plan

Every phase is independent and reversible:
- Phase 1 rollback: disable the GH Action, restore the static `.ics` from git history. 30 seconds.
- Phase 2 rollback: revert the include, restore hard-coded HTML. One commit.
- Phase 3 rollback: swap the Cal.com URL back on 4 pages. One commit.
- Phase 4 rollback: swap the `<form action>` back to Formspree. One commit.

---

## Costs at scale

| Volume | Free tier holds? |
|---|---|
| < 500 form submissions/month | ✅ Zoho Forms free |
| < 1 user running bookings | ✅ Zoho Bookings free |
| < 1000 Flow tasks/month | ✅ Zoho Flow free |
| Unlimited calendar events | ✅ Zoho Calendar free |

First paid tier needed when: multi-user Bookings (Alin + someone else taking calls) → Bookings Basic, **€6/user/mo**. Or Zoho One bundle at **€37/user/mo** if Alin consolidates Mail, Desk, Campaigns, Sign too.

---

## Open questions for Alin

1. Keep Cal.com for `/booking/` or migrate all calls to Zoho Bookings?
2. Any existing Bigin pipelines to reuse, or create fresh "Speaking" and "CISO leads" pipelines?
3. Approve the "Managed in Zoho Calendar, synced nightly" transparency note, or skip?
4. Is there a CHENIST Academy team event calendar that should merge into the feed later, or stay separate?

---

*Last updated: 2026-04-15*
