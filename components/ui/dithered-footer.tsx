"use client";

import { useRef, useState, type CSSProperties, type FormEvent, type PointerEvent, type ReactNode } from "react";

export type FooterLink = { label: string; href: string };
export type FooterColumn = { title: string; links: FooterLink[] };
export type FooterSocial = { label: string; href: string; icon: ReactNode };

export type DitheredFooterProps = {
    brand?: string;
    /** Where the wordmark links to. */
    brandHref?: string;
    tagline?: string;
    columns?: FooterColumn[];
    socials?: FooterSocial[];
    legal?: FooterLink[];
    copyright?: string;
    /** Link to your real status page, shown with a green dot. Off unless you pass one. */
    status?: FooterLink | null;
    /** Colour of the dot field. It is the footer's only colour, so it carries the brand. */
    accent?: string;
    /** Called with the email address. Resolve to show the success message. */
    onSubscribe?: (email: string) => void | Promise<void>;
};

// Stochastic dither: vertical noise, sparse at the top and dense at the bottom,
// thresholded to on/off in one inline SVG filter. Used as a mask, so the dots
// take whatever accent colour you pass.
const DITHER =
    "url('data:image/svg+xml,%3Csvg%20xmlns%3D%27http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%27%20width%3D%27360%27%20height%3D%27240%27%3E%3Cdefs%3E%3ClinearGradient%20id%3D%27g%27%20x1%3D%270%27%20y1%3D%270%27%20x2%3D%270%27%20y2%3D%271%27%3E%3Cstop%20offset%3D%270.04%27%20stop-color%3D%27%23000%27%2F%3E%3Cstop%20offset%3D%270.96%27%20stop-color%3D%27%23fff%27%2F%3E%3C%2FlinearGradient%3E%3Cfilter%20id%3D%27f%27%20x%3D%270%27%20y%3D%270%27%20width%3D%27100%25%27%20height%3D%27100%25%27%20color-interpolation-filters%3D%27sRGB%27%3E%3CfeTurbulence%20type%3D%27fractalNoise%27%20baseFrequency%3D%270.45%27%20numOctaves%3D%272%27%20seed%3D%277%27%20stitchTiles%3D%27stitch%27%20result%3D%27n%27%2F%3E%3CfeColorMatrix%20in%3D%27n%27%20type%3D%27matrix%27%20values%3D%271%200%200%200%200%201%200%200%200%200%201%200%200%200%200%200%200%200%200%201%27%20result%3D%27ng%27%2F%3E%3CfeComposite%20in%3D%27SourceGraphic%27%20in2%3D%27ng%27%20operator%3D%27arithmetic%27%20k2%3D%270.5%27%20k3%3D%270.5%27%20result%3D%27s%27%2F%3E%3CfeComponentTransfer%20in%3D%27s%27%20result%3D%27t%27%3E%3CfeFuncR%20type%3D%27discrete%27%20tableValues%3D%270%201%27%2F%3E%3C%2FfeComponentTransfer%3E%3CfeColorMatrix%20in%3D%27t%27%20type%3D%27matrix%27%20values%3D%270%200%200%200%201%200%200%200%200%200.5%200%200%200%200%200%201%200%200%200%200%27%2F%3E%3C%2Ffilter%3E%3C%2Fdefs%3E%3Crect%20width%3D%27100%25%27%20height%3D%27100%25%27%20fill%3D%27url%28%23g%29%27%20filter%3D%27url%28%23f%29%27%2F%3E%3C%2Fsvg%3E')";

const GRID = "radial-gradient(circle, #000 0.9px, transparent 1.3px)";

