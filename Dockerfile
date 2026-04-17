FROM node:22-slim
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install --no-audit --no-fund
COPY tsconfig.json ./
COPY agent ./agent
COPY dashboard ./dashboard
COPY workspace ./workspace

# The canary secret is set in server.ts, not here.
# ANTHROPIC_API_KEY and E2B_API_KEY must be passed at runtime.

EXPOSE 5173
CMD ["npx", "tsx", "dashboard/server.ts"]
