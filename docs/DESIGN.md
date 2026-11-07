---
name: Architectural Monolith
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1b1b1b'
  on-surface-variant: '#4c4546'
  inverse-surface: '#303030'
  inverse-on-surface: '#f1f1f1'
  outline: '#7e7576'
  outline-variant: '#cfc4c5'
  surface-tint: '#5e5e5e'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1b1b1b'
  on-primary-container: '#848484'
  inverse-primary: '#c6c6c6'
  secondary: '#795746'
  on-secondary: '#ffffff'
  secondary-container: '#ffd0bb'
  on-secondary-container: '#7a5747'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1b1b1b'
  on-tertiary-container: '#848484'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2e2e2'
  primary-fixed-dim: '#c6c6c6'
  on-primary-fixed: '#1b1b1b'
  on-primary-fixed-variant: '#474747'
  secondary-fixed: '#ffdbcc'
  secondary-fixed-dim: '#eabda9'
  on-secondary-fixed: '#2d1509'
  on-secondary-fixed-variant: '#5f3f30'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c6'
  on-tertiary-fixed: '#1b1b1b'
  on-tertiary-fixed-variant: '#474747'
  background: '#f9f9f9'
  on-background: '#1b1b1b'
  surface-variant: '#e2e2e2'
  monolith-white: '#FFFFFF'
  canvas-grey: '#F2F2F2'
  mortar-grey: '#666666'
typography:
  headline-xl:
    fontFamily: Montserrat
    fontSize: 48px
    fontWeight: '300'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '400'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '400'
    lineHeight: '1.2'
  body-lg:
    fontFamily: Open Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Open Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-caps:
    fontFamily: Montserrat
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1.0'
    letterSpacing: 0.15em
  caption:
    fontFamily: Open Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.4'
spacing:
  unit: 8px
  gutter: 24px
  margin-desktop: 64px
  margin-mobile: 20px
  max-width: 1440px
---

## Brand & Style

The design system embodies the precision and restraint of high-end architectural practice. It is built on a foundation of **Minimalism**, where negative space is treated as a structural element rather than a void. The aesthetic is curated, silent, and premium, designed to serve as a neutral "gallery wall" that directs all focus toward the project photography.

The emotional response is one of calm authority and timelessness. By stripping away decorative motifs, shadows, and vibrant hues, the UI achieves a sense of permanence. The visual narrative is driven by mathematical alignment, rigid grid structures, and a strictly functional approach to interaction.

## Colors

This design system utilizes a high-contrast, monochrome palette. **Pure Black (#000000)** is the primary anchor for typography and structural borders, ensuring maximum legibility and a sharp, ink-on-paper feel. **Pure White (#FFFFFF)** is the dominant background color to maximize the sense of space.

A secondary **Earth Brown (#5C3D2E)** is used with extreme scarcity, reserved only for meaningful architectural callouts or specific material highlights. Tonal grays are used exclusively for secondary metadata and auxiliary information, ensuring they do not compete with the primary visual content.

## Typography

Typography is used as a structural material. We utilize a pairing of a geometric, architectural sans-serif for headers and a humanist sans-serif for long-form body text. 

- **Headers:** Set in light and regular weights to evoke a technical drawing aesthetic. Large headlines use tight tracking to maintain a solid visual block.
- **Labels:** Always in uppercase with generous letter-spacing to create a sense of breathability and hierarchy without relying on color.
- **Body:** Prioritizes readability with a comfortable line-height, set in a slightly softer typeface to balance the rigidity of the headlines.

## Layout & Spacing

The design system employs a **Fixed Grid** philosophy. Content is contained within a 12-column structure on desktop with significant outer margins to frame the content like an art book.

- **Grid:** 12 columns for desktop, 6 for tablet, 2 for mobile.
- **Margins:** Large horizontal margins (64px+) on desktop are non-negotiable to maintain the premium architectural feel.
- **Vertical Rhythm:** Elements are separated by large blocks of whitespace (multiples of 24px), allowing each "project" or "section" to exist in its own visual vacuum.
- **Reflow:** On mobile, margins tighten to 20px, and the grid collapses into a single-column vertical stack, ensuring full-width photography remains the hero.

## Elevation & Depth

This system avoids the use of shadows, blurs, or gradients to create depth. Instead, hierarchy is communicated through **Tonal Layering** and **Grid Alignment**.

- **Surfaces:** Surfaces are strictly flat. Differentiation between sections is achieved through the alternating use of white and light-grey backgrounds.
- **Borders:** Thin, 1px "technical" lines are used sparingly to separate high-level navigation or to frame data tables.
- **Hierarchy:** Depth is perceived through the scale of images and the "weight" of typography. Higher-priority items occupy more columns or use larger, lighter-weight type.

## Shapes

The shape language is strictly **Sharp**. All UI elements—including buttons, input fields, images, and cards—must have 0px corner radii. This reinforces the architectural and technical nature of the brand. Geometric perfection is prioritized; circles are reserved only for specific iconographic functions (like a "play" button overlay) to contrast against the rigid rectangularity of the layout.

## Components

### Buttons
Primary buttons are "Ghost" style: 1px black borders with uppercase text and no fill. On hover, the button fills with black and the text flips to white. There are no rounded corners.

### Cards & Photography
Cards do not have borders or shadows. They consist of a full-bleed image with a caption or title placed directly below in a strict vertical alignment. Images should maintain a consistent aspect ratio (16:9 or 4:3) across the grid.

### Input Fields
Inputs are simple 1px bottom-borders (underline style) to minimize visual clutter. Labels use the `label-caps` typography style and sit above the line.

### Chips & Tags
Tags are text-only, separated by a pipe character (`|`) or significant horizontal spacing. No background containers are used for tags to keep the UI light.

### Lists
Lists are separated by 1px horizontal dividers. Each list item should have generous vertical padding (minimum 24px) to maintain the airy aesthetic.