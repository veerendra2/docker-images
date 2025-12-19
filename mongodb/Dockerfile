FROM golang:alpine AS builder

WORKDIR /app
COPY mongo-init mongo-init

RUN apk add --no-cache curl jq \
    && cd mongo-init \
    && go mod tidy \
    && CGO_ENABLED=0 go build -ldflags="-s -w" -o /app/mongo-init . \
    # Build gosu from latest source
    && LATEST_GOSU=$(curl -s https://api.github.com/repos/tianon/gosu/releases/latest | jq -r .tag_name) \
    && curl -L -o gosu.tar.gz "https://github.com/tianon/gosu/archive/refs/tags/${LATEST_GOSU}.tar.gz" \
    && mkdir /gosu-src \
    && tar -xzf gosu.tar.gz -C /gosu-src --strip-components=1 \
    && cd /gosu-src \
    && CGO_ENABLED=0 go build -ldflags="-s -w" -o /app/gosu . \
    && chmod +x /app/gosu /app/mongo-init

FROM ubuntu:24.04

ARG MONGO_VERSION=8.2.0

RUN groupadd -r mongodb -g 999 \
   && useradd -r -g mongodb -u 999 -d /data/db mongodb \
   && mkdir -p /data/db \
   && chown -R mongodb:mongodb /data/db \
   && export DEBIAN_FRONTEND=noninteractive \
   && apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl gnupg \
   && curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc \
   | gpg --dearmor -o /usr/share/keyrings/mongodb.gpg \
   && echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg] \
      https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.2 multiverse" \
   > /etc/apt/sources.list.d/mongodb.list \
   && apt-get update && apt-get install -y --no-install-recommends \
      mongodb-org-server=${MONGO_VERSION} \
   && apt-get purge -y gnupg \
   && apt-get -y auto-remove \
   && rm -rf /var/lib/apt/lists/* \
   && rm -rf /var/lib/mongodb

COPY --from=builder /app/mongo-init /usr/local/bin/
COPY --from=builder /app/gosu /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

VOLUME /data/db
EXPOSE 27017
CMD ["mongod"]