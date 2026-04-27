# ZeroClaw

> See [ZeroClaw](https://github.com/zeroclaw-labs/zeroclaw) for upstream documentation

A custom ZeroClaw Docker image built with full features enabled, including all messaging channels, WhatsApp Web support, and CLI tools for agent shell operations.

- Base: `debian:bookworm-slim`
- Tags: `latest` only
- Architectures: `amd64`, `arm64`

## Features

Built with the following Cargo feature flags:

| Feature | Description |
| --- | --- |
| `agent-runtime` | Full agent loop, tools, and all standard channels |
| `gateway` | Web dashboard UI and REST/WebSocket API |
| `whatsapp-web` | WhatsApp via browser protocol (QR code pairing) |
| `channel-nostr` | Nostr decentralized messaging |
| `voice-wake` | Voice wake word detection |
| `rag-pdf` | PDF document RAG tool |
| `channel-feishu` | Feishu/Lark messaging |
| `observability-prometheus` | Prometheus metrics endpoint |
| `schema-export` | Config schema export |
| `tui-onboarding` | Terminal UI onboarding |

## Channels

All channels included via `agent-runtime` + extras:

| Channel | Feature Flag |
| --- | --- |
| Email | `channel-email` |
| Telegram | `channel-telegram` |
| Slack | `channel-slack` |
| Discord | `channel-discord` |
| WhatsApp Cloud API | `channel-whatsapp-cloud` |
| WhatsApp Web (QR) | `whatsapp-web` |
| Signal | `channel-signal` |
| Nostr | `channel-nostr` |
| IRC | `channel-irc` |
| iMessage | `channel-imessage` |
| Bluesky | `channel-bluesky` |
| Twitter/X | `channel-twitter` |
| Reddit | `channel-reddit` |
| Notion | `channel-notion` |
| Mattermost | `channel-mattermost` |
| DingTalk | `channel-dingtalk` |
| QQ | `channel-qq` |
| WeCom | `channel-wecom` |
| Lark/Feishu | `channel-feishu` |
| LINE (LINQ) | `channel-linq` |
| WATI | `channel-wati` |
| Nextcloud | `channel-nextcloud` |
| Webhook | `channel-webhook` |
| Voice Call | `channel-voice-call` |

## CLI Tools

Available in the container for agent shell operations:

- `bash`
- `curl`
- `git`
- `cron`

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
    restart: unless-stopped
    environment:
      NVIDIA_API_KEY: ${NVIDIA_API_KEY}
      ZEROCLAW_ALLOW_PUBLIC_BIND: true
      ZEROCLAW_GATEWAY_HOST: "0.0.0.0"
    ports:
      - 42617:42617
    volumes:
      - zeroclaw_data:/zeroclaw-data
    command:
      - daemon

volumes:
  zeroclaw_data:
```

### Build Args

| Arg | Default | Description |
| --- | --- | --- |
| `ZEROCLAW_VERSION` | `master` | Git branch or tag to build from |
| `ZEROCLAW_CARGO_FEATURES` | *(see Dockerfile)* | Comma-separated Cargo features |
