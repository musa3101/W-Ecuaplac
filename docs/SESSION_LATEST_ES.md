# Resumen de Sesión - 10 de Noviembre de 2026 (MYNEXT Setup 2.0 — Musa)
*Estado de Sesión: ABIERTA (Trabajando en rama `dev`)*

---

### Memoria Técnica de la Jornada (Recuperación y Perfeccionamiento de la Web Oficial)

1. **Reparación Definitiva del Crash de Galería 1 en iPhone / WebGL (`index*.html`):**
   - **Diagnóstico:** En dispositivos móviles reales (iPhone / Safari WebKit), la Galería 1 (carrusel 3D WebGL) se quedaba congelada en blanco. El compilador GLSL arrojaba un error fatal de fragment shader: `undeclared identifier uAlpha`.
   - **Solución:** Se declaró `uniform float uAlpha;` en la cabecera del shader en `index.html`, `index-en.html` y `index-de.html`. El canvas 3D ahora inicializa inmediatamente sin errores de consola (`ERRORS: []`) y renderiza las 10 obras con rotación suave y sombras atmosféricas.

2. **Restauración de Bordes Negros Sólidos Oficiales (`border border-black`):**
   - Durante auditorías de diseño automatizadas previas, los bordes habían sido suavizados a `#E5DFD5`. Se restauraron los bordes negros arquitectónicos originales solicitados por Musa:
     - En las **4 tarjetas de servicios** de «Nuestra Experiencia» (`border border-black`).
     - En la **tarjeta del formulario de contacto** (`border-2 border-[#141414]`).
     - En todos los recuadros de **Estado Inicial** y **Resultado Final** de los proyectos comparativos en `reformas.html`, `reformas-en.html` y `reformas-de.html` (tanto en el HTML estático como en la inyección de Supabase).

3. **Integración del Botón de Presupuesto por Email Bajo WhatsApp:**
   - Incorporado debajo del botón verde de WhatsApp un botón tipo píldora (`border border-black bg-white text-primary`) con icono de sobre/email de Google.
   - Al pulsarlo, ejecuta un scroll suave inmediato hacia `#formulario`.
   - Implementado en los 3 idiomas:
     - ES: *«Pedir Presupuesto por Email»*
     - EN: *«Request Quote via Email»*
     - DE: *«Angebot per E-Mail anfordern»*

4. **Animación 21st.dev `TextEffect` (Letra a Letra con Blur & Fade Cinemático):**
   - Adaptación fiel del componente oficial de 21st.dev / *motion-primitives* (`TextEffect` por carácter):
     - **Curva y ritmo:** Elevación inicial de `16px` (`translateY(16px) -> translateY(0)`), transición pausada y sedosa de `0.70s` con `cubic-bezier(0.16, 1, 0.3, 1)` y retardo escalonado de `0.028s` por carácter con desenfoque dinámico (`filter: blur(8px) -> blur(0)`).
     - **Activación 1 por 1 al hacer scroll:** Cada título dispone de su propio `IntersectionObserver` dedicado (`rootMargin: '0px 0px -15% 0px'`). La animación se activa individualmente a medida que el usuario hace scroll y entra en la zona de lectura, evitando que se disparen todos en bloque.
     - **Protección tipográfica y responsive:** Mantiene al 100% las fuentes corporativas (`font-headline`), tamaños, pesos y colores. Las palabras se agrupan en contenedores `inline-block whitespace-pre` para garantizar que los saltos de línea en iPhone/móvil se realicen limpiamente sin partir ninguna palabra por la mitad.
     - **Títulos con el efecto activo:**
       - Home (`index*.html`): *Proyectos y Acabados de Alta Gama* (Galería 1), *Transformaciones Reales* (Antes y Después), *4 Servicios* (*Reformas Integrales*, *Sistemas de Pladur y Aislamiento*, *Revestimientos y Acabados*, *Pavimentos y Alicatados*), *Contacto.* y *Preguntas Frecuentes*.
       - Reformas (`reformas*.html`): *Antes y Después* (Cabecera `h1`), *Lavabo Flotante a Medida* (Proyecto II), *Vestidor de Pladur y Roble* (Proyecto III), *Escalera y Distribuidor de Roble* (Proyecto IV).

