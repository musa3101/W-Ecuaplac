-- Tabla de Galería de Proyectos (Antes y Después)
CREATE TABLE IF NOT EXISTS ecuaplac_projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title_es TEXT NOT NULL,
    title_en TEXT NOT NULL,
    description_es TEXT,
    description_en TEXT,
    category_es TEXT,
    category_en TEXT,
    image_before TEXT NOT NULL,
    image_after TEXT NOT NULL,
    caption_before_es TEXT,
    caption_before_en TEXT,
    caption_after_es TEXT,
    caption_after_en TEXT,
    description_before_es TEXT,
    description_before_en TEXT,
    description_after_es TEXT,
    description_after_en TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0
);

-- Tabla de Carrusel de Portafolio en la Home
CREATE TABLE IF NOT EXISTS ecuaplac_carousel (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title_es TEXT NOT NULL,
    title_en TEXT NOT NULL,
    location_es TEXT NOT NULL,
    location_en TEXT NOT NULL,
    image_url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0
);

-- Habilitar Seguridad a Nivel de Fila (RLS)
ALTER TABLE ecuaplac_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE ecuaplac_carousel ENABLE ROW LEVEL SECURITY;

-- Políticas de lectura pública para que cualquier visitante pueda ver los datos
CREATE POLICY "Permitir lectura pública de proyectos ecuaplac" ON ecuaplac_projects
    FOR SELECT USING (active = true);

CREATE POLICY "Permitir lectura pública de carrusel ecuaplac" ON ecuaplac_carousel
    FOR SELECT USING (active = true);

-- ========================================================
-- INSERCIÓN DE DATOS INICIALES (Ecuaplac)
-- ========================================================

-- Limpiar datos existentes para evitar duplicados
TRUNCATE TABLE ecuaplac_carousel;
TRUNCATE TABLE ecuaplac_projects;

-- Insertar elementos del Carrusel de la Home
INSERT INTO ecuaplac_carousel (title_es, title_en, location_es, location_en, image_url, sort_order) VALUES
('Baño de Diseño con Bañera Exenta', 'Designer Bathroom with Freestanding Bathtub', 'Andratx', 'Andratx', './assets/img/portfolio/IMG_2131.jpg', 10),
('Escalera Helicoidal de Yeso Pulido', 'Sculptural Helical Staircase', 'Calvià', 'Calvià', './assets/img/portfolio/IMG_2135.jpg', 20),
('Ducha de Obra con Hornacinas Iluminadas', 'Custom Shower with Illuminated Niches', 'Sóller', 'Sóller', './assets/img/portfolio/IMG_2134.jpg', 30),
('Cocina Moderna Integrada y Minimalista', 'Integrated Minimalist Modern Kitchen', 'Palma de Mallorca', 'Palma de Mallorca', './assets/img/portfolio/IMG_2119.jpg', 40),
('Terraza Exterior y Solárium', 'Outdoor Terrace & Solarium', 'Santanyí', 'Santanyí', './assets/img/portfolio/IMG_2129.jpg', 50),
('Aseo Minimalista de Cortesía', 'Minimalist Guest Toilet', 'Marratxí', 'Marratxí', './assets/img/portfolio/IMG_2132.jpg', 60),
('Distribuidor con Iluminación Indirecta', 'Corridor with Indirect Lighting', 'Palma de Mallorca', 'Palma de Mallorca', './assets/img/portfolio/IMG_2133.jpg', 70),
('Nicho Iluminado para Coleccionismo', 'Illuminated Display Niche', 'Palma de Mallorca', 'Palma de Mallorca', './assets/img/portfolio/IMG_2136.jpg', 80),
('Detalle de Escalera Helicoidal', 'Helical Staircase Detail', 'Calvià', 'Calvià', './assets/img/portfolio/IMG_2138.jpg', 90);

