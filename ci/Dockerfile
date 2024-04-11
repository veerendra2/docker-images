FROM alpine:3.18.3 as build
RUN apk add --update --no-cache --virtual .build-deps \
    gcc build-base musl-dev libffi-dev python3 python3-dev \
    py-pip
COPY requirements.txt .
RUN pip install --user -r requirements.txt --no-cache-dir

FROM alpine:3.18.3

# ------ target arch ------
ARG GENERIC_ARCH_NAME=amd64
ARG TMATE_ARCH=amd64

# ------ packages versions ------
ARG TERRAFORM_VERSION=1.5.7
ARG TMATE_VERSION=2.4.0
ARG TERRAFORM_DOCS_VERSION=v0.17.0
ARG KUBECTL_VERSION=v1.29.2

RUN apk add --no-cache --virtual .build-deps \
  # install packages
  python3 jq git curl; \
  # download binary tools
  wget -qO terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${GENERIC_ARCH_NAME}.zip; \
  wget -qO tmate.tar.xz https://github.com/tmate-io/tmate/releases/download/${TMATE_VERSION}/tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}.tar.xz; \
  wget -qO terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-${GENERIC_ARCH_NAME}.tar.gz; \
  wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/{GENERIC_ARCH_NAME}/kubectl; \
  # install tools
  unzip terraform.zip; \
  tar -xf tmate.tar.xz; \
  tar -xf terraform-docs.tar.gz; \
  mv terraform /usr/local/bin/; \
  mv tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}/tmate /usr/local/bin/; \
  # cleanup
  rm -rf terraform* tmate* terraform-docs*

COPY --from=build /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
