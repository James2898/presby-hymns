---
name: Sanctuary Psalter
colors:
  surface: '#f9f9fc'
  surface-dim: '#dadadc'
  surface-bright: '#f9f9fc'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f6'
  surface-container: '#eeeef0'
  surface-container-high: '#e8e8ea'
  surface-container-highest: '#e2e2e5'
  on-surface: '#1a1c1e'
  on-surface-variant: '#434653'
  inverse-surface: '#2f3133'
  inverse-on-surface: '#f0f0f3'
  outline: '#737784'
  outline-variant: '#c3c6d5'
  surface-tint: '#215abd'
  primary: '#00357f'
  on-primary: '#ffffff'
  primary-container: '#004aad'
  on-primary-container: '#a9c1ff'
  inverse-primary: '#b0c6ff'
  secondary: '#735c00'
  on-secondary: '#ffffff'
  secondary-container: '#fed65b'
  on-secondary-container: '#745c00'
  tertiary: '#6e1628'
  on-tertiary: '#ffffff'
  tertiary-container: '#8d2e3d'
  on-tertiary-container: '#ffacb3'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d9e2ff'
  primary-fixed-dim: '#b0c6ff'
  on-primary-fixed: '#001945'
  on-primary-fixed-variant: '#00429b'
  secondary-fixed: '#ffe088'
  secondary-fixed-dim: '#e9c349'
  on-secondary-fixed: '#241a00'
  on-secondary-fixed-variant: '#574500'
  tertiary-fixed: '#ffdadb'
  tertiary-fixed-dim: '#ffb2b8'
  on-tertiary-fixed: '#40000f'
  on-tertiary-fixed-variant: '#812535'
  background: '#f9f9fc'
  on-background: '#1a1c1e'
  surface-variant: '#e2e2e5'
typography:
  display-lg:
    fontFamily: Space Grotesk
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: 0.02em
  display-lg-mobile:
    fontFamily: Space Grotesk
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: 0.01em
  headline-hymn-num:
    fontFamily: Space Grotesk
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: 0.05em
  headline-title:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: 0.01em
  headline-title-mobile:
    fontFamily: Space Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: 0.01em
  subheading-meter:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
    letterSpacing: 0.08em
  body-stanza:
    fontFamily: Source Serif 4
    fontSize: 19px
    fontWeight: '400'
    lineHeight: 32px
    letterSpacing: -0.01em
  body-stanza-bold:
    fontFamily: Source Serif 4
    fontSize: 19px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  body-refrain:
    fontFamily: Source Serif 4
    fontSize: 19px
    fontWeight: '400'
    lineHeight: 32px
    letterSpacing: -0.01em
  body-reading:
    fontFamily: Source Serif 4
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  label-badge:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.06em
  label-ui:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  caption-meta:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-tablet: 1.5rem
  margin: 1rem
  margin-tablet: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
  space-2xl: 3.5rem
---

## Brand & Style

This design system embodies the dignity, reverence, and enduring legacy of reformed liturgical worship translated into a contemporary mobile experience. Crafted specifically for congregation members, choir directors, organists, and clergy navigating sacred songbooks on personal mobile devices, the interface balances timeless sanctuary solemnity with effortless digital readability.

The visual direction combines **Editorial Sacred Typography** with **Refined Liturgical Structure**. It pulls inspiration from finely bound hymnals, choir lectionaries, and chapel architecture. The aesthetic avoids cold, sterile modernism and overbearing ornamentation, instead using disciplined geometric framing, dignified proportions, and distinct warm-toned backgrounds to ground the user in a reflective, contemplative state.

Key visual pillars include:
- **Sacred Hierarchy:** Stately, geometric vintage titling paired with authoritative, highly legible body typography designed for low-light chapel environments.
- **Bilingual Clarity:** Tactile, distinct paper-like canvas tones that provide an instantaneous cognitive switch between English and Tagalog hymnody without visual dissonance.
- **Liturgical Preciousness:** Deliberate gold rules, subtle parchment textures, hairline rules, and deep liturgical blue surfaces that evoke leather-bound covers and gilded page edges.

## Colors

The palette is derived from classic church appointments—deep royal choir vestments, polished brass and gold altar vessels, aged hymnal pages, and rich communion wine.

