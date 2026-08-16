---
name: EcoFlow
colors:
  surface: '#f7f9fb'
  surface-dim: '#d8dadc'
  surface-bright: '#f7f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f6'
  surface-container: '#eceef0'
  surface-container-high: '#e6e8ea'
  surface-container-highest: '#e0e3e5'
  on-surface: '#191c1e'
  on-surface-variant: '#3c4a42'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#6c7a71'
  outline-variant: '#bbcabf'
  surface-tint: '#006c49'
  primary: '#006c49'
  on-primary: '#ffffff'
  primary-container: '#10b981'
  on-primary-container: '#00422b'
  inverse-primary: '#4edea3'
  secondary: '#855300'
  on-secondary: '#ffffff'
  secondary-container: '#fea619'
  on-secondary-container: '#684000'
  tertiary: '#006c4e'
  on-tertiary: '#ffffff'
  tertiary-container: '#57b48f'
  on-tertiary-container: '#00422e'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#6ffbbe'
  primary-fixed-dim: '#4edea3'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#005236'
  secondary-fixed: '#ffddb8'
  secondary-fixed-dim: '#ffb95f'
  on-secondary-fixed: '#2a1700'
  on-secondary-fixed-variant: '#653e00'
  tertiary-fixed: '#97f5cc'
  tertiary-fixed-dim: '#7bd8b1'
  on-tertiary-fixed: '#002115'
  on-tertiary-fixed-variant: '#00513a'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
  slate-navy: '#0F172A'
  slate-muted: '#64748B'
  mint-accent: '#34D399'
  border-grey: '#E2E8F0'
  status-pending-bg: '#FEF3C7'
  status-pending-text: '#D97706'
  status-verified-bg: '#E0F2FE'
  status-verified-text: '#0284C7'
  status-error: '#EF4444'
typography:
  display-hero:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-caps:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  margin-page: 20px
  gutter-card: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
---

## Brand & Style
The design system is built for a waste-to-energy donation platform that merges environmental activism with financial-grade reliability. The brand personality is professional, transparent, and encouraging, aimed at eco-conscious citizens who value efficiency and impact.

The visual style follows a **Modern Corporate / Fintech** movement. It utilizes high-quality whitespace, expansive card layouts, and subtle depth to create a sense of security and modern utility. By borrowing the design language of e-wallet and banking applications, the system elevates the act of "donating oil" into a structured, rewarding financial-like transaction. The interface is characterized by its clarity, use of soft environmental gradients, and high-legibility typography.

## Colors
The palette is rooted in **Emerald Green**, symbolizing sustainability and growth. **Slate Dark Navy** is used for primary text to ensure high contrast and a premium feel, moving away from pure black for a more refined look.

**Amber Gold** serves as the secondary accent, specifically reserved for rewards, points, and value-based highlights to distinguish environmental impact from financial-style incentives. The **Off-White background** provides a clean canvas that allows the "Pure White" surface cards to float distinctly. Gradient usage is restricted to headers, moving from Deep Pine Green to Vibrant Emerald to create a sense of depth and focus at the top of the information hierarchy.

## Typography
**Plus Jakarta Sans** is the exclusive typeface for this design system. Its modern, slightly wide proportions provide a friendly yet technical aesthetic suitable for a dashboard-driven experience.

The hierarchy is built on a tight scale. **Display-hero** is used for impactful metrics (like liter counts). **Headline-lg** is reserved for curved header titles. **Headline-md** defines section starts. Body text is kept at a comfortable **15px** for readability, while **Label-caps** are used for secondary metadata and uppercase status labels. Line heights are generous (1.4x to 1.5x) to maintain a breezy, clean feel.

## Layout & Spacing
The system utilizes a **fluid-to-fixed layout** model designed primarily for mobile. It follows a 4px baseline grid to ensure mathematical consistency across all components.

Horizontal margins are set to **20px** to provide ample breathing room. Vertical spacing follows a "Stack" philosophy: 8px for related elements (icon + text), 16px for internal card padding, and 24px between major sections. Cards should use the full available width minus margins. Grid layouts for quick actions (4-column) should use equal spacing with no visible borders, relying on icon alignment.

## Elevation & Depth
The design system uses **Ambient Shadows** to convey hierarchy. Depth is not achieved through heavy dark shadows, but through subtle, large-radius blurs that make cards feel light and airy.

- **Level 1 (Surface):** Default background (#F8FAFC).
- **Level 2 (Cards):** Pure White (#FFFFFF) with a `0px 4px 20px rgba(15, 23, 42, 0.05)` shadow. Used for standard content.
- **Level 3 (Floating Hero):** High-prominence cards with a `0px 10px 30px rgba(16, 185, 129, 0.12)` shadow, tinted with the primary color to suggest energy and importance.
- **Level 4 (Modals/Navigation):** Fixed elements with a sharp `0px -2px 10px rgba(0, 0, 0, 0.03)` shadow for the bottom navigation bar.

## Shapes
The shape language is defined by large, inviting radii. The core philosophy is "Soft but Structured." 

- **Primary Cards:** 24px corner radius to emphasize the friendly, modern fintech aesthetic.
- **Buttons & Input Fields:** 16px corner radius, providing a tactile and accessible touch target.
- **Status Pills:** 100px (Full Rounded) to distinguish them from interactive buttons.
- **Small Components (Avatars/Icons):** 12px corner radius for consistency.

## Components

### Buttons
- **Primary:** Emerald Green background, White text, 16px radius. Semi-bold.
- **Secondary:** Mint Light (#ECFDF5) background, Emerald text. Used for secondary actions within cards.
- **Ghost:** No background, Emerald or Slate text with icon. Used for "See All" or navigation links.

### Cards
- **Container:** Pure White, 24px radius, subtle shadow.
- **Header Gradient Card:** Uses a linear gradient (top-to-bottom) from Deep Pine Green (#047857) to Emerald (#10B981).

### Inputs
- **Numeric Input:** Large, centered typography for liter counts. Use a soft grey border (#E2E8F0) that turns Emerald Green on focus.
- **Upload Zone:** Dashed border in Slate Muted with a light slate-grey background.

### Status Badges
- **Pills:** Compact, 100px radius. Use the semantic background/text colors defined in the Color section (e.g., Soft Yellow background with Dark Amber text for "Pending").

### Bottom Navigation
- **Dock:** Floating pill-style or edge-to-edge white bar. Active items use Emerald Green for both icon and label, accompanied by a subtle 4px top indicator line. Inactive items use Slate Muted (#94A3B8).