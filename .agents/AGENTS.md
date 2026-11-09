# Reglas de Proyecto para Ecuaplac

## Configuración de Supabase
El backend del proyecto está conectado a la cuenta dedicada del cliente. Las credenciales activas son:
- **Supabase URL:** `https://wkfddccsantywcrsxpox.supabase.co`
- **Publishable Key (Anon Key):** `sb_publishable_ym3HAoFGlToeBAQu1yMd3A_m7Gx4GNI`

Estas claves están configuradas en los archivos HTML:
- `index.html`
- `index-en.html`
- `reformas.html`
- `reformas-en.html`

## Estructura de la Base de Datos
Las tablas oficiales en Supabase (`public`) son:
- **`ecuaplac_galeria_1`**: Carrusel de la Home (10 obras destacadas).
- **`ecuaplac_galeria_2`**: Carrusel desplegable de Reformas (11 obras con fotos y títulos).
- **`ecuaplac_projects`**: Sección "Antes y Después" de Reformas (4 proyectos comparativos con ficha técnica).
- **`ecuaplac_leads`**: Presupuestos y solicitudes de clientes recibidos desde los formularios web.
- **`ecuaplac_contact`**: Teléfonos directos, email y dirección física.
- **`ecuaplac_admin_profile`**: Perfil y credenciales del gestor administrativo.

La estructura de tablas y las filas iniciales se definen en el archivo [supabase_schema.sql](../docs/database/supabase_schema.sql). Si es necesario restablecer o sincronizar la base de datos, ejecuta ese script completo en el SQL Editor de Supabase.

## Envío de Formularios y Gestión de Leads
El formulario de la web cuenta con un sistema de **guardado dual**:
1. Registra automáticamente cada solicitud en la tabla `ecuaplac_leads` de Supabase.
2. Envía la notificación por correo electrónico directamente a la dirección **`ecuaplac.jyg.sl@gmail.com`** usando FormSubmit.co.
