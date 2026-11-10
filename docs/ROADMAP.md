# Proyecto Ecuaplac - Roadmap

## Tareas Completadas
- [x] Integración de 11 nuevas fotos de reformas en una galería colapsable y táctil.
- [x] Configuración de reproducción automática (autoplay) y control táctil para el carrusel de reformas.
- [x] Rediseño premium de los botones de navegación y paginación del carrusel de reformas.
- [x] Traducción al 100% en inglés de todo el sitio web, incluyendo textos de base de datos en `reformas-en.html`.
- [x] Traducción al 100% en alemán (`index-de.html`, `reformas-de.html`, `impressum.html`) con selector de idiomas ES | EN | DE.
- [x] Corrección del comportamiento de los logos (enlace a home y smooth scroll en portadas).
- [x] Actualización del logotipo del footer al nuevo diseño SVG transparente.
- [x] Vinculación del dominio principal (`ecuaplac.com`) y el subdominio (`www.ecuaplac.com`).
- [x] Auditoría automatizada de navegación 360º.
- [x] Migración del backend de Supabase a la cuenta del cliente (`ecuaplacbyjg@gmail.com`).
- [x] Creación de la sección interactiva "Contacto Directo" dinamizada con la tabla `ecuaplac_contact` de Supabase.
- [x] Optimización de rendimiento a 60fps en el scroll del Hero para dispositivos móviles.
- [x] Implementación de guardado dual de Leads en la tabla `ecuaplac_leads` de Supabase + envío por email (FormSubmit.co).
- [x] Configuración del token MCP de Supabase para operaciones futuras.
- [x] **Seguridad Supabase RLS**: Blindaje de inserción y protección de privacidad para la tabla `ecuaplac_leads`.
- [x] **Erradicación Definitiva de `#hand-loader`**: Supresión de todo el código de precarga y CSS residual en los 6 archivos HTML.
- [x] **Optimización de Recursos del Hero**: Sustitución de dependencias externas por WebP locales de alta resolución (`1.webp`, `2.webp`, `3.webp`).
- [x] **Creación y despliegue del Favicon Oficial**: Paquete multiformato (ICO, SVG, PNG 48x48, Apple Touch Icon, Manifest) generado desde `Logofotter.svg`.
- [x] **Optimización SEO y Google Snippets**: Títulos sin truncamiento, meta descripciones orientadas a conversión, geolocalización local de Palma de Mallorca y Schema.org JSON-LD (`WebSite` + `GeneralContractor`).
- [x] **Rastreo e Indexabilidad**: Generación y despliegue de `robots.txt` y `sitemap.xml` canónico multilingüe.
- [x] **Desarrollo de la App Web Gestor (`appweb/`)**: PWA móvil con diseño Bento Luxury, login con email y contraseña, conversión client-side a WebP, bloqueo de zoom en iOS, header Deep Navy y logo sin fondo oficial.
- [x] **Banda de Marca Dithered en el Footer (Estilo 21st)**: Banda interactiva con efecto dithered dorado para ECUAPLAC.
- [x] **Alineación Perfecta del Logo en Header Móvil**: Corrección del padding transparente en `LogoHedder.webp`, alineación estricta a la izquierda y preservación íntegra de la animación fade/reveal.
- [x] **Blindaje Anti-Bloqueos de Operadoras (LaLiga/ISP) 24/7**: Configuración de GitHub Pages (CDN Fastly `185.199.108.153`) + Cloudflare DNS en modo Solo DNS (Nube Gris) con HTTPS automático en `ecuaplac.com`.
- [x] **Recuadros Negros y Optimización Móvil en "Antes y Después"**: Tarjetas con bordes negros sólidos (`border border-black bg-white rounded-2xl`), proporción adaptativa `aspect-[16/10]` en móviles reduciendo el scroll en más del 50% sin recortar fotos, y sincronización total en Supabase (`reformas.html`, `reformas-en.html`, `reformas-de.html`).
- [x] **Restauración de Iconos de Footer**: Icono oficial de Google Maps e Instagram unificado en todas las páginas.

## Tareas en Progreso
- Ninguna.

## Próximas Mejoras Prioritarias
- [ ] Conectar la pestaña de **Leads** en la app web con la tabla `ecuaplac_leads` de Supabase para visualización en tiempo real de presupuestos.
- [ ] Implementar botones de llamada telefónica y chat de WhatsApp con un toque desde las fichas de los clientes en la app web.
- [ ] Añadir selector de estados de gestión a cada presupuesto (*Nuevo*, *Contactado*, *Enviado*, *Aceptado*).
- [ ] Ejecución de scripts SQL en el panel de Supabase para activar las tablas auxiliares si no se han cargado previamente.
- [ ] Envío del sitemap y solicitud de indexación en Google Search Console para refresco del buscador.
