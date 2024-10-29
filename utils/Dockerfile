FROM ubuntu:22.04 as build
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3 python3-dev python3-pip && \
    rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip3 install --user -r requirements.txt --no-cache-dir --no-warn-script-location

FROM ubuntu:22.04

# ------ Target arch ------
ARG GENERIC_ARCH_NAME=amd64
ARG TMATE_ARCH=amd64

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 jq git curl nmap openssh-client openssl \
    iproute2 dnsutils iperf3 rclone vim && \
    # Fetch the latest versions using GitHub API
    export TERRAFORM_VERSION=$(wget -qO- "https://api.github.com/repos/hashicorp/terraform/releases/latest" | jq -r .tag_name) && \
    export TMATE_VERSION=$(wget -qO- "https://api.github.com/repos/tmate-io/tmate/releases/latest" | jq -r .tag_name) && \
    export TERRAFORM_DOCS_VERSION=$(wget -qO- "https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest" | jq -r .tag_name) && \
    export KUBECTL_VERSION=$(wget -qO- "https://dl.k8s.io/release/stable.txt") && \
    echo "Latest Terraform Version: $TERRAFORM_VERSION" && \
    echo "Latest tmate Version: $TMATE_VERSION" && \
    echo "Latest Terraform Docs Version: $TERRAFORM_DOCS_VERSION" && \
    echo "Latest Kubectl Version: $KUBECTL_VERSION" && \
    # Download binary tools
    wget -qO terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${GENERIC_ARCH_NAME}.zip" && \
    wget -qO /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${GENERIC_ARCH_NAME}/kubectl" && \
    # Install tools
    unzip terraform.zip && \
    mv terraform /usr/local/bin/ && \
    chmod +x /usr/local/bin/kubectl && \
    # Cleanup
    rm -rf terraform* /var/lib/apt/lists/*

COPY --from=build /root/.local /root/.local

ENV PATH=/root/.local/bin:$PATH

CMD ["/bin/bash"]