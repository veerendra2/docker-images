FROM alpine:3.18.3
# ------ target arch ------
ARG GENERIC_ARCH_NAME=amd64
ARG TMATE_ARCH=amd64
# ------ packages versions ------
ARG TERRAFORM_VERSION=1.5.7
ARG TMATE_VERSION=2.4.0
ARG TERRAFORM_DOCS_VERSION=v0.17.0

RUN apk add --no-cache --virtual .build-deps jq \
  wget -qO terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${GENERIC_ARCH_NAME}.zip; \
  wget -qO tmate.tar.xz https://github.com/tmate-io/tmate/releases/download/${TMATE_VERSION}/tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}.tar.xz; \
  wget -qO terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-${GENERIC_ARCH_NAME}.tar.gz; \
  # install tools
  unzip terraform.zip; \
  tar -xf tmate.tar.xz; \
  tar -xf terraform-docs.tar.gz; \
  mv terraform* /usr/local/bin/; \
  mv tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}/tmate /usr/local/bin/; \
  # cleanup
  rm -rf terraform* tmate* terraform-docs*
