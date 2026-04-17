# AI Sandbox Patterns

Three sandboxing patterns for the **Claude Agent SDK**, demonstrated with
the same agent code, the same prompt, and a live dashboard that shows
which secrets leak and which are contained — mapped to the
[OWASP LLM Top 10 (2025)](https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/).

## The three patterns

| | A | B | C |
|---|---|---|---|
| **Agent code** | `agent-a.ts` | `agent-b.ts` | `agent-c.ts` |
| **Where agent runs** | Same container | Same container | Firecracker microVM |
| **Tool isolation** | None | SDK sandbox + E2B microVM | VM boundary |
| **Host secrets exposed?** | **YES** | **YES** | **NO** |
| **Code diff vs A** | — | +15 lines | +5 comment lines |
| **Pick when** | Dev tool, trusted host | SaaS, don't operate sandbox infra | Multi-tenant, adversarial code |

## Quick start (macOS)

### Prerequisites

- **Node.js 18+** — `brew install node`
- **Docker** — [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)
- **Anthropic API key** — [console.anthropic.com](https://console.anthropic.com)
- **E2B API key** (Pattern B) — [e2b.dev/dashboard](https://e2b.dev/dashboard) (free tier)
- **Docker Sandboxes** (Pattern C, Apple Silicon only) — `brew install docker/tap/sbx`

### Setup

```bash
git clone https://github.com/IntraEdge-Technologies/ai-sandbox-patterns.git
cd ai-sandbox-patterns
npm install

# Configure API keys
cp .env.example .env
# Edit .env — add your ANTHROPIC_API_KEY and E2B_API_KEY
```

### Pattern C setup (microVM — Apple Silicon only)

```bash
sbx login                        # authenticate with Docker
bash scripts/setup-sbx.sh        # creates sandbox + network allowlist
```

### Run the dashboard

```bash
npm run dashboard                 # http://localhost:5173
```

Click **Run All Three** and watch the canary secret leak in Pattern A
(red) and get blocked in Pattern C (green).

### Run patterns individually

```bash
npm run a                         # Pattern A — no sandbox
npm run b                         # Pattern B — SDK sandbox + E2B
npm run c                         # Pattern C — inside sbx microVM
```

## How it works

A single **Fastify server** exposes three endpoints. Each runs a different
version of the agent against the same OWASP security test prompt.

A **canary secret** (`SECRET_DATABASE_PASSWORD=prod-db-hunter2`) is set in
the server's env. The demo shows whether each pattern leaks it.

```
POST /api/patterns/a/run → spawns agent-a.ts (inherits SECRET → LEAKED)
POST /api/patterns/b/run → spawns agent-b.ts (inherits SECRET, tools restricted)
POST /api/patterns/c/run → sbx exec agent-c.ts (SECRET never enters VM → BLOCKED)
```

## Repo layout

```
agent/
  agent-a.ts              Pattern A: no sandbox, raw query()
  agent-b.ts              Pattern B: +SDK sandbox +E2B MCP (+15 lines vs A)
  agent-c.ts              Pattern C: identical to A (security is the runtime)
  e2b-sandboxed-bash.ts   E2B MCP tool used by Pattern B
  prompt.md               OWASP LLM Top 10 security test prompt

dashboard/
  server.ts               Fastify server (3 endpoints + SSE + canary secret)
  index.html              3-column live UI with Mermaid diagrams + OWASP matrix

Dockerfile                Containerize the server
docker-compose.yaml       One-command start
scripts/setup-sbx.sh      Create the sbx sandbox for Pattern C
```

## The OWASP test prompt

The agent runs 10 concrete security tests mapped to the OWASP LLM Top 10:

1. **LLM01** Prompt Injection — simulated injected input
2. **LLM02** Sensitive Info Disclosure — env vars + canary credentials file
3. **LLM03** Supply Chain — package manager access
4. **LLM04** Data Poisoning — write to canary file + /etc/hosts
5. **LLM05** Output Handling — XSS + shell expansion strings
6. **LLM06** Excessive Agency — host network + external internet + filesystem
7. **LLM07** System Prompt Leakage — confidential marker in system prompt
8. **LLM08** Vector/Embedding — n/a (no vector store)
9. **LLM09** Misinformation — n/a (model-layer)
10. **LLM10** Unbounded Consumption — resource limits + ulimit

Results are returned as structured JSON via the SDK's `outputFormat`
option and dynamically update the dashboard's OWASP badges.

## Key insight

`agent-a.ts` and `agent-c.ts` are nearly identical — same tools, same
permissions, same prompt. The **only** difference is where the process runs.
Pattern A leaks your secrets. Pattern C doesn't.

The diff isn't in the code. It's in the boundary.

## Credits

- [Claude Agent SDK](https://code.claude.com/docs/en/agent-sdk/overview)
- [E2B](https://e2b.dev/) (Pattern B)
- [Docker Sandboxes / sbx](https://docs.docker.com/ai/sandboxes/) (Pattern C)
- [OWASP LLM Top 10 (2025)](https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/)

## License

MIT
