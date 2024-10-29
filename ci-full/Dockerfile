FROM alpine:3.18.3 as python-build
RUN apk add --update --no-cache gcc build-base musl-dev libffi-dev python3 python3-dev py-pip
COPY requirements.txt .
RUN pip3 install --user -r requirements.txt --no-cache-dir --break-system-packages --no-warn-script-location

FROM alpine:3.18.3

# ------ Target arch ------
ARG GENERIC_ARCH_NAME=amd64
ARG TMATE_ARCH=amd64

RUN apk add --no-cache python3 jq git openssh-client openssl wget unzip

RUN export TERRAFORM_VERSION=$(wget -qO- "https://api.github.com/repos/hashicorp/terraform/releases/latest" | jq -r .tag_name) && \
    export TMATE_VERSION=$(wget -qO- "https://api.github.com/repos/tmate-io/tmate/releases/latest" | jq -r .tag_name) && \
    export TERRAFORM_DOCS_VERSION=$(wget -qO- "https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest" | jq -r .tag_name) && \
    export KUBECTL_VERSION=$(wget -qO- "https://dl.k8s.io/release/stable.txt") && \
    echo "Latest Terraform Version: $TERRAFORM_VERSION" && \
    echo "Latest tmate Version: $TMATE_VERSION" && \
    echo "Latest Terraform Docs Version: $TERRAFORM_DOCS_VERSION" && \
    echo "Latest Kubectl Version: $KUBECTL_VERSION" && \
    # Download and install binaries
    wget -qO terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${GENERIC_ARCH_NAME}.zip" && \
    wget -qO tmate.tar.xz "https://github.com/tmate-io/tmate/releases/download/${TMATE_VERSION}/tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}.tar.xz" && \
    wget -qO terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux_${GENERIC_ARCH_NAME}.tar.gz" && \
    wget -qO /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${GENERIC_ARCH_NAME}/kubectl" && \
    # Install the downloaded binaries
    unzip terraform.zip -d /usr/local/bin && \
    tar -xf tmate.tar.xz -C /usr/local/bin --strip-components=1 && \
    tar -xf terraform-docs.tar.gz -C /usr/local/bin && \
    # Cleanup unnecessary files
    rm -rf terraform* tmate* terraform-docs* /var/cache/apk/*

RUN adduser -D ci

COPY --from=python-build /root/.local /home/ci/.local
RUN chown -R ci:ci /home/ci/.local

ENV PATH=/home/ci/.local/bin:$PATH

USER ci
