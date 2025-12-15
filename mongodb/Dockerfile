FROM ubuntu:24.04 AS build
ARG MONGO_VERSION=8.2.0
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y ca-certificates gnupg curl \
 && curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc \
    | gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg \
 && echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg] \
    https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.2 multiverse" \
    > /etc/apt/sources.list.d/mongodb-org.list \
 && apt-get update && apt-get install -y mongodb-org-server=${MONGO_VERSION} \
 && rm -rf /var/lib/apt/lists/*

FROM ubuntu:24.04
RUN apt-get update && apt-get install -y ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -r -u 100 -g 65534 -d /nonexistent -s /usr/sbin/nologin mongodb \
    && mkdir -p /data/db \
    && chown -R mongodb:65534 /data/db
COPY --from=build /usr/bin/mongod /usr/bin/mongod
EXPOSE 27017
USER mongodb
ENTRYPOINT ["/usr/bin/mongod"]
CMD ["--bind_ip_all"]