// Scoped by the df- prefix. Masks and motion live here rather than in utility
// classes, so the component renders the same on Tailwind v3 and v4.
const STYLES = `
.df-field { position: absolute; inset: 0; }
.df-field.df-lit {
  -webkit-mask-image: radial-gradient(circle 190px at var(--df-x, 50%) var(--df-y, 50%), #000 35%, rgb(0 0 0 / .22) 100%);
  mask-image: radial-gradient(circle 190px at var(--df-x, 50%) var(--df-y, 50%), #000 35%, rgb(0 0 0 / .22) 100%);
}
.df-dots {
  position: absolute; top: 0; bottom: 0; left: 0;
  width: calc(100% + 360px);
  background: var(--df-accent);
  -webkit-mask-image: ${GRID}, ${DITHER};
  mask-image: ${GRID}, ${DITHER};
  -webkit-mask-size: 4px 4px, 360px 240px;
  mask-size: 4px 4px, 360px 240px;
  -webkit-mask-repeat: repeat, repeat-x;
  mask-repeat: repeat, repeat-x;
  -webkit-mask-position: 0 0, left bottom;
  mask-position: 0 0, left bottom;
  -webkit-mask-composite: source-in;
  mask-composite: intersect;
}
@media (prefers-reduced-motion: no-preference) {
  .df-dots { animation: df-drift 40s linear infinite; }
  @supports (animation-timeline: view()) {
    .df-band { view-timeline: --df-band; }
    .df-mark { animation: df-rise linear both; animation-timeline: --df-band; animation-range: entry 20% entry 100%; }
  }
}
@keyframes df-drift { to { translate: -360px 0; } }
@keyframes df-rise { from { translate: 0 30%; } }
`;

const toLinks = (labels: string[]): FooterLink[] =>
    labels.map((label) => ({ label, href: "/" + label.toLowerCase().replace(/\s+/g, "-") }));

const icon = (d: string) => (
    <svg viewBox="0 0 24 24" className="h-4 w-4" fill="currentColor" aria-hidden="true"><path d={d} /></svg>
);

const DEFAULT_SOCIALS: FooterSocial[] = [
    { label: "Instagram", href: "https://www.instagram.com/ecuaplac.jyg?igsh=MTJ6d2I3cDFnempyZg==", icon: icon("M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.051.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z") },
];

const DEFAULT_COLUMNS: FooterColumn[] = [
    { title: "Navegación", links: [{ label: "Inicio", href: "#hero-scroll-container" }, { label: "Reformas", href: "reformas.html" }, { label: "Servicios", href: "#servicios" }, { label: "Contacto", href: "#contacto" }] },
    { title: "Legal", links: [{ label: "Aviso Legal", href: "aviso-legal.html#aviso-legal" }, { label: "Política de Cookies", href: "aviso-legal.html#cookies" }, { label: "Términos y Condiciones", href: "aviso-legal.html#terminos" }] },
];

const focus = "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[var(--df-accent)]";
const coarse = "[@media(pointer:coarse)]:inline-flex [@media(pointer:coarse)]:min-h-11 [@media(pointer:coarse)]:items-center";

