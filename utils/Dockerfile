FROM alpine:3.18.3

# ------ target arch ------
ARG ARCH=amd64
ARG TMATE_ARCH=amd64

# ------ packages versions ------
ARG TERRAFORM_VERSION=1.5.7
ARG TMATE_VERSION=2.4.0
ARG TERRAFORM_DOCS_VERSION=v0.17.0
ARG KUBECTL_VERSION=v1.29.2

COPY requirements.txt /requirements.txt
RUN apk add --update --no-cache \
  # install packages
  python3 py3-pip jq git openssh-client openssl \
  python3-dev libffi-dev build-base rclone \
  iproute2-ss bind-tools curl iperf3 nmap
  
  # download binary tools
  wget -qO terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip; \
  wget -qO tmate.tar.xz https://github.com/tmate-io/tmate/releases/download/${TMATE_VERSION}/tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}.tar.xz; \
  wget -qO terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-${ARCH}.tar.gz; \
  wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/{ARCH}/kubectl

  # install tools
  unzip terraform.zip; \
  tar -xf tmate.tar.xz; \
  tar -xf terraform-docs.tar.gz; \
  mv terraform /usr/local/bin/; \
  mv tmate-${TMATE_VERSION}-static-linux-${TMATE_ARCH}/tmate /usr/local/bin/; \

  # install python packages
  pip3 install --no-cache-dir -r requirements.txt; \

  # cleanup
  rm -rf terraform* tmate* /requirements.txt
