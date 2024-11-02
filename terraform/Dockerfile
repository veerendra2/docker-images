FROM ubuntu:24.04 AS build
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl gnupg software-properties-common jq && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform && \
    rm -rf /var/lib/apt/lists/*

FROM ubuntu:24.04

RUN useradd -ms /bin/bash terraform && \
    apt-get update && apt-get install -y --no-install-recommends \
    jq tmate && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/bin/terraform /usr/bin/terraform

USER terraform
WORKDIR /home/terraform
