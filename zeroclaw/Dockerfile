# syntax=docker/dockerfile:1.7

ARG ZEROCLAW_VERSION=v0.7.3
ARG ZEROCLAW_CARGO_FEATURES="agent-runtime,gateway,whatsapp-web,channel-nostr,voice-wake,rag-pdf,channel-feishu,observability-prometheus,schema-export,tui-onboarding"

# -- Stage 0: Clone source ------------------------------------------------
FROM alpine/git:latest AS source
ARG ZEROCLAW_VERSION
RUN git clone --depth 1 --branch ${ZEROCLAW_VERSION} \
    https://github.com/zeroclaw-labs/zeroclaw.git /zeroclaw

# -- Stage 1: Web frontend ------------------------------------------------
FROM node:22-alpine AS web
WORKDIR /web
COPY --from=source /zeroclaw/web/package.json /zeroclaw/web/package-lock.json* ./
RUN npm ci --ignore-scripts 2>/dev/null || npm install --ignore-scripts
COPY --from=source /zeroclaw/web/ .
RUN npm run build

# -- Stage 2: Rust build --------------------------------------------------
FROM rust:1.94-bookworm AS builder
WORKDIR /app
ARG ZEROCLAW_CARGO_FEATURES

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends pkg-config libasound2-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=source /zeroclaw/Cargo.toml /zeroclaw/Cargo.lock ./
COPY --from=source /zeroclaw/src/ src/
COPY --from=source /zeroclaw/benches/ benches/
COPY --from=source /zeroclaw/crates/ crates/
COPY --from=source /zeroclaw/apps/ apps/
COPY --from=web /web/dist web/dist

RUN --mount=type=cache,id=zeroclaw-cargo-registry,target=/usr/local/cargo/registry,sharing=locked \
    --mount=type=cache,id=zeroclaw-cargo-git,target=/usr/local/cargo/git,sharing=locked \
    --mount=type=cache,id=zeroclaw-target,target=/app/target,sharing=locked \
    cargo build --release --locked --features "$ZEROCLAW_CARGO_FEATURES" \
    && cp target/release/zeroclaw /app/zeroclaw \
    && strip /app/zeroclaw

RUN mkdir -p /zeroclaw-data/.zeroclaw /zeroclaw-data/workspace \
    && mkdir -p /usr/share/zeroclaw/web \
    && cp -r web/dist /usr/share/zeroclaw/web/dist

# -- Stage 3: Runtime -----------------------------------------------------
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash ca-certificates curl git libasound2 \
        python3 \
        zip unzip openssh-client rsync vim \
        jq wget tree less procps net-tools iputils-ping file \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -d /zeroclaw-data -s /bin/bash zeroclaw

COPY --from=builder /app/zeroclaw /usr/local/bin/zeroclaw
COPY --from=builder /zeroclaw-data /zeroclaw-data
COPY --from=builder /usr/share/zeroclaw /usr/share/zeroclaw

RUN chown -R zeroclaw:zeroclaw /zeroclaw-data /usr/share/zeroclaw \
    && find / -perm /6000 -type f -exec chmod a-s {} \; 2>/dev/null || true

ENV LANG=C.UTF-8
ENV ZEROCLAW_WORKSPACE=/zeroclaw-data/workspace
ENV ZEROCLAW_WEB_DIST_DIR=/usr/share/zeroclaw/web/dist
ENV HOME=/zeroclaw-data
ENV ZEROCLAW_GATEWAY_PORT=42617

LABEL org.opencontainers.image.title="zeroclaw" \
      security.drop-capabilities="ALL"

WORKDIR /zeroclaw-data
USER zeroclaw
EXPOSE 42617

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=10s \
    CMD ["zeroclaw", "status", "--format=exit-code"]

ENTRYPOINT ["zeroclaw"]
CMD ["daemon"]
