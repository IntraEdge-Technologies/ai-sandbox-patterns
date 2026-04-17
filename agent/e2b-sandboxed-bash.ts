/**
 * Pattern B's isolation primitive: a custom MCP server that exposes a single
 * `e2b_bash` tool, dispatching every command into a remote E2B sandbox
 * (Firecracker microVM, hardware-isolated kernel).
 *
 * The agent runs on the host and holds the user's secrets. The tool side
 * is microVM-grade — different threat from Pattern A's local Docker, even
 * though both share the "agent on host" property.
 *
 * Sandbox lifecycle: one VM per process, reused across calls. Killed at exit.
 */
import { createSdkMcpServer, tool } from "@anthropic-ai/claude-agent-sdk";
import { Sandbox } from "e2b";
import { z } from "zod";

const MAX_OUT = 8 * 1024;

let sandboxPromise: Promise<Sandbox> | null = null;
async function getSandbox(): Promise<Sandbox> {
  if (!sandboxPromise) sandboxPromise = Sandbox.create();
  return sandboxPromise;
}

process.on("exit", () => {
  // Best-effort: don't await; process is exiting.
  sandboxPromise?.then((s) => s.kill()).catch(() => {});
});

const e2bBashTool = tool(
  "e2b_bash",
  "Run a shell command inside a remote E2B microVM sandbox (Firecracker).",
  { command: z.string().describe("Shell command to run inside the sandbox") },
  async ({ command }) => {
    const sbx = await getSandbox();
    const r = await sbx.commands.run(command, { timeoutMs: 30_000 });
    const text = `$ ${command}\n${r.stdout}${r.stderr}`.slice(0, MAX_OUT);
    return { content: [{ type: "text", text }] };
  },
);

export const e2bSandboxedBashServer = createSdkMcpServer({
  name: "e2b-sandboxed",
  version: "0.1.0",
  tools: [e2bBashTool],
});