-- Insertar elementos de la Galería "Antes y Después" (reformas.html)
INSERT INTO ecuaplac_projects (
    title_es, title_en, 
    description_es, description_en, 
    category_es, category_en, 
    image_before, image_after, 
    caption_before_es, caption_before_en, 
    caption_after_es, caption_after_en,
    description_before_es, description_before_en,
    description_after_es, description_after_en,
    sort_order
) VALUES
(
    'Reforma Integral de Baño', 'Complete Bathroom Remodel',
    'Sustitución completa de revestimientos por gres porcelánico beige texturizado, plato de ducha a ras de suelo, grifería empotrada negra mate y mueble de roble natural con espejo retroiluminado.', 
    'Complete replacement of wall tiles with textured beige porcelain stoneware, walk-in shower, matte black built-in fixtures, and natural oak vanity with backlit mirror.',
    'Proyecto I', 'Project I',
    './assets/img/portfolio/antes.jpg', './assets/img/portfolio/despues.jpg',
    'Estado Inicial', 'Initial State',
    'Resultado Final', 'Final Result',
    'Instalaciones antiguas y revestimientos obsoletos previos a la demolición.', 'Old installations and obsolete wall tiles prior to demolition.',
    'Acabados en porcelánico premium, plato de resina y grifería de alta gama.', 'Premium porcelain finishes, resin shower base, and high-end fixtures.',
    10
),
(
    'Lavabo Flotante a Medida', 'Custom Floating Sink',
    'Diseño e instalación de encimera volada de piedra tecnológica en tonos neutros, con lavabo cerámico sobre encimera en color negro mate, grifería mural empotrada e instalaciones totalmente ocultas.',
    'Design and installation of a floating technological stone countertop in neutral tones, featuring a matte black ceramic vessel sink, wall-mounted fixtures, and fully concealed installations.',
    'Proyecto II', 'Project II',
    './assets/img/portfolio/antes2.jpg', './assets/img/portfolio/despues2.jpg',
    'Fase Estructural', 'Structural Phase',
    'Ejecución Terminada', 'Completed Execution',
    'Preparación de soportes ocultos e instalaciones empotradas en pared.', 'Preparation of concealed supports and built-in wall installations.',
    'Encimera de piedra volada con seno cerámico negro y grifería mural minimalista.', 'Floating stone countertop with black ceramic sink and minimalist wall-mounted fixtures.',
    20
),
(
    'Vestidor de Pladur y Roble', 'Drywall and Oak Walk-in Closet',
    'Construcción a medida de vestidor y estanterías integradas en pladur con acabados en blanco satinado, cajoneras suspendidas en madera de roble natural y cestas metálicas deslizantes, realzado por iluminación LED cálida indirecta.',
    'Custom construction of a walk-in closet and integrated drywall shelving with a satin white finish, suspended natural oak drawers, and sliding metal baskets, enhanced by warm indirect LED lighting.',
    'Proyecto III', 'Project III',
    './assets/img/portfolio/antes3.jpg', './assets/img/portfolio/despues3.jpg',
    'Proceso Constructivo', 'Construction Process',
    'Entrega Final', 'Final Delivery',
    'Montaje de tabiquería en seco y nivelación de estructuras interiores.', 'Drywall partition assembly and leveling of interior structures.',
    'Vestidor terminado con cajones de roble e iluminación LED.', 'Illuminated walk-in closet with custom woodwork and integrated LED profiles without visible joints.',
    30
),
(
    'Escalera y Distribuidor de Roble', 'Oak Staircase and Hallway',
    'Instalación de peldaños y revestimiento de escalera en madera de roble natural, enmarcado por paredes lisas blancas con puertas empotradas sin marco y luminarias lineales LED de cortesía en los laterales.',
    'Installation of natural oak treads and staircase cladding, framed by smooth white walls with frameless pocket doors and linear LED courtesy lighting on the sides.',
    'Proyecto IV', 'Project IV',
    './assets/img/portfolio/antes4.jpg', './assets/img/portfolio/despues4.jpg',
    'Obra Bruta', 'Rough Construction',
    'Acabado Premium', 'Premium Finish',
    'Peldaños de hormigón en fase de nivelación con láser y replanteo de iluminación.', 'Concrete steps undergoing laser leveling and lighting layout.',
    'Escalera revestida en roble natural masivo con rodapié oculto iluminado.', 'Staircase clad in massive natural oak with concealed illuminated baseboards.',
    40
);

-- Tabla de Información de Contacto Dinámica
CREATE TABLE IF NOT EXISTS ecuaplac_contact (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    name_es TEXT NOT NULL,
    name_en TEXT NOT NULL,
    value_es TEXT NOT NULL,
    value_en TEXT NOT NULL,
    icon TEXT, -- 'phone', 'mail', 'map-pin'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    active BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0
);

-- Habilitar RLS para ecuaplac_contact
ALTER TABLE ecuaplac_contact ENABLE ROW LEVEL SECURITY;

-- Política de lectura pública para contacto
CREATE POLICY "Permitir lectura pública de contacto" ON ecuaplac_contact
    FOR SELECT USING (active = true);

-- Limpiar e Insertar datos iniciales de contacto
TRUNCATE TABLE ecuaplac_contact;

INSERT INTO ecuaplac_contact (key, name_es, name_en, value_es, value_en, icon, sort_order) VALUES
('address', 'Dirección de Proyectos', 'Project Management', 'Palma de Mallorca, Islas Baleares', 'Palma de Mallorca, Balearic Islands', 'map-pin', 10),
('goyo', 'José Rivadeneira', 'José Rivadeneira', '+34 678 15 98 78', '+34 678 15 98 78', 'phone', 20),
('jofrre', 'Joffre Méndez', 'Joffre Méndez', '+34 603 40 44 50', '+34 603 40 44 50', 'phone', 30),
('email', 'Email', 'Email', 'ecuaplac.jyg.sl@gmail.com', 'ecuaplac.jyg.sl@gmail.com', 'mail', 40);

-- ========================================================
-- TABLA DE SOLICITUDES / LEADS (Presupuestos y Contactos)
-- ========================================================
CREATE TABLE IF NOT EXISTS ecuaplac_leads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT,
    phone TEXT,
    email TEXT,
    project_type TEXT,
    message TEXT,
    source_page TEXT DEFAULT 'index.html',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status TEXT DEFAULT 'nuevo'
);

-- Habilitar RLS para ecuaplac_leads
ALTER TABLE ecuaplac_leads ENABLE ROW LEVEL SECURITY;

-- 1. Eliminar políticas previas si existen
DROP POLICY IF EXISTS "Permitir insercion anonima de leads" ON ecuaplac_leads;
DROP POLICY IF EXISTS "Permitir lectura publica de leads" ON ecuaplac_leads;
DROP POLICY IF EXISTS "Permitir insercion de leads desde web" ON ecuaplac_leads;

-- 2. Permitir inserciones válidas desde el formulario web (requiere nombre y contacto)
CREATE POLICY "Permitir insercion de leads desde web" ON ecuaplac_leads
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (
        (name IS NOT NULL AND length(trim(name)) > 0)
        AND (
            (phone IS NOT NULL AND length(trim(phone)) > 0)
            OR (email IS NOT NULL AND length(trim(email)) > 0)
        )
    );

-- NOTA DE SEGURIDAD:
-- No se añade política de SELECT para 'anon' ni 'authenticated'.
-- Los leads solo son visibles desde el panel de control de Supabase o mediante service_role.

