FROM ubuntu:24.04

ARG MONGO_VERSION=8.2.0

RUN groupadd -r mongodb -g 999 \
 && useradd -r -g mongodb -u 999 -d /data/db mongodb \
 && mkdir -p /data/db \
 && chown -R mongodb:mongodb /data/db

RUN export DEBIAN_FRONTEND=noninteractive \
   && apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl \
      gnupg gosu \
   && curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc \
   | gpg --dearmor -o /usr/share/keyrings/mongodb.gpg \
   && echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb.gpg] \
      https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.2 multiverse" \
   > /etc/apt/sources.list.d/mongodb.list \
   && apt-get update && apt-get install -y --no-install-recommends \
      mongodb-org-server=${MONGO_VERSION} \
      mongodb-mongosh \
   && apt-get purge -y gnupg \
   && apt-get -y auto-remove \
   && rm -rf /var/lib/apt/lists/* \
   && rm -rf /var/lib/mongodb

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

VOLUME /data/db
EXPOSE 27017
CMD ["mongod"]