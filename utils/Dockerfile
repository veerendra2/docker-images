FROM ubuntu:22.04 as build
RUN apt-get update; \
    apt-get install -y --no-install-recommends gcc \
    python3 python3-dev python3-pip; \
    rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip3 install --user -r requirements.txt \
    --no-cache-dir \
    --no-warn-script-location

FROM ubuntu:22.04

# ------ target arch ------
ARG GENERIC_ARCH_NAME=amd64
ARG TMATE_ARCH=amd64

# ------ packages versions ------
ARG TERRAFORM_VERSION=1.5.7
ARG TMATE_VERSION=2.4.0
ARG TERRAFORM_DOCS_VERSION=v0.17.0
ARG KUBECTL_VERSION=v1.29.2

RUN apt-get update; \
  # install packages
  apt-get install -y --no-install-recommends \
  python3 jq git curl nmap openssh-client openssl \
  iproute2 dnsutils curl iperf3 rclone vim; \
  # download binary tools
  wget -qO terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${GENERIC_ARCH_NAME}.zip; \
  wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${GENERIC_ARCH_NAME}/kubectl; \
  # install tools
  unzip terraform.zip; \
  chmod +x /usr/local/bin/kubectl \
  mv terraform /usr/local/bin/; \
  # cleanup
  rm -rf terraform*; \
  rm -rf /var/lib/apt/lists/*

COPY --from=build /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
