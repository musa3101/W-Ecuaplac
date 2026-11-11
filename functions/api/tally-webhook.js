/**
 * Cloudflare Pages Function: Webhook de Tally.so -> Supabase (ecuaplac_leads)
 * Endpoint: https://ecuaplac.com/api/tally-webhook
 */

const SUPABASE_URL = "https://wkfddccsantywcrsxpox.supabase.co";
const SUPABASE_KEY = "sb_publishable_ym3HAoFGlToeBAQu1yMd3A_m7Gx4GNI";
const NOTIFICATION_EMAIL = "ecuaplac.jyg.sl@gmail.com";

// Manejo de Preflight CORS
export async function onRequestOptions() {
  return new Response(null, {
    status: 204,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type, Authorization, tally-signature",
    },
  });
}

// Manejo de Recepción de Webhook
export async function onRequestPost(context) {
  const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/json",
  };

  try {
    const rawBody = await context.request.json();
    console.log("Tally Webhook payload recibido:", JSON.stringify(rawBody));

    // Estructura Tally: { eventType: "FORM_RESPONSE", data: { fields: [...], ... } }
    const data = rawBody.data || rawBody;
    const fields = Array.isArray(data.fields) ? data.fields : [];

    let name = "";
    let phone = "";
    let email = "";
    let projectType = "Presupuesto Online (Tally)";
    const answersSummary = [];

    // Recorrer los campos del formulario de Tally de forma flexible
    for (const field of fields) {
      const label = (field.label || "").trim();
      const val = field.value;

      // Formatear valor legible
      let strVal = "";
      if (Array.isArray(val)) {
        strVal = val.join(", ");
      } else if (typeof val === "object" && val !== null) {
        strVal = JSON.stringify(val);
      } else {
        strVal = val !== undefined && val !== null ? String(val).trim() : "";
      }

      if (!strVal) continue;

      const lowerLabel = label.toLowerCase();
      const type = (field.type || "").toUpperCase();

      // Detección de Nombre
      if (!name && (type === "INPUT_TEXT" || lowerLabel.includes("nombre") || lowerLabel.includes("name"))) {
        name = strVal;
      }

      // Detección de Teléfono
      if (!phone && (type === "INPUT_PHONE_NUMBER" || lowerLabel.includes("tel") || lowerLabel.includes("móvil") || lowerLabel.includes("movil") || lowerLabel.includes("phone"))) {
        phone = strVal;
      }

      // Detección de Email
      if (!email && (type === "INPUT_EMAIL" || lowerLabel.includes("email") || lowerLabel.includes("correo"))) {
        email = strVal;
      }

      // Detección de Tipo de Proyecto
      if (lowerLabel.includes("tipo") || lowerLabel.includes("servicio") || lowerLabel.includes("reforma") || lowerLabel.includes("obra") || lowerLabel.includes("proyecto")) {
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

    // 1. Inserción directa en Supabase (ecuaplac_leads)
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
    } else {
      console.log("Lead de Tally insertado con éxito en Supabase ecuaplac_leads");
    }

    // 2. Enviar notificación por correo a través de FormSubmit.co
    try {
      await fetch(`https://formsubmit.co/ajax/${NOTIFICATION_EMAIL}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: JSON.stringify({
          _subject: `Nuevo Presupuesto Tally: ${name}`,
          nombre: name,
          telefono: phone || "No facilitado",
          email: email || "No facilitado",
          tipo_proyecto: projectType,
          detalles: fullMessage,
          origen: "Tally.so (Presupuesto Online)",
        }),
      });
    } catch (mailErr) {
      console.warn("Aviso al enviar copia por email:", mailErr);
    }

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
