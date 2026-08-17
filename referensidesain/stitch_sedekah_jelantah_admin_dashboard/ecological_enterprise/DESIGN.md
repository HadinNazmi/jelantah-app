---
name: Ecological Enterprise
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
  on-surface-variant: '#3e4943'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#6e7a73'
  outline-variant: '#bdc9c1'
  surface-tint: '#006c4e'
  primary: '#005d42'
  on-primary: '#ffffff'
  primary-container: '#047857'
  on-primary-container: '#9ffdd3'
  inverse-primary: '#7bd8b1'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#734700'
  on-tertiary: '#ffffff'
  tertiary-container: '#945d00'
  on-tertiary-container: '#ffe6cc'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#97f5cc'
  primary-fixed-dim: '#7bd8b1'
  on-primary-fixed: '#002115'
  on-primary-fixed-variant: '#00513a'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.2'
  title-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
  mono-data:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: -0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-margin: 24px
  gutter: 16px
  card-padding: 20px
  section-gap: 32px
---

## Brand & Style
The design system is engineered for an enterprise-grade environmental platform, balancing ecological warmth with professional administrative rigor. The brand personality is **dependable, transparent, and vibrant**, aimed at government officials, logistics managers, and environmental contributors.

The design style utilizes **Corporate Modernism** with a touch of **Tactile Softness**. It avoids the sterility of typical SaaS by using organic greens and subtle elevation, ensuring the interface feels as healthy and sustainable as the initiative it supports. The emotional response should be one of "structured optimism"—users should feel that their environmental impact is being tracked with absolute precision.

## Colors
This design system uses a hierarchical green palette to signify growth and environmental stewardship, punctuated by a functional amber accent.

- **Primary (Deep Emerald Pine):** Used for navigation backgrounds, primary actions, and high-level structural elements.
- **Secondary (Bright Emerald):** Used for success states, active indicators, and secondary buttons.
- **Tertiary (Jelantah Gold):** Reserved specifically for "Points," "Value," and "Currency" indicators to create a mental link between recycling and economic benefit.
- **Surface (Mint):** Applied to light backgrounds of cards or active menu items to provide a soft, branded alternative to pure white.
- **Neutrals:** The background uses a cool slate-white to keep the UI feeling airy, while text is kept in high-contrast navy-slate for maximum readability.

## Typography
**Inter** is the core typeface for its exceptional legibility in data-heavy dashboard environments. 

- **Weight Strategy:** Use Bold (700) and Semi-Bold (600) for headlines to establish clear hierarchy. Use Regular (400) for all body copy to maintain a clean aesthetic.
- **Data Display:** For numerical values (e.g., liters of oil, point totals), use the `mono-data` style with tabular lining figures to ensure vertical alignment in tables.
- **Hierarchy:** Ensure `label-caps` is used for non-interactive metadata to distinguish it from clickable body text.

## Layout & Spacing
The system utilizes a **8px linear scale** for all spacing tokens.

- **Grid Model:** A 12-column fluid grid for desktop with 24px outer margins and 16px gutters.
- **Dashboard Layout:** A fixed-width left sidebar (280px) with a fluid content area. On tablet, the sidebar collapses into a rail (80px).
- **Responsive Behavior:** On mobile devices, the 12-column grid collapses to 4 columns. Section gaps reduce from 32px to 24px to conserve vertical real estate.
- **Information Density:** Use `card-padding` (20px) as the standard for all data containers to ensure content breathes while maintaining a high density of information.

## Elevation & Depth
This design system uses **Tonal Layering** combined with **Ambient Shadows** to create a sense of organized depth.

- **Level 0 (Background):** #F8FAFC. The lowest layer.
- **Level 1 (Cards/Containers):** Pure white (#FFFFFF) with a very soft, diffused shadow (0px 4px 12px rgba(15, 23, 42, 0.05)).
- **Level 2 (Dropdowns/Modals):** Pure white with a more pronounced shadow (0px 12px 24px rgba(15, 23, 42, 0.1)).
- **Interactive Depth:** Buttons should use a subtle 1px inner stroke in a slightly darker shade than their background color to provide a "tactile" feel without looking dated.

## Shapes
The shape language is **Rounded**, reflecting the "circular" nature of the recycling economy. 

- **Components:** Standard buttons and input fields use an 8px (0.5rem) radius.
- **Containers:** Dashboard cards and main content areas use a 16px (1rem) radius.
- **Badges/Chips:** Status indicators use a 100px (full pill) radius to distinguish them from interactive buttons.
- **Visual Motif:** Use circular icons and avatars to reinforce the brand’s "Cycle" theme.

## Components
Consistent implementation of these components ensures an enterprise-grade feel:

- **Buttons:**
    - *Primary:* Deep Emerald Pine background, White text.
    - *Secondary:* Mint Surface background, Deep Emerald Pine text.
    - *Action:* Jelantah Gold background for "Value Claim" or "Redeem" actions.
- **Status Badges (Pill-shaped, low-opacity backgrounds):**
    - `Buka`: Emerald Background (10% opacity), Emerald Text.
    - `Tutup`: Slate Background (10% opacity), Slate Text.
    - `Pending`: Amber Background (10% opacity), Amber Text.
    - `Terverifikasi`: Blue Background (10% opacity), Blue Text.
    - `Selesai`: Deep Green Background (20% opacity), Deep Green Text.
- **Input Fields:** 1px border (#E2E8F0), 8px radius. Active state uses 1px #10B981 border with a 3px soft Emerald outer glow.
- **Cards:** 16px radius, white background, level 1 shadow. Header sections within cards should have a subtle bottom border.
- **Custom Indicators:** 
    - *Oil Drum Metric:* A custom progress bar or "fill" icon representing oil collection volume.
    - *Impact Map:* Map markers should use the Primary color for standard hubs and Jelantah Gold for high-value collection points.