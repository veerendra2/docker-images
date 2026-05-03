# ZeroClaw

> See [ZeroClaw](https://github.com/zeroclaw-labs/zeroclaw) for upstream documentation

A custom ZeroClaw Docker image built with full features enabled, including all messaging channels, WhatsApp Web support, and CLI tools for agent shell operations.

- Base: `debian:bookworm-slim`
- Tags: `latest` only
- Architectures: `amd64`, `arm64`

## Features

<details>
<summary>Cargo feature flags (click to expand)</summary>

| Feature                    | Enabled | Description                                       |
| -------------------------- | ------- | ------------------------------------------------- |
| `agent-runtime`            | ✅      | Full agent loop, tools, and all standard channels |
| `gateway`                  | ✅      | Web dashboard UI and REST/WebSocket API           |
| `whatsapp-web`             | ✅      | WhatsApp via browser protocol (QR code pairing)   |
| `channel-nostr`            | ✅      | Nostr decentralized messaging                     |
| `voice-wake`               | ✅      | Voice wake word detection                         |
| `rag-pdf`                  | ✅      | PDF document RAG tool                             |
| `channel-feishu`           | ✅      | Feishu/Lark messaging                             |
| `observability-prometheus` | ✅      | Prometheus metrics endpoint                       |
| `schema-export`            | ✅      | Config schema export                              |
| `tui-onboarding`           | ✅      | Terminal UI onboarding                            |

</details>

## Channels

<details>
<summary>All channels included via agent-runtime + extras (click to expand)</summary>

| Channel            | Feature Flag             | Enabled |
| ------------------ | ------------------------ | ------- |
| Email              | `channel-email`          | ✅      |
| Telegram           | `channel-telegram`       | ✅      |
| Slack              | `channel-slack`          | ✅      |
| Discord            | `channel-discord`        | ✅      |
| WhatsApp Cloud API | `channel-whatsapp-cloud` | ✅      |
| WhatsApp Web (QR)  | `whatsapp-web`           | ✅      |
| Signal             | `channel-signal`         | ✅      |
| Nostr              | `channel-nostr`          | ✅      |
| IRC                | `channel-irc`            | ✅      |
| iMessage           | `channel-imessage`       | ✅      |
| Bluesky            | `channel-bluesky`        | ✅      |
| Twitter/X          | `channel-twitter`        | ✅      |
| Reddit             | `channel-reddit`         | ✅      |
| Notion             | `channel-notion`         | ✅      |
| Mattermost         | `channel-mattermost`     | ✅      |
| DingTalk           | `channel-dingtalk`       | ✅      |
| QQ                 | `channel-qq`             | ✅      |
| WeCom              | `channel-wecom`          | ✅      |
| Lark/Feishu        | `channel-feishu`         | ✅      |
| LINE (LINQ)        | `channel-linq`           | ✅      |
| WATI               | `channel-wati`           | ✅      |
| Nextcloud          | `channel-nextcloud`      | ✅      |
| Webhook            | `channel-webhook`        | ✅      |
| Voice Call         | `channel-voice-call`     | ✅      |

</details>

## CLI Tools

<details>
<summary>Available tools for agent shell operations (click to expand)</summary>

| Tool             | Enabled | Description             |
| ---------------- | ------- | ----------------------- |
| `bash`           | ✅      | Shell                   |
| `curl`           | ✅      | HTTP client             |
| `git`            | ✅      | Version control         |
| `python3`        | ✅      | Python 3.11 interpreter |
| `jq`             | ✅      | JSON processor          |
| `vim`            | ✅      | Text editor             |
| `wget`           | ✅      | File downloader         |
| `zip` / `unzip`  | ✅      | Archive utilities       |
| `openssh-client` | ✅      | SSH client              |
| `rsync`          | ✅      | File sync               |
| `tree`           | ✅      | Directory visualization |
| `less`           | ✅      | Pager                   |
| `procps`         | ✅      | `ps`, `top`, `free`     |
| `net-tools`      | ✅      | `ifconfig`, `netstat`   |
| `iputils-ping`   | ✅      | `ping`                  |
| `file`           | ✅      | File type detection     |

</details>

## User

The container runs as a non-root user `zeroclaw` (created via `useradd`) with home directory `/zeroclaw-data`.

## Environment Variables

- `NVIDIA_API_KEY` - NVIDIA NIM API key (for `nvidia` provider)
- `OPENROUTER_API_KEY` - OpenRouter API key
- `ZEROCLAW_API_KEY` - Generic API key fallback
- `ZEROCLAW_GATEWAY_PORT` - Gateway port (default: `42617`)

## Usage

### Docker Compose Example

```yaml
services:
  zeroclaw:
    image: veerendra2/zeroclaw
    container_name: zeroclaw
    restart: unless-stopped
    cap_drop:
      - ALL
    cap_add:
      - NET_RAW
    environment:
      NVIDIA_API_KEY: ${NVIDIA_API_KEY}
      ZEROCLAW_ALLOW_PUBLIC_BIND: "true"
      ZEROCLAW_GATEWAY_HOST: "0.0.0.0"
      ZEROCLAW_GATEWAY_PORT: "42617"
    ports:
      - "42617:42617"
    volumes:
      - /data/volumes/zeroclaw:/zeroclaw-data
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
    command:
      - daemon
      - --host
      - "0.0.0.0"
```

### Build Args

| Arg                       | Default            | Description                    |
| ------------------------- | ------------------ | ------------------------------ |
| `ZEROCLAW_VERSION`        | `v0.7.4`           | Git tag to build from          |
| `ZEROCLAW_CARGO_FEATURES` | _(see Dockerfile)_ | Comma-separated Cargo features |
| `GOSU_VERSION`            | `1.19`             | gosu version for entrypoint    |