### Canvas Modes & Linguistic Distinctions
To provide instant contextual feedback during bilingual services, the reading canvas adopts distinct, reverent backgrounds:
- **English Hymn Canvas:** `#FBF9F5` (Crisp Sanctuary Parchment). A clean, elevated warm white that eliminates harsh glare under sanctuary lighting while preserving high contrast.
- **Tagalog Hymn Canvas:** `#F5EFE6` (Warm Liturgical Ochre Cream). A gentle, amber-tinted cream that gives Filipino translations an immediate, warm identity while maintaining identical typographic rules.
- **Global Dark Mode (Vespers / Compline):** `#0E1318` base with `#161D24` elevated surfaces, using muted gold `#DFBE53` and illuminated royal blue `#2B72D6` to preserve eye comfort in dimly lit evening sanctuaries.

### Functional Roles
- **Primary (`#004aad`):** Liturgical Royal Blue. Used for major structural actions, selected tabs, hymn number badges, and dominant headers.
- **Secondary (`#d4af37`):** Dull Church Gold / Brass. Reserved for sacred accents, stanza numbers, music notation anchors, divider flourishes, and dual-language tags.
- **Tertiary (`#6b1426`):** Liturgical Crimson. Employed sparingly for rubric notes, chorus markers (Refrain/Koro), liturgical instructions, and liturgical calendar badges (e.g., Pentecost, Advent).
- **Neutral Foreground (`#1b1d1f`):** Dense Iron Charcoal. Used for hymn stanzas, titles, and sheet music icons, providing sharper contrast than pure black without bleeding on high-DPI displays.
- **Subtle Surface Tint:** `#EBE5DC` for borders, dividers, and inactive card backgrounds.

## Typography

The typographic system pairs the bold, architectonic, geometric authority of **Space Grotesk** (emulating the vintage industrial gravitas of classic display lettering like Norwester) with the supreme literary legibility of **Source Serif 4** for hymn verses. System controls and auxiliary liturgical metadata rely on **Inter** for neutral clarity.

### Implementation Guidelines
- **Hymn Numbers:** Set in uppercase Space Grotesk with expanded tracking. Numbers act as prominent orientation anchors on page corners and index cards.
- **Stanza Verses:** Set at an accessible `19px` with a generous `32px` line-height. This increased spacing accommodates users holding phones at chest height during congregational singing.
- **Refrains & Choruses:** Indented by `1.5rem` from the left edge and rendered in italicized Source Serif 4, marked with a bold crimson rubric label: `KORO:` or `REFRAIN:`.
- **Hymn Metadata:** Tune name, meter (e.g., `8.7.8.7.D`), author, and scripture references are set in uppercase Inter with wide letter spacing (`0.08em`) to keep supplementary details unobtrusive.

## Layout & Spacing

The layout is built upon an adaptive fluid grid optimized for vertical mobile single-hand scanning while gracefully adapting to tablet choir stands.

### Breakpoints & Canvas Bounds
- **Mobile (< 640px):** Single-column layout. Margin set to `space-md` (`1rem`). The hymn stanza view spans the full width with a maximum reading column width of `58ch` to avoid loose line lengths.
- **Tablet (640px - 1024px):** Optimized for piano and choir stands. Dual-pane mode allows side-by-side display of English and Tagalog stanzas or simultaneous sheet-music preview alongside poetic lyrics. Outer margins increase to `2rem`.
- **Desktop / Display Projection (> 1024px):** Fixed centered reading container maxing out at `768px` for focused reading, or dual-column presentation for sermon study.

### Vertical Rhythm for Sung Worship
Spacing between individual lines in a hymn verse is tight and rhythmic, while the space between stanzas is generous (`space-xl` / `2.25rem`). This deliberate distance prevents singers from accidentally jumping to the wrong verse during congregational singing.

## Elevation & Depth

This system avoids synthetic floating elevations and modern drop shadows. Instead, it captures the flat, dignified, layered physical quality of leather hymnals, paper inserts, and gold-foil stamping through **tactile tonal layering and crisp low-contrast borders**.

