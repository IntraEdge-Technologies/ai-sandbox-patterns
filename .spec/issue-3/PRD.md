# PRD — Issue #3: Refine the UI with More Polished Styles

## Problem Statement

The existing `dashboard/index.html` is a functional but visually sparse developer-tool dashboard. Its monospace aesthetic, inconsistent spacing, rudimentary badge styling, and lack of visual hierarchy create a dashboard that feels rough and hard to scan quickly. For a project meant to be demoed at talks and shared publicly, the UI needs to communicate credibility and care.

## Goals

1. Polish the visual design of `dashboard/index.html` without changing any functionality.
2. Improve information hierarchy so the security outcome (LEAKED vs BLOCKED) is immediately obvious.
3. Enhance spacing, colour, and typography consistency throughout.
4. Improve component-level polish: header, column cards, OWASP badge row, events log, architecture toggle, report panel.
5. Add subtle micro-interactions (hover states, transitions) that make the UI feel alive.

## Non-Goals

- Adding new features, routes, or backend behaviour.
- Changing the Fastify server code (`server.ts`).
- Changing any agent code (`agent-a.ts`, `agent-b.ts`, `agent-c.ts`).
- Adding external UI frameworks or build tools.
- Changing the SSE protocol or any API contract.

## User Stories

> Source: issue body only — "refine the ui to be more polished"

- **US-1** As a developer demoing the sandbox patterns at a talk, I want the dashboard to look polished and professional so the audience focuses on the security insights, not the rough edges.
- **US-2** As a developer running the patterns locally, I want the OWASP results to be easy to scan so I can instantly see which pattern fails vs passes each test.
- **US-3** As a developer, I want the status of each pattern (idle / running / done / error) to be visually prominent so I can tell at a glance what's happening.
- **US-4** As a developer, I want the LEAKED vs BLOCKED events in the log to be eye-catching so I immediately understand the security story.

## Acceptance Criteria

1. **AC-1 Visual polish — header**: The header has clear visual separation, improved typography, and the canary banner is visually distinct with a polished pill/card style.
2. **AC-2 Visual polish — column cards**: Each pattern column has a polished card look — refined border-top accent colour, better padding, and clear visual hierarchy between title, subtitle, and file badge.
3. **AC-3 Visual polish — OWASP badges**: OWASP badges are readable and colour-coded (fail = red, partial = amber, pass = green, na = muted), with improved padding and spacing.
4. **AC-4 Visual polish — events log**: The events log has improved line spacing, cleaner timestamp display, and LEAKED/BLOCKED lines are visually striking and immediately distinguishable.
5. **AC-5 Visual polish — status badges**: The idle/running/done/error status badges have polished styling with consistent sizing and clear state communication.
6. **AC-6 Visual polish — buttons**: Run and Run All buttons have polished hover/focus/disabled states with smooth transitions.
7. **AC-7 Visual polish — architecture panel**: The collapsible architecture diagram panel has smoother transition and better heading styling.
8. **AC-8 Visual polish — report panel**: The report panel at the bottom of each column has improved typography and clear empty/has-data visual distinction.
9. **AC-9 Responsiveness — no horizontal overflow**: At 1440px desktop the layout renders without horizontal overflow.
10. **AC-10 No regressions**: All existing functionality (SSE, run buttons, OWASP badge updates, clear, run-all, arch toggle) continues to work correctly.

## Out of Scope

- Dark/light mode toggle
- Mobile layout (< 768 px)
- Animations beyond the existing `pulse` keyframe
- Markdown rendering in the report panel
- Any backend change

## Design Notes

No image attachments were provided in the issue. The existing dark theme (`#0d1117` background, GitHub-dark palette) should be retained and refined — not replaced.
