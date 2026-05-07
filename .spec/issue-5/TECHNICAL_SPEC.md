# Technical Specification — Dark / Light Mode Switch
**Issue:** #5 | **Branch:** `ai/issue-5-impl`

---

## Architecture Decision

The dashboard is a **single HTML file** with embedded CSS and vanilla JS, served by Fastify. There is no build step, no bundler, no framework. All changes are confined to `dashboard/index.html`.

**Approach:**
- Add a `data-theme` attribute on `<html>` (values: `"system"` | `"light"` | `"dark"`).
- Define light-mode CSS custom properties under `:root[data-theme="light"]` and explicit dark overrides under `:root[data-theme="dark"]`.
- For `"system"` mode, rely on the existing `:root` defaults (dark) plus a `@media (prefers-color-scheme: light)` block that applies light tokens when the OS is light and `data-theme="system"`.
- Persist selection in `localStorage` key `"theme"` (default: `"system"`).
- Re-run `mermaid.run()` when theme changes to re-render diagrams.

---

## Component Hierarchy

```
dashboard/index.html
├── <html data-theme="system|light|dark">
│   ├── <head>
│   │   └── <style> (CSS custom properties — dark base, light overrides, system media)
│   └── <body>
│       ├── <header>
│       │   ├── .brand
│       │   ├── .secret-banner
│       │   └── .header-actions
│       │       ├── #theme-toggle  ← NEW: theme cycle button
│       │       ├── #run-all
│       │       └── #clear
│       └── <main id="cols">
│           └── (pattern columns — no change)
```

---

## Files to Create

_None._

---

## Files to Modify

| File | Change Summary |
|------|----------------|
| `dashboard/index.html` | (1) Add light + system CSS tokens. (2) Add `#theme-toggle` button in `.header-actions`. (3) Add `initTheme()` JS function. |

---

## TypeScript Types

Not applicable — the dashboard is plain JS in a `<script>` tag. No TypeScript compilation.

---

## CSS Approach

### Token strategy

```css
/* Base tokens — dark by default */
:root {
  --bg: #0d1117;
  --surface: #161b22;
  /* … existing tokens … */
}

/* Explicit dark override (when user forces dark regardless of OS) */
:root[data-theme="dark"] {
  --bg: #0d1117;
  --surface: #161b22;
  --surface-2: #21262d;
  --border: #30363d;
  --border-subtle: #21262d;
  --text: #e6edf3;
  --text-muted: #8b949e;
  --text-dim: #484f58;
}

/* Light theme */
:root[data-theme="light"] {
  --bg: #ffffff;
  --surface: #f6f8fa;
  --surface-2: #eaeef2;
  --border: #d0d7de;
  --border-subtle: #eaeef2;
  --text: #1f2328;
  --text-muted: #636c76;
  --text-dim: #8c959f;
}

/* System: apply light tokens only when OS prefers light AND theme=system */
@media (prefers-color-scheme: light) {
  :root[data-theme="system"] {
    --bg: #ffffff;
    --surface: #f6f8fa;
    --surface-2: #eaeef2;
    --border: #d0d7de;
    --border-subtle: #eaeef2;
    --text: #1f2328;
    --text-muted: #636c76;
    --text-dim: #8c959f;
  }
}
```

### Toggle button styling

```css
#theme-toggle {
  /* inherits .btn styles */
  /* Shows icon + label, e.g. "System ⊙" / "Light ☀" / "Dark ☾" */
  min-width: 80px;
  justify-content: center;
}
```

---

## Astro Island Strategy

Not applicable — this is not an Astro project.

---

## Performance (LCP / CLS / INP)

- **CLS:** Theme is applied synchronously before first paint via an inline `<script>` in `<head>` that reads `localStorage` and sets `data-theme` — prevents flash of wrong theme (FOWT).
- **LCP:** No impact; the toggle button is a small `<button>` element.
- **INP:** Theme switch + Mermaid re-render is synchronous but Mermaid calls are async; no jank concern.

---

## Accessibility

- `#theme-toggle` is a `<button>` — keyboard accessible by default.
- `aria-label` updated dynamically to reflect current mode and next action.
- Focus-visible ring uses existing `--blue` outline (`.btn:focus-visible` rule already defined).
- Colour contrast in light mode verified: `--text` `#1f2328` on `--bg` `#ffffff` → ratio 16.1:1 ✓.

---

## Step-by-Step Implementation Sequence

1. **Inline `<script>` in `<head>`** (before stylesheets load) — reads `localStorage.getItem('theme') ?? 'system'` and sets `document.documentElement.setAttribute('data-theme', value)`. This prevents FOWT.

2. **CSS tokens** — after the existing `:root` block, add:
   - `:root[data-theme="dark"]` (explicit dark)
   - `:root[data-theme="light"]` (light palette)
   - `@media (prefers-color-scheme: light) { :root[data-theme="system"] { … } }` (system light)

3. **HTML button** — inside `.header-actions`, **before** `#run-all`:
   ```html
   <button id="theme-toggle" class="btn" aria-label="Switch theme">System ⊙</button>
   ```

4. **JS `initTheme()` function** — appended to existing `<script>`:
   - Reads current theme from `localStorage` (default `'system'`).
   - Updates button label + `aria-label`.
   - On click: cycles `system → light → dark → system`, saves to `localStorage`, sets `data-theme`, updates label, re-renders Mermaid.
   - Called at the end of `init()`.

5. **Mermaid re-render** — on theme change, call `mermaid.initialize({ theme: resolvedTheme === 'light' ? 'default' : 'dark', … })` then `mermaid.run({ querySelector: '.mermaid' })`.
