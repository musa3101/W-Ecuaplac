# Proyecto Ecuaplac - Roadmap

## Tareas Completadas
- [x] Integración de 11 nuevas fotos de reformas en una galería colapsable y táctil.
- [x] Configuración de reproducción automática (autoplay) y control táctil para el carrusel de reformas.
- [x] Rediseño premium de los botones de navegación y paginación del carrusel de reformas.
- [x] Traducción al 100% en inglés de todo el sitio web, incluyendo textos de base de datos en `reformas-en.html`.
- [x] Corrección del comportamiento de los logos (enlace a home y smooth scroll en portadas).
- [x] Actualización del logotipo del footer al nuevo diseño SVG transparente.
- [x] Vinculación del dominio principal (`ecuaplac.com`) y el subdominio (`www.ecuaplac.com`) en Cloudflare Pages y DNS.
- [x] Auditoría automatizada de navegación 360º.
- [x] Migración del backend de Supabase a la cuenta del cliente (`ecuaplacbyjg@gmail.com`).
- [x] Creación de la sección interactiva "Contacto Directo" dinamizada con la tabla `ecuaplac_contact` de Supabase.
- [x] Optimización de rendimiento a 60fps en el scroll del Hero para dispositivos móviles.
- [x] Implementación de guardado dual de Leads en la tabla `ecuaplac_leads` de Supabase + envío por email (FormSubmit.co).
- [x] Configuración del token MCP de Supabase para operaciones futuras.
- [x] **Seguridad Supabase RLS**: Blindaje de inserción y protección de privacidad para la tabla `ecuaplac_leads`.
- [x] **Erradicación Definitiva de `#hand-loader`**: Supresión de todo el código de precarga y CSS residual en los 6 archivos HTML.
- [x] **Optimización de Recursos del Hero**: Sustitución de dependencias externas por WebP locales de alta resolución (`1.webp`, `2.webp`, `3.webp`).
- [x] **Optimización de Red y DNS**: Configuración de Cloudflare DNS (`1.1.1.1`) y Google DNS (`8.8.8.8`) para tiempos de carga < 0.2s.
- [x] **Creación y despliegue del Favicon Oficial**: Paquete multiformato (ICO, SVG, PNG 48x48, Apple Touch Icon, Manifest) generado desde `Logofotter.svg`.
- [x] **Optimización SEO y Google Snippets**: Títulos sin truncamiento, meta descripciones orientadas a conversión, geolocalización local de Palma de Mallorca y Schema.org JSON-LD (`WebSite` + `GeneralContractor`).
- [x] **Rastreo e Indexabilidad**: Generación y despliegue de `robots.txt` y `sitemap.xml` canónico multilingüe.
- [x] **Auditoría de Ciberseguridad**: Verificación de ausencia de credenciales maestras y blindaje de `.gitignore`.

## Tareas en Progreso
- Ninguna.

## Próximas Mejoras Prioritarias
- [ ] Envío del sitemap y solicitud de indexación en Google Search Console para refresco del buscador.
- [ ] Monitoreo continuo de analíticas y conversiones en Microsoft Clarity.