### Layering Model
- **Base Layer (L0):** The paper canvas (`#FBF9F5` for English, `#F5EFE6` for Tagalog). Pure flat background with zero drop shadows.
- **Structural Framing (L1):** Hymn selection cards, choir collection folders, and search modules sit on a crisp white surface (`#FFFFFF`) bound by a 1px solid border in `#E6DFD5`.
- **Overlay & Sheet Drawers (L2):** Key transposition sheets, audio accompaniment drawers, and index popovers use a crisp 1px border in `#004aad` with an ambient, deep shadow: `0 8px 24px -4px rgba(0, 74, 173, 0.12)`.
- **Gold Accent Foiling:** Active tabs, language switch indicators, and liturgical rubrics incorporate a double-hairline or solid gold stroke (`#d4af37`), reminiscent of gold leaf on liturgical book spines.

## Shapes

The design system employs a **Soft (Level 1)** geometric shape language. Sharp right angles convey institutional rigidity, while excessive pill shapes dilute the sacred, historic solemnity of hymnal literature. Soft corners (`0.25rem` / `4px`) echo the gentle natural rounding of trimmed book pages and pressed leather corners.

### Shape Scale
- **Badges, Tags, Hymn Numbers:** `rounded` (`0.25rem` / `4px`) for structured, architectural precision.
- **Cards, Stanza Containers, Dialogs:** `rounded-lg` (`0.5rem` / `8px`) providing a tailored, refined silhouette.
- **Audio Play/Pause & Liturgical Action Buttons:** Circular or softly squared with `0.25rem` borders, retaining deliberate mechanical precision.

## Components

### 1. Hymn Reader Stanza Block
- **Layout:** Verse numeral aligned to the left in Space Grotesk Bold, colored in Secondary Gold (`#d4af37`). Stanza text indented cleanly with unbroken left justification.
- **Refrain Box:** Outlined with a 1px left-border stroke in Liturgical Crimson (`#6b1426`) with a 0.75rem padding, signaling communal chorus response.

### 2. Language Toggle & Bilingual Badges
- **Bilingual Badge:** Compact tag with a 1px solid border. 
  - English Available: `#004aad` text and border on an off-white background.
  - Tagalog Available: `#8A6708` text on `#F5EFE6` background with gold border.
- **Language Switch Bar:** Fixed segmented toggle positioned at the header or bottom safe area. Active state fills with Deep Liturgical Blue (`#004aad`) and white bold text; inactive state displays in muted neutral with subtle parchment fill. Switching languages smoothly transitions the background hue of the hymn reading canvas.

### 3. Hymn Index Card (List Item)
- **Structure:** Clean tabular row separated by a hairline rule (`#EAE3D9`).
- **Left Slot:** Prominent bold hymn number in a fixed-width container (`3.5rem`), rendered in Primary Royal Blue.
- **Center Slot:** Primary hymn title in Space Grotesk, followed by the first line of the first verse (incipit) in Source Serif 4 italic.
- **Right Slot:** Badges indicating dual-language availability (e.g., `ENG | TGL`), musical key (e.g., `Ab Maj`), and meter.

### 4. Search & Scripture Scripture Filter
- **Input Field:** Clean 1px border (`#D1C7B7`), transitioning to `#004aad` on focus. No heavy dropshadows. Search icon rendered in muted liturgical blue.
- **Filter Chips:** Categorical tags (e.g., "Paskwa / Advent", "Bautismo", "Eukaristiya", "Papuri") set with a 1px border in `#d4af37` and soft parchment fill.

### 5. Hymnal Audio & Pitch Player Bar
- **Surface:** Docked bottom floating container with royal blue boundary hairline and background set to `#FFFFFF`.
- **Controls:** Minimalist play/pause button in Primary Blue (`#004aad`), accompanied by tempo and starting pitch indicators (`C4 organ cue`) to guide congregational song leaders.

### 6. Buttons & Interactive Controls
- **Primary Button:** Solid Liturgical Royal Blue (`#004aad`) fill, `#FFFFFF` text, subtle 1px inner gold border highlight on active press.
- **Secondary / Liturgical Action:** Outlined with 1.5px Secondary Gold (`#d4af37`), neutral dark text, hovering to an amber-gold tint (`#FDF8EE`).