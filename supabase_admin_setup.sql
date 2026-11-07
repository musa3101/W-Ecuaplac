-- ==============================================================================
-- ECUAPLAC ADMIN & MEDIA SETUP (Supabase SQL Editor)
-- Script complementario para la Mini App Web / PWA de gestión de Ecuaplac
-- ==============================================================================

-- 1. CREACIÓN DEL BUCKET DE ALMACENAMIENTO (ecuaplac-media)
-- Permite guardar imágenes del carrusel y avatares del administrador
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'ecuaplac-media',
    'ecuaplac-media',
    true,
    20971520, -- 20 MB límite máximo
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/heic', 'image/svg+xml']
)
ON CONFLICT (id) DO UPDATE SET 
    public = true,
    file_size_limit = 20971520,
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/heic', 'image/svg+xml'];

-- Políticas de Storage para el bucket ecuaplac-media
DROP POLICY IF EXISTS "Lectura publica de imagenes ecuaplac-media" ON storage.objects;
DROP POLICY IF EXISTS "Permitir subida de imagenes en ecuaplac-media" ON storage.objects;
DROP POLICY IF EXISTS "Permitir actualizacion de imagenes en ecuaplac-media" ON storage.objects;
DROP POLICY IF EXISTS "Permitir eliminacion de imagenes en ecuaplac-media" ON storage.objects;

CREATE POLICY "Lectura publica de imagenes ecuaplac-media"
ON storage.objects FOR SELECT
USING (bucket_id = 'ecuaplac-media');

CREATE POLICY "Permitir subida de imagenes en ecuaplac-media"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'ecuaplac-media');

CREATE POLICY "Permitir actualizacion de imagenes en ecuaplac-media"
ON storage.objects FOR UPDATE
USING (bucket_id = 'ecuaplac-media');

CREATE POLICY "Permitir eliminacion de imagenes en ecuaplac-media"
ON storage.objects FOR DELETE
USING (bucket_id = 'ecuaplac-media');


-- 2. HABILITAR PERMISOS DE EDICIÓN EN LA TABLA DEL CARRUSEL (ecuaplac_carousel)
-- Ya existe la política de SELECT en supabase_schema.sql. Aquí ampliamos los permisos para el gestor:
DROP POLICY IF EXISTS "Permitir insercion de carrusel ecuaplac" ON ecuaplac_carousel;
DROP POLICY IF EXISTS "Permitir actualizacion de carrusel ecuaplac" ON ecuaplac_carousel;
DROP POLICY IF EXISTS "Permitir borrado de carrusel ecuaplac" ON ecuaplac_carousel;
DROP POLICY IF EXISTS "Permitir lectura completa de carrusel ecuaplac" ON ecuaplac_carousel;

-- Permitir lectura completa (incluye activos y ocultos para el panel de administración)
CREATE POLICY "Permitir lectura completa de carrusel ecuaplac"
ON ecuaplac_carousel FOR SELECT
USING (true);

-- Permitir crear, actualizar y borrar elementos del carrusel
CREATE POLICY "Permitir insercion de carrusel ecuaplac"
ON ecuaplac_carousel FOR INSERT
WITH CHECK (true);

CREATE POLICY "Permitir actualizacion de carrusel ecuaplac"
ON ecuaplac_carousel FOR UPDATE
USING (true)
WITH CHECK (true);

CREATE POLICY "Permitir borrado de carrusel ecuaplac"
ON ecuaplac_carousel FOR DELETE
USING (true);


-- 3. TABLA DE PERFIL DE ADMINISTRADOR Y CONFIGURACIÓN (ecuaplac_admin_profile)
CREATE TABLE IF NOT EXISTS ecuaplac_admin_profile (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_name TEXT DEFAULT 'José Rivadeneira',
    avatar_url TEXT DEFAULT '',
    pin_code TEXT DEFAULT '1234',
    remember_tokens TEXT[] DEFAULT ARRAY[]::TEXT[],
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE ecuaplac_admin_profile ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Permitir lectura publica de perfil admin" ON ecuaplac_admin_profile;
DROP POLICY IF EXISTS "Permitir actualizacion de perfil admin" ON ecuaplac_admin_profile;
DROP POLICY IF EXISTS "Permitir insercion de perfil admin" ON ecuaplac_admin_profile;

CREATE POLICY "Permitir lectura publica de perfil admin"
ON ecuaplac_admin_profile FOR SELECT
USING (true);

CREATE POLICY "Permitir actualizacion de perfil admin"
ON ecuaplac_admin_profile FOR UPDATE
USING (true)
WITH CHECK (true);

CREATE POLICY "Permitir insercion de perfil admin"
ON ecuaplac_admin_profile FOR INSERT
WITH CHECK (true);

-- Insertar perfil por defecto si la tabla está vacía
INSERT INTO ecuaplac_admin_profile (id, admin_name, avatar_url, pin_code)
SELECT 'a0000000-0000-0000-0000-000000000001'::uuid, 'José Rivadeneira', '', '1234'
WHERE NOT EXISTS (SELECT 1 FROM ecuaplac_admin_profile);


-- 4. TABLA DE REGISTRO DE ACTIVIDAD / LOGS (ecuaplac_admin_logs)
CREATE TABLE IF NOT EXISTS ecuaplac_admin_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    action_type TEXT NOT NULL, -- 'upload', 'edit', 'delete', 'order', 'security', 'profile'
    description TEXT NOT NULL,
    details JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE ecuaplac_admin_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Permitir lectura de logs ecuaplac" ON ecuaplac_admin_logs;
DROP POLICY IF EXISTS "Permitir insercion de logs ecuaplac" ON ecuaplac_admin_logs;
DROP POLICY IF EXISTS "Permitir borrado de logs ecuaplac" ON ecuaplac_admin_logs;

CREATE POLICY "Permitir lectura de logs ecuaplac"
ON ecuaplac_admin_logs FOR SELECT
USING (true);

CREATE POLICY "Permitir insercion de logs ecuaplac"
ON ecuaplac_admin_logs FOR INSERT
WITH CHECK (true);

CREATE POLICY "Permitir borrado de logs ecuaplac"
ON ecuaplac_admin_logs FOR DELETE
USING (true);

-- Insertar log inicial de bienvenida
INSERT INTO ecuaplac_admin_logs (action_type, description)
VALUES ('security', 'Sistema de gestión de Ecuaplac inicializado con éxito');

-- ==============================================================================
-- FIN DEL SCRIPT.
-- ==============================================================================

