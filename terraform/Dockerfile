FROM alpine:3.18.3 as build

# ------ Target arch ------
ARG GENERIC_ARCH_NAME=amd64
ARG TMATE_ARCH=amd64

RUN apk add --no-cache jq wget unzip

RUN export TERRAFORM_VERSION=$(wget -qO- "https://api.github.com/repos/hashicorp/terraform/releases/latest" | jq -r .tag_name) && \
    export TMATE_VERSION=$(wget -qO- "https://api.github.com/repos/tmate-io/tmate/releases/latest" | jq -r .tag_name) && \
    export TERRAFORM_DOCS_VERSION=$(wget -qO- "https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest" | jq -r .tag_name) && \
    echo "Latest Terraform Version: $TERRAFORM_VERSION" && \
    echo "Latest tmate Version: $TMATE_VERSION" && \
    echo "Latest Terraform Docs Version: $TERRAFORM_DOCS_VERSION" && \
    # Download and extract binaries
    wget -qO terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${GENERIC_ARCH_NAME}.zip" && \
    wget -qO tmate.tar.xz "https://github.com/tmate-io/tmate/releases/download/${TMATE_VERSION}/tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}.tar.xz" && \
    wget -qO terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-${GENERIC_ARCH_NAME}.tar.gz" && \
    unzip terraform.zip && \
    tar -xf tmate.tar.xz && \
    tar -xf terraform-docs.tar.gz && \
    # Move binaries to a temporary location for copying
    mv terraform /usr/local/bin/ && \
    mv tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}/tmate /usr/local/bin/ && \
    mv terraform-docs /usr/local/bin/ && \
    # Cleanup unnecessary files
    rm -rf terraform* tmate* terraform-docs* /var/cache/apk/*

FROM alpine:3.18.3

RUN adduser -D terraform

COPY --from=build /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=build /usr/local/bin/tmate /usr/local/bin/tmate
COPY --from=build /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs

RUN apk add --no-cache jq

USER terraform