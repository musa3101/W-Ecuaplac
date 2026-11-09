# Ecuaplac Gestor (App Web / PWA)

> [!NOTE]
> **ESTADO DEL MÓDULO: DESACTIVADO (TRANSICIÓN A MYNEXT)**
> Este módulo ha sido formalmente desactivado en la web pública para ceder el control a la nueva plataforma externa centralizada de **MyNext**, actualmente en desarrollo.
> 
> Todo el código fuente de la PWA v3.0 está 100% conservado e intacto en [`index.pwa-v1.backup.html`](./index.pwa-v1.backup.html).

---

## 📁 Estructura del Módulo

- **[`index.html`](./index.html)**: Pantalla de estado corporativo seguro (aviso de transición a MyNext, sin dependencias activas de base de datos ni credenciales).
- **[`index.pwa-v1.backup.html`](./index.pwa-v1.backup.html)**: **Código fuente original completo de la PWA v3.0**. Contiene el diseño Bento Grid Luxury, el dock flotante de 4 pestañas (*Obras*, *+ Proj*, *Leads*, *Ajustes*), el motor de compresión WebP en Canvas y la autenticación.
- **[`assets/`](./assets/)**: Iconos de alta resolución (192px, 512px, Apple Touch Icon), logotipo SVG sin fondo y fotos WebP de muestra.
- **[`manifest.webmanifest`](./manifest.webmanifest)**: Manifiesto PWA para instalación móvil.
- **[`sw.js`](./sw.js)**: Service Worker para funcionamiento offline y cacheo inteligente.

---

## 🔄 Procedimiento para Reactivación Inmediata (Si se requiere en el futuro)

Si en algún momento se desea volver a activar la PWA independiente de Ecuaplac, solo es necesario ejecutar:

```bash
# 1. Restaurar el código de la PWA
cp appweb/index.pwa-v1.backup.html appweb/index.html

# 2. Hacer commit y merge controlado en dev -> main
```

---

## 🛠️ Especificaciones Técnicas del Desarrollo Conservado

1. **Diseño Bento Grid Luxury & Colores del Logo**:
   - Deep Navy (`#0B1523`), oro artesanal (`#D49B0B`), fondo tiza (`#F6F5F2`) y tarjetas Bento con efecto *double-bezel*.
2. **Acceso con Correo Corporativo**:
   - `ecuaplacbyjyg@gmail.com` / `admin` (con opción de recordar sesión).
3. **Compresión Universal WebP (< 250 KB)**:
   - Motor HTML5 Canvas integrado que reduce fotos pesadas de móviles antes de enviarlas a Supabase.
4. **Blindaje Anti-Zoom**:
   - Calibrado para evitar zoom accidental en Safari iOS.
