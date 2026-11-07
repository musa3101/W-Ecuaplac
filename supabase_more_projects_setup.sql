-- ========================================================
-- ECUAPLAC J&G S.L. - TABLA DE MÁS PROYECTOS (reformas.html)
-- ========================================================

CREATE TABLE IF NOT EXISTS ecuaplac_more_projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title_es TEXT NOT NULL,
    title_en TEXT NOT NULL,
    image_url TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Habilitar RLS
ALTER TABLE ecuaplac_more_projects ENABLE ROW LEVEL SECURITY;

-- Políticas de lectura pública
CREATE POLICY "Permitir lectura publica ecuaplac_more_projects" ON ecuaplac_more_projects
    FOR SELECT USING (true);

-- Políticas de escritura para el gestor móvil
CREATE POLICY "Permitir insercion ecuaplac_more_projects" ON ecuaplac_more_projects
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Permitir actualizacion ecuaplac_more_projects" ON ecuaplac_more_projects
    FOR UPDATE USING (true) WITH CHECK (true);

CREATE POLICY "Permitir borrado ecuaplac_more_projects" ON ecuaplac_more_projects
    FOR DELETE USING (true);

-- Insertar los 11 proyectos iniciales de la sección "Más Proyectos Realizados"
INSERT INTO ecuaplac_more_projects (title_es, title_en, image_url, sort_order, active) VALUES
('Reforma integral de baño — Fase de obra', 'Full bathroom renovation — Construction phase', './assets/img/portfolio/galeria/bano-antes-collage.webp', 10, true),
('Reforma integral de baño — Resultado final', 'Full bathroom renovation — Final result', './assets/img/portfolio/galeria/bano-despues-collage.webp', 20, true),
('Baño en piedra natural con espejos retroiluminados', 'Natural stone bathroom with backlit mirrors', './assets/img/portfolio/galeria/bano-piedra-espejos.webp', 30, true),
('Cerramiento de cristal con ventanales panorámicos', 'Glass enclosure with panoramic windows', './assets/img/portfolio/galeria/cerramiento-cristal-1.webp', 40, true),
('Cerramiento panorámico — Vista frontal', 'Panoramic enclosure — Front view', './assets/img/portfolio/galeria/cerramiento-cristal-frontal.webp', 50, true),
('Falso techo decorativo de pladur en construcción', 'Decorative plasterboard ceiling under construction', './assets/img/portfolio/galeria/techo-pladur-construccion.webp', 60, true),
('Techo circular de pladur — Fase estructural', 'Circular plasterboard ceiling — Structural phase', './assets/img/portfolio/galeria/techo-circular-andamios.webp', 70, true),
('Techo circular de pladur — Detalle de acabado', 'Circular plasterboard ceiling — Finishing detail', './assets/img/portfolio/galeria/techo-circular-detalle.webp', 80, true),
('Salón con iluminación LED perimetral y vistas', 'Living room with perimeter LED lighting and views', './assets/img/portfolio/galeria/salon-led-vistas.webp', 90, true),
('Revestimiento de piedra natural con iluminación', 'Natural stone cladding with integrated lighting', './assets/img/portfolio/galeria/piedra-natural-downlights.webp', 100, true),
('Porche con ventanales — Fase de acabados', 'Porch with windows — Finishing phase', './assets/img/portfolio/galeria/porche-ventanales-obra.webp', 110, true)
ON CONFLICT (id) DO NOTHING;

