/**
 * Cloudflare Pages Function: Webhook de Tally.so -> Supabase (ecuaplac_leads)
 * Endpoint: https://ecuapv2.pages.dev/api/tally-webhook
 */

const SUPABASE_URL = "https://wkfddccsantywcrsxpox.supabase.co";
const SUPABASE_KEY = "sb_publishable_ym3HAoFGlToeBAQu1yMd3A_m7Gx4GNI";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS, HEAD",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, tally-signature",
  "Content-Type": "application/json",
};

// 1. Manejo de Preflight CORS
export async function onRequestOptions() {
  return new Response(null, {
    status: 204,
    headers: corsHeaders,
  });
}

// 2. Manejo de Verificación GET / Ping de Tally
export async function onRequestGet() {
  return new Response(JSON.stringify({ status: "active", message: "Ecuaplac Tally Webhook está listo y activo" }), {
    status: 200,
    headers: corsHeaders,
  });
}

// 3. Manejo de Recepción de Webhook (POST)
export async function onRequestPost(context) {
  try {
    let rawBody;
    try {
      rawBody = await context.request.json();
    } catch (parseErr) {
      // Si Tally envía un ping de verificación o cuerpo vacío, respondemos 200 OK inmediatamente
      return new Response(JSON.stringify({ success: true, message: "Webhook ping OK" }), {
        status: 200,
        headers: corsHeaders,
      });
    }

    if (!rawBody || Object.keys(rawBody).length === 0) {
      return new Response(JSON.stringify({ success: true, message: "Webhook ping vacío recibido" }), {
        status: 200,
        headers: corsHeaders,
      });
    }

    console.log("Tally Webhook payload recibido:", JSON.stringify(rawBody));

    // Estructura Tally: { eventType: "FORM_RESPONSE", data: { fields: [...], ... } }
    const data = rawBody.data || rawBody;
    const fields = Array.isArray(data.fields) ? data.fields : [];

    let name = "";
    let phone = "";
    let email = "";
    let projectType = "Presupuesto Online (Tally)";
    const answersSummary = [];

    // Recorrer los campos del formulario de Tally de forma flexible y precisa
    for (const field of fields) {
      const label = (field.label || "").trim();
      const val = field.value;

      // 1. Mapear opciones de Tally (Dropdowns, Selección Múltiple, Checkboxes)
      // Tally envía en 'value' los IDs (ej: "4a9aaaa0-cbd6...") y en 'options' la lista [{ id, text }]
      let resolvedVal = val;
      if (Array.isArray(field.options) && field.options.length > 0) {
        const optMap = new Map();
        for (const opt of field.options) {
          if (opt && opt.id) {
            optMap.set(String(opt.id), opt.text || opt.label || String(opt.id));
          }
        }
        if (Array.isArray(val)) {
          resolvedVal = val.map(v => (typeof v === "string" && optMap.has(v) ? optMap.get(v) : v));
        } else if (typeof val === "string" && optMap.has(val)) {
          resolvedVal = optMap.get(val);
        }
      }

      // 2. Formatear valor legible (soporte para arrays, subida de archivos/fotos y textos)
      let strVal = "";
      if (Array.isArray(resolvedVal)) {
        strVal = resolvedVal.map(item => {
          if (typeof item === "object" && item !== null) {
            return item.url || item.name || JSON.stringify(item);
          }
          return String(item);
        }).join(", ");
      } else if (typeof resolvedVal === "object" && resolvedVal !== null) {
        strVal = resolvedVal.url || resolvedVal.name || JSON.stringify(resolvedVal);
      } else {
        strVal = resolvedVal !== undefined && resolvedVal !== null ? String(resolvedVal).trim() : "";
      }

      if (!strVal) continue;

      const lowerLabel = label.toLowerCase();
      const type = (field.type || "").toUpperCase();

      // Detección estricta de Nombre
      if (!name && (lowerLabel.includes("nombre") || lowerLabel.includes("name") || lowerLabel.includes("apellidos"))) {
        name = strVal;
      }

      // Detección estricta de Teléfono
      if (!phone && (type === "INPUT_PHONE_NUMBER" || lowerLabel.includes("tel") || lowerLabel.includes("móvil") || lowerLabel.includes("movil") || lowerLabel.includes("whatsapp") || lowerLabel.includes("phone"))) {
        phone = strVal;
      }

      // Detección estricta de Email
      if (!email && (type === "INPUT_EMAIL" || lowerLabel.includes("email") || lowerLabel.includes("correo"))) {
        email = strVal;
      }

      // Detección estricta de Servicio / Tipo de Proyecto
      if (
        (lowerLabel.includes("servicio") || lowerLabel.includes("tipo de reforma") || lowerLabel.includes("tipo de proyecto") || type === "DROPDOWN") &&
        !lowerLabel.includes("detalles") &&
        !lowerLabel.includes("necesidades") &&
        !lowerLabel.includes("municipio")
      ) {
        projectType = strVal;
      }

      answersSummary.push(`- ${label || "Pregunta"}: ${strVal}`);
    }

    // Fallbacks si no vinieron por label exacto
    if (!name && data.respondentId) name = `Cliente Tally #${String(data.respondentId).slice(-4)}`;
    if (!name) name = "Cliente Tally (Web)";

    // Construir mensaje estructurado
    const fullMessage = [
      `[PRESUPUESTO RECIBIDO DESDE TALLY.SO]`,
      `Formulario: ${data.formName || "Ecuaplac | Cuéntanos tu proyecto"}`,
      `Fecha: ${new Date().toLocaleString("es-ES", { timeZone: "Europe/Madrid" })}`,
      ``,
      `--- DETALLES DEL PROYECTO ---`,
      answersSummary.length > 0 ? answersSummary.join("\n") : "(Sin respuestas adicionales)",
    ].join("\n");

    // Inserción directa e instantánea en Supabase (ecuaplac_leads)
    const sbResponse = await fetch(`${SUPABASE_URL}/rest/v1/ecuaplac_leads`, {
      method: "POST",
      headers: {
        "apikey": SUPABASE_KEY,
        "Authorization": `Bearer ${SUPABASE_KEY}`,
        "Content-Type": "application/json",
        "Prefer": "return=minimal",
      },
      body: JSON.stringify([{
        name: name,
        phone: phone || null,
        email: email || null,
        project_type: projectType,
        message: fullMessage,
        source_page: "Tally.so",
        status: "nuevo",
      }]),
    });

    if (!sbResponse.ok) {
      const errText = await sbResponse.text();
      console.error("Error insertando en Supabase:", sbResponse.status, errText);
      return new Response(JSON.stringify({ success: false, error: errText }), {
        status: 500,
        headers: corsHeaders,
      });
    }

    console.log("Lead de Tally insertado con éxito en Supabase ecuaplac_leads");

    // Respuesta inmediata (< 40ms) a Tally para evitar cualquier timeout
    return new Response(JSON.stringify({ success: true, message: "Lead recibido y guardado en Supabase" }), {
      status: 200,
      headers: corsHeaders,
    });
  } catch (error) {
    console.error("Error procesando webhook de Tally:", error);
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500,
      headers: corsHeaders,
    });
  }
}
