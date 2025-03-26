# This image requires the following environment variable at runtime:
# - GITLAB_PERSONAL_ACCESS_TOKEN: Your GitLab personal access token
FROM node:22.12-alpine AS builder

WORKDIR /app

COPY . .

RUN npm i -g corepack
RUN corepack enable
RUN pnpm install

FROM node:22.12-alpine AS release

WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/pnpm-lock.yaml ./pnpm-lock.yaml

RUN npm i -g corepack
RUN corepack enable
RUN pnpm install

ENTRYPOINT ["node", "build/index.js"]
