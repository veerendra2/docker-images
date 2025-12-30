# Mongo-Init

A tiny Go binary (~8MB) to create the initial root user in MongoDB, replacing the official `mongosh` binary (~150MB) to reduce Docker image size.

## Build

- See [`Dockerfile`](../Dockerfile)

```bash
go build -ldflags="-s -w" -trimpath -o mongo-init ./...
```

## Usage

- See [`docker-entrypoint.sh`](../docker-entrypoint.sh)

```bash
./mongo-init -h
Usage of ./mongo-init:
  -pass string
        User pass (default "changeme!")
  -ping
        Ping server
  -uri string
        Mongo URI (default "mongodb://127.0.0.1:27017")
  -user string
        Admin user (default "admin")
```
