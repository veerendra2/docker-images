# Komodo Periphery Docker Image

## Why this custom image?

> https://komo.do/docs/setup/connect-servers

This image extends the official `ghcr.io/mbecker20/periphery:latest` to run with a specific user ID (9999) instead of the default user. This provides:

- Consistent file permissions between host and container
- Better security isolation
- Predictable user mapping for Docker socket access

## Host Requirements

**Important**: Before running this container, you must create a matching user on the host system:

```bash
# Create user with same UID/GID as container
sudo groupadd -g 9999 periphery
sudo useradd -u 9999 -g periphery -m -s /bin/bash periphery

# Add user to docker group for Docker socket access
sudo usermod -aG docker periphery
```
