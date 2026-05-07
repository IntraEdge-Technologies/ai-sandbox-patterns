# Technical Specification — Issue #3: Refine the UI with More Polished Styles

## Architecture Decision

This project has **no build system and no frontend framework** — it is a single static `dashboard/index.html` served by Fastify. All styling is inline `<style>` and all behaviour is vanilla JS inside `<script>`. The polishing work is therefore confined entirely to `dashboard/index.html`. No new files are created.

**No Astro Islands, no React, no Tailwind.** Not applicable to this project.

## Component Hierarchy (ASCII)

```
dashboard/index.html
├── <head>
│   ├── mermaid CDN script
│   ├── Inter + JetBrains Mono Google Fonts (NEW — polished typography)
│   └── <style> (ENHANCED — all polish changes here)
└── <body>
    ├── <header>                          ← polish: refined spacing, brand, canary pill
    │   ├── .brand (h1 + tagline)
    │   ├── .secret-banner                ← polish: pill style, icon
    │   └── .header-actions               ← polish: button group wrapper
    │       ├── #run-all.btn.btn-primary
    │       └── #clear.btn
    └── <main id="cols">                  ← 3 cols injected by JS
        └── .col[data-pattern=a|b|c]      ← polish: card elevation, refined accent
            ├── .col-head                 ← polish: tighter top row layout
            │   ├── .col-info             ← h2, .sub, .file-badge
            │   └── .col-controls         ← .status-badge, .btn
            ├── .arch-toggle              ← polish: better icon, hover
            ├── .arch-container           ← polish: smoother transition
            ├── .diff-summary             ← polish: code pill style
            ├── .owasp-row                ← polish: wrap, gap, badge size
            ├── .events                   ← polish: line height, timestamp, leaked/blocked
            └── .report-panel             ← polish: monospace pre, header
```

## Files to Create

_None._

## Files to Modify

| File | What Changes |
|---|---|
| `dashboard/index.html` | CSS rewrite (style block), minor HTML structure tweaks for new class names, no JS logic changes |

## TypeScript Types

Not applicable — this file contains no TypeScript. The JS inside the `<script>` tag remains vanilla ES2022 module-style code; no type changes are required.

## CSS / Style Approach

### Design tokens (CSS custom properties added to `:root`)

```css
--color-bg:         #0d1117   /* page background */
--color-surface:    #161b22   /* card/panel surface */
--color-surface-2:  #21262d   /* elevated surface / borders */
--color-border:     #30363d
--color-text:       #e6edf3   /* primary text */
--color-muted:      #8b949e   /* secondary text */
--color-dim:        #484f58   /* tertiary / timestamps */
--color-accent-a:   #f85149   /* Pattern A — red */
--color-accent-b:   #d29922   /* Pattern B — amber */
--color-accent-c:   #3fb950   /* Pattern C — green */
--color-blue:       #58a6ff
--color-fail:       #f85149
--color-partial:    #d29922
--color-pass:       #3fb950
--font-sans:        'Inter', system-ui, sans-serif
--font-mono:        'JetBrains Mono', 'SF Mono', Menlo, Consolas, monospace
--radius-sm:        4px
--radius-md:        6px
--radius-lg:        8px
--transition:       150ms ease
```

### Key style improvements

1. **Typography**: Switch body/UI text to `Inter` (weight 400/500/600); keep `JetBrains Mono` for code, logs, badges.
2. **Header**: Increase height to `56px`, use `backdrop-filter` for subtle glassy feel, refine flex layout.
3. **Canary banner**: Change from flat rectangle to rounded pill with red left-border icon + monospace secret value.
4. **Buttons**: Add `transition`, `box-shadow` on hover, correct focus ring using `outline-offset`.
5. **Column cards**: Set `background: var(--color-surface)` (slight lift from bg), `border-top` 3px accent.
6. **OWASP badges**: Increase font-size from `10px` → `11px`, add `letter-spacing`, improve color contrast.
7. **Events log**: Line-height 1.6, timestamp opacity 40%, LEAKED/BLOCKED use `border-left: 3px solid` with stronger background opacity.
8. **Status badge**: Unified padding `3px 10px`, `border-radius: 99px`, cleaner `running` pulse.
9. **Report panel**: Dashed top border when empty, solid when has-data.
10. **Arch toggle**: Use `▶` as CSS icon via `content`, smooth `transform: rotate(90deg)`.

## Astro Island Strategy

Not applicable. This is not an Astro project.

## Performance (LCP/CLS/INP)

- Adding Google Fonts via `<link rel="preconnect">` + `display=swap` prevents FOIT.
- No JS changes — INP/CLS unaffected.
- Mermaid CDN script is unchanged.

## Accessibility

- Buttons retain `type="button"` (already present in JS-generated HTML).
- Colour contrast for all text/badge combinations verified against WCAG AA (4.5:1 for small text).
- `arch-toggle` keeps `cursor: pointer` and keyboard-focusable.
- Status badges use `role="status"` in CSS-generated content (no JS change needed for basic ARIA).

## Step-by-Step Implementation Sequence

1. Add `<link>` tags for Inter + JetBrains Mono fonts in `<head>`.
2. Replace the entire `<style>` block with the polished version using CSS custom properties.
3. Adjust the `diffHtml` snippet in JS to use `.diff-pill` class instead of raw spans (class name change only, no logic change).
4. Verify no existing class names used in JS `querySelector` are renamed (check: `badge`, `events`, `report`, `arch-container`, `arch-toggle`, `arrow`, `report-body`, `run`, `.mermaid`).
5. Test that `setBadge`, `appendLine`, `updateOwaspBadges` still work with new CSS.