5. **Excepción solicitada en Proyecto I de Reformas:**
   - A petición expresa de Musa, el título **«Reforma Integral de Baño»** en `reformas*.html` se mantuvo estático y fijo, sin retardo ni efecto de fade.

6. **Merge y Despliegue en Producción Verificado (`main` -> Cloudflare):**
   - Ejecutado mediante `scripts/mini-merge.sh --all --confirmed --push` tras la autorización oficial exacta de Musa (*"Tienes mi OK, haz el merge"*).
   - Commit en `main`: `0e222af`.
   - **Comprobación móvil exitosa:** Musa verificó directamente en su iPhone la versión desplegada en `https://ecuaplac.com`, confirmando que el nuevo estado de producción es 100% óptimo y fiel al diseño requerido.

---

7. **Solución del Salto No Deseado a "Reformas" al Recargar o Entrar (`index*.html`):**
   - **Diagnóstico:** Existía una variable residual en `sessionStorage` (`ecuaplac_return_section`) y llamadas a `history.replaceState` con `#reformas` que provocaban que al recargar la web o entrar en la URL principal el navegador se desplazara automáticamente hacia la Galería 1 en lugar de la primera foto del Hero.
   - **Solución:**
     - Activado `history.scrollRestoration = 'manual'`.
     - Añadida detección de recarga (`performance.getEntriesByType('navigation')[0].type === 'reload'`) que resetea la posición en `(0, 0)` y limpia cualquier hash espurio.
     - Implementada la función global `scrollToHeroTop(event)` en los logos del header, footer y enlace Inicio para garantizar retorno suave e instantáneo a la primera foto del Hero.

8. **Sustitución de Iconos de Material Symbols por Hugeicons Menu 02 (21st.dev):**
   - **Diagnóstico:** Los botones móviles dependían de la fuente web de Google Icons, generando lag de red y mostrando texto crudo (`"menu"` o `"close"`) antes de renderizar el icono.
   - **Solución:**
     - Sustituidos todos los iconos por **SVG inline puros** de la librería Hugeicons / 21st.dev (**Menu 02** con 3 barras y animación elástica CSS con efecto hover/active).
     - Tanto el botón de apertura en el header como el botón de cierre dentro del menú móvil utilizan el **mismo icono animado Menu 02**, eliminando por completo cualquier cruz o parpadeo.
     - En los modales de presupuesto se integró un SVG vectorial de cruz (X) limpio de 0 ms de carga.
     - Aplicado en las 6 páginas (`index*.html` y `reformas*.html` en ES, EN y DE).

9. **Auditoría Automatizada con Playwright:**
   - Verificado en emulador móvil iPhone (`390x844`):
     - Scroll inicial y tras recarga fijado en `0` (Hero Slide 1).
     - Menú móvil abre y cierra sin parpadeo de texto ni lag.
     - Clic en logos superior e inferior hace scroll suave a `(0, 0)` y limpia el hash.
     - Todos los tests automatizados completados con éxito (`100% PASSED`).

---

### Archivos Modificados en la Sesión
- `index.html`, `index-en.html`, `index-de.html`
- `reformas.html`, `reformas-en.html`, `reformas-de.html`
- `docs/SESSION_LATEST_ES.md` (Memoria técnica actualizada)
- `docs/ROADMAP.md` (Roadmap actualizado)

---

### Estado del Espacio de Trabajo
- **Rama activa:** `dev` (sincronizada con `origin/dev`).
- **Próximo paso:** Merge a `main` y despliegue a producción en Cloudflare tras confirmación oficial de Musa.
