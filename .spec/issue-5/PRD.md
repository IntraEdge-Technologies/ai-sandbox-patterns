# PRD — Dark / Light Mode Switch
**Issue:** #5 · Add a dark and light mode switch
**Author:** Orion (AI) | **Date:** 2026-05-07

---

## Problem Statement

The dashboard (`dashboard/index.html`) is hardcoded to a single dark colour palette. Users who work in bright environments, or whose OS is configured to light mode, cannot adapt the UI to their needs. The issue requests a dark/light mode switch placed in the top-right corner of the header, defaulting to the system preference.

---

## Goals

1. Provide a three-state theme toggle: **System → Light → Dark** (cycles).
2. Default on first visit: **System** (respects `prefers-color-scheme` media query).
3. Toggle placed in the **top-right corner** of the existing header.
4. Persist the user's last choice via `localStorage`.
5. Light-mode palette visually matches the existing design language (GitHub-inspired).

---

## Non-Goals

- No server-side rendering of theme — pure client-side JS only.
- No separate CSS file; styles stay inline with the existing `<style>` block.
- Not adding dark/light variants for any external dependency other than Mermaid.

---

## User Stories

| # | Story |
|---|-------|
| US-1 | As a user, I can see a theme toggle button in the top-right corner of the header. |
| US-2 | As a user, the page loads using my OS colour scheme by default (system mode). |
| US-3 | As a user, I can click the toggle to switch to **Light** mode. |
| US-4 | As a user, I can click the toggle again to switch to **Dark** mode. |
| US-5 | As a user, I can click the toggle again to return to **System** mode. |
| US-6 | As a user, my chosen theme persists when I reload the page. |

---

## Acceptance Criteria

| AC | Description |
|----|-------------|
| AC-1 | A theme toggle control exists in the `header-actions` area (top-right). |
| AC-2 | On first load (no `localStorage` key), the active theme matches `prefers-color-scheme`. |
| AC-3 | Clicking the toggle cycles: system → light → dark → system. |
| AC-4 | In **dark** mode the `<html>` element carries `data-theme="dark"` and the background is dark (`#0d1117`). |
| AC-5 | In **light** mode the `<html>` element carries `data-theme="light"` and the background is light (`#ffffff`). |
| AC-6 | In **system** mode the `<html>` element carries `data-theme="system"` and inherits from the OS media query. |
| AC-7 | The theme choice is saved in `localStorage` under key `theme` and survives a page reload. |
| AC-8 | The toggle button displays an appropriate icon/label for each mode. |
| AC-9 | The toggle is keyboard accessible (focus-visible ring, Enter/Space activation). |
| AC-10 | Mermaid diagrams re-render with the correct theme (dark for dark-mode, default/light for light-mode). |

---

## Out of Scope

- Animated CSS transitions between themes (not requested).
- Per-column or per-component theme overrides.
- Any changes to `server.ts` or agent files.

---

## Design Notes

No design attachments were provided in the issue. The existing dashboard uses a GitHub-style dark palette. The light palette should mirror GitHub's light theme tokens for visual consistency:

| Token | Dark | Light |
|-------|------|-------|
| `--bg` | `#0d1117` | `#ffffff` |
| `--surface` | `#161b22` | `#f6f8fa` |
| `--surface-2` | `#21262d` | `#eaeef2` |
| `--border` | `#30363d` | `#d0d7de` |
| `--border-subtle` | `#21262d` | `#eaeef2` |
| `--text` | `#e6edf3` | `#1f2328` |
| `--text-muted` | `#8b949e` | `#636c76` |
| `--text-dim` | `#484f58` | `#8c959f` |
