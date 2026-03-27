/**
 * Bigin Bridge — Cloudflare Worker
 *
 * Receives Formspree webhook POSTs, maps form data to Zoho Bigin CRM fields,
 * and creates/upserts Contacts + Pipeline deals.
 *
 * Secrets (set via `wrangler secret put`):
 *   BIGIN_CLIENT_ID, BIGIN_CLIENT_SECRET, BIGIN_REFRESH_TOKEN
 *   WEBHOOK_SECRET (optional)
 */

export default {
  async fetch(request, env) {
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204 });
    }

    if (request.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const url = new URL(request.url);
    if (url.pathname !== "/webhook/formspree") {
      return new Response("Not found", { status: 404 });
    }

    try {
      const payload = await request.json();
      const source = payload._source || "unknown";
      const result = await processSubmission(payload, source, env);
      return Response.json({ ok: true, source, result });
    } catch (err) {
      console.error("Worker error:", err.message);
      return Response.json({ ok: false, error: err.message }, { status: 500 });
    }
  },
};

async function processSubmission(data, source, env) {
  const token = await getAccessToken(env);
  const contact = await upsertContact(data, source, token, env);

  const pipeline = routeToPipeline(source);
  if (pipeline) {
    await createDeal(contact.id, data, pipeline, token, env);
  }

  return { contact_id: contact.id, pipeline };
}

// --- Bigin API helpers ---

async function getAccessToken(env) {
  const params = new URLSearchParams({
    grant_type: "refresh_token",
    client_id: env.BIGIN_CLIENT_ID,
    client_secret: env.BIGIN_CLIENT_SECRET,
    refresh_token: env.BIGIN_REFRESH_TOKEN,
  });

  const res = await fetch(env.BIGIN_AUTH_URL, {
    method: "POST",
    body: params,
  });

  const json = await res.json();
  if (!json.access_token) {
    throw new Error(`Auth failed: ${JSON.stringify(json)}`);
  }
  return json.access_token;
}

async function upsertContact(data, source, token, env) {
  const { firstName, lastName } = splitName(data.name || "Unknown");

  const contactData = {
    First_Name: firstName,
    Last_Name: lastName,
    Email: data.email || "",
    Phone: data.phone || "",
    Description: data.message || "",
  };

  // Add custom fields if they exist in your Bigin setup
  if (source) contactData.Lead_Source = source;
  if (data.organization) contactData.Company = data.organization;
  if (data.location) contactData.Mailing_City = data.location;

  const res = await fetch(`${env.BIGIN_API_BASE}/Contacts/upsert`, {
    method: "POST",
    headers: {
      Authorization: `Zoho-oauthtoken ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      data: [contactData],
      duplicate_check_fields: ["Email"],
    }),
  });

  const json = await res.json();
  const record = json.data?.[0];
  if (!record || record.status === "error") {
    throw new Error(`Contact upsert failed: ${JSON.stringify(json)}`);
  }

  return { id: record.details.id, action: record.action };
}

async function createDeal(contactId, data, pipeline, token, env) {
  const dealData = {
    Pipeline: pipeline.name,
    Stage: pipeline.stage,
    Deal_Name: `${data.name || "Unknown"} — ${pipeline.name}`,
    Contact_Name: { id: contactId },
  };

  if (data.application_type) dealData.Description = `Type: ${data.application_type}`;

  const res = await fetch(`${env.BIGIN_API_BASE}/Pipelines`, {
    method: "POST",
    headers: {
      Authorization: `Zoho-oauthtoken ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ data: [dealData] }),
  });

  const json = await res.json();
  if (json.data?.[0]?.status === "error") {
    console.error("Deal creation failed:", JSON.stringify(json));
  }
  return json;
}

// --- Routing ---

function routeToPipeline(source) {
  if (source.startsWith("computerclub-apply")) {
    return { name: "Academy Members", stage: "Applied" };
  }
  if (source.startsWith("nis2")) {
    return { name: "Course Inquiries", stage: "Inquiry" };
  }
  if (source.startsWith("event-registration")) {
    return { name: "Event Registrations", stage: "Registered" };
  }
  if (source.startsWith("course-inquiry")) {
    return { name: "Course Inquiries", stage: "Inquiry" };
  }
  // contact-page, newsletter-signup → Contact only, no pipeline
  return null;
}

// --- Utils ---

function splitName(fullName) {
  const parts = fullName.trim().split(/\s+/);
  if (parts.length === 1) return { firstName: "", lastName: parts[0] };
  return { firstName: parts.slice(0, -1).join(" "), lastName: parts[parts.length - 1] };
}
