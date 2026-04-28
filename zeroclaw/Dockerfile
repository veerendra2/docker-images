# syntax=docker/dockerfile:1.7

ARG ZEROCLAW_VERSION=master
ARG ZEROCLAW_CARGO_FEATURES="agent-runtime,gateway,whatsapp-web,channel-nostr,voice-wake,rag-pdf,channel-feishu,observability-prometheus,schema-export,tui-onboarding"

# -- Stage 0: Clone upstream repo ----------------------------------------
FROM alpine/git:latest AS source
ARG ZEROCLAW_VERSION
RUN git clone --depth 1 --branch ${ZEROCLAW_VERSION} \
    https://github.com/zeroclaw-labs/zeroclaw.git /zeroclaw

# -- Stage 1: Frontend build ---------------------------------------------
FROM node:22-alpine AS web-builder
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
    apt-get update && apt-get install -y \
        pkg-config \
        libasound2-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=source /zeroclaw/Cargo.toml /zeroclaw/Cargo.lock ./
COPY --from=source /zeroclaw/crates/ crates/
COPY --from=source /zeroclaw/apps/tauri/Cargo.toml apps/tauri/Cargo.toml
COPY --from=source /zeroclaw/tools/ tools/
COPY --from=source /zeroclaw/xtask/ xtask/
COPY --from=source /zeroclaw/crates/aardvark-sys/build.rs crates/aardvark-sys/build.rs

RUN mkdir -p src benches apps/tauri/src \
    && echo "fn main() {}" > src/main.rs \
    && echo "" > src/lib.rs \
    && echo "fn main() {}" > benches/agent_benchmarks.rs \
    && echo "fn main() {}" > apps/tauri/src/main.rs \
    && for d in crates/*/; do mkdir -p "${d}src" && printf '' > "${d}src/lib.rs"; done \
    && for d in tools/*/; do mkdir -p "${d}src" && echo "fn main() {}" > "${d}src/main.rs"; done \
    && mkdir -p xtask/src && echo "fn main() {}" > xtask/src/main.rs

RUN --mount=type=cache,id=zeroclaw-cargo-registry,target=/usr/local/cargo/registry,sharing=locked \
    --mount=type=cache,id=zeroclaw-cargo-git,target=/usr/local/cargo/git,sharing=locked \
    --mount=type=cache,id=zeroclaw-target,target=/app/target,sharing=locked \
    if [ -n "$ZEROCLAW_CARGO_FEATURES" ]; then \
      cargo build --release --locked --features "$ZEROCLAW_CARGO_FEATURES"; \
    else \
      cargo build --release --locked; \
    fi

RUN rm -rf src benches
COPY --from=source /zeroclaw/src/ src/
COPY --from=source /zeroclaw/benches/ benches/
COPY --from=source /zeroclaw/crates/ crates/
COPY --from=source /zeroclaw/tools/ tools/
COPY --from=source /zeroclaw/xtask/ xtask/
COPY --from=web-builder /web/dist web/dist
RUN touch src/main.rs src/lib.rs

RUN --mount=type=cache,id=zeroclaw-cargo-registry,target=/usr/local/cargo/registry,sharing=locked \
    --mount=type=cache,id=zeroclaw-cargo-git,target=/usr/local/cargo/git,sharing=locked \
    --mount=type=cache,id=zeroclaw-target,target=/app/target,sharing=locked \
    if [ -n "$ZEROCLAW_CARGO_FEATURES" ]; then \
      cargo build --release --locked --features "$ZEROCLAW_CARGO_FEATURES"; \
    else \
      cargo build --release --locked; \
    fi && \
    cp target/release/zeroclaw /app/zeroclaw && \
    strip /app/zeroclaw

RUN size=$(stat -c%s /app/zeroclaw) && \
    if [ "$size" -lt 1000000 ]; then echo "ERROR: binary too small (${size} bytes)" && exit 1; fi

RUN mkdir -p /zeroclaw-data/.zeroclaw /zeroclaw-data/workspace /zeroclaw-data/web && \
    cp -r web/dist /zeroclaw-data/web/dist && \
    chown -R 65534:65534 /zeroclaw-data

# -- Stage 3: Runtime (Debian with shell) ---------------------------------
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        cron \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/zeroclaw /usr/local/bin/zeroclaw
COPY --from=builder /zeroclaw-data /zeroclaw-data

ENV LANG=C.UTF-8
ENV ZEROCLAW_WORKSPACE=/zeroclaw-data/workspace
ENV HOME=/zeroclaw-data
ENV ZEROCLAW_GATEWAY_PORT=42617

WORKDIR /zeroclaw-data
USER 65534:65534
EXPOSE 42617

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=10s \
    CMD ["zeroclaw", "status", "--format=exit-code"]

ENTRYPOINT ["zeroclaw"]
CMD ["daemon"]