export default function DitheredFooter({
    brand = "ECUAPLAC",
    brandHref = "/",
    tagline = "Especialistas en reformas integrales, pladur y aislamientos en Palma de Mallorca.",
    columns = DEFAULT_COLUMNS,
    socials = DEFAULT_SOCIALS,
    legal = [{ label: "Aviso Legal", href: "aviso-legal.html" }, { label: "Cookies", href: "aviso-legal.html#cookies" }],
    copyright = `© ${new Date().getFullYear()} ECUAPLAC. TODOS LOS DERECHOS RESERVADOS.`,
    status = null,
    accent = "#FFB81C",
    onSubscribe,
}: DitheredFooterProps) {
    const [email, setEmail] = useState("");
    const [state, setState] = useState<"idle" | "sending" | "done" | "error">("idle");
    const field = useRef<HTMLDivElement>(null);
    const frame = useRef(0);

    const submit = async (e: FormEvent) => {
        e.preventDefault();
        setState("sending");
        try {
            await onSubscribe?.(email);
            setState("done");
            setEmail("");
        } catch {
            setState("error");
        }
    };

    // Spotlight: dots under a mouse pointer stay at full strength and the rest dim.
    const onMove = (e: PointerEvent<HTMLDivElement>) => {
        if (e.pointerType !== "mouse" || !field.current) return;
        const el = field.current;
        const r = el.getBoundingClientRect();
        const x = e.clientX - r.left, y = e.clientY - r.top;
        cancelAnimationFrame(frame.current);
        frame.current = requestAnimationFrame(() => {
            el.style.setProperty("--df-x", `${x}px`);
            el.style.setProperty("--df-y", `${y}px`);
            el.classList.add("df-lit");
        });
    };
    const onLeave = () => {
        cancelAnimationFrame(frame.current);
        field.current?.classList.remove("df-lit");
    };

    const toTop = () =>
        window.scrollTo({ top: 0, behavior: matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth" });

    return (
        <footer
            className="overflow-hidden border-t border-border bg-[#141414] text-foreground"
            style={{ "--df-accent": accent } as CSSProperties}
        >
            <style>{STYLES}</style>

            <div className="mx-auto grid max-w-6xl grid-cols-2 gap-x-6 gap-y-12 px-6 pb-16 pt-16 sm:gap-x-10 sm:px-8 md:grid-cols-[minmax(0,1.6fr)_repeat(2,minmax(0,1fr))]">
                <div className="col-span-2 md:col-span-1">
                    <a href={brandHref} className={`rounded-sm text-base font-semibold tracking-tight ${focus}`}>{brand}</a>
                    <p className="mt-3 max-w-xs text-sm leading-relaxed text-muted-foreground">{tagline}</p>
                </div>

                {columns.map((col) => (
                    <nav key={col.title} aria-label={col.title}>
                        <p className="text-sm font-medium text-foreground">{col.title}</p>
                        <ul className="mt-4 space-y-3 [@media(pointer:coarse)]:space-y-0">
                            {col.links.map((l) => (
                                <li key={l.label}>
                                    <a href={l.href} className={`rounded-sm text-sm text-muted-foreground transition-colors hover:text-foreground ${focus} ${coarse}`}>{l.label}</a>
                                </li>
                            ))}
                        </ul>
                    </nav>
                ))}
            </div>

            {/* The name is not drawn: it is the gap in the dots. */}
            <div aria-hidden="true" className="df-band relative h-60 overflow-hidden" onPointerMove={onMove} onPointerLeave={onLeave}>
                <div ref={field} className="df-field">
                    <div className="df-dots" />
                </div>
                <p className="df-mark pointer-events-none absolute -bottom-[0.05em] left-3 select-none text-[clamp(5rem,21vw,13rem)] font-bold leading-[0.8] tracking-[-0.06em] text-[#141414] sm:left-5">
                    {brand}
                </p>
            </div>

            <div className="border-t border-border">
                <div className="mx-auto flex max-w-6xl flex-col gap-4 px-6 py-5 text-sm text-muted-foreground sm:flex-row sm:items-center sm:justify-between sm:px-8">
                    <div className="flex flex-wrap items-center gap-x-5 gap-y-2">
                        <p>{copyright}</p>
                        {legal.map((l) => (
                            <a key={l.label} href={l.href} className={`rounded-sm transition-colors hover:text-foreground ${focus} ${coarse}`}>{l.label}</a>
                        ))}
                    </div>
                    <div className="-mr-2 flex items-center gap-1">
                        {socials.map((s) => (
                            <a
                                key={s.label}
                                href={s.href}
                                aria-label={s.label}
                                className={`grid h-9 w-9 place-items-center rounded-md transition-colors hover:bg-foreground/5 hover:text-foreground ${focus} [@media(pointer:coarse)]:h-11 [@media(pointer:coarse)]:w-11`}
                            >
                                {s.icon}
                            </a>
                        ))}
                        <span className="mx-2 h-4 w-px bg-border" aria-hidden="true" />
                        <button type="button" onClick={toTop} className={`inline-flex items-center gap-1.5 rounded-sm px-1 transition-colors hover:text-foreground ${focus} ${coarse}`}>
                            Back to top
                            <svg viewBox="0 0 24 24" className="h-3.5 w-3.5" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true"><path d="M12 19V5m-6 6 6-6 6 6" /></svg>
                        </button>
                    </div>
                </div>
            </div>
        </footer>
    );
}

export { DitheredFooter };
