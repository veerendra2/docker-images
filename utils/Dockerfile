FROM alpine:3.18.3 as build
RUN apk add --update --no-cache --virtual .build-deps \
    gcc build-base musl-dev libffi-dev python3 python3-dev \
    py-pip
COPY requirements.txt .
RUN pip install --user -r requirements.txt --no-cache-dir

FROM alpine:3.18.3

# ------ target arch ------
ARG GENERIC_ARCH_NAME=amd64

# ------ packages versions ------
ARG TERRAFORM_VERSION=1.5.7
ARG KUBECTL_VERSION=v1.29.2

RUN apk add --no-cache --virtual .build-deps \
  # install packages
  python3 jq git openssh-client openssl \
  iproute2-ss bind-tools curl iperf3 nmap; \
  # download binary tools
  wget -qO terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${GENERIC_ARCH_NAME}.zip; \
  wget -qO /usr/local/bin/kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${GENERIC_ARCH_NAME}/kubectl; \
  # install tools
  unzip terraform.zip; \
  mv terraform /usr/local/bin/; \
  chmod +x /usr/local/bin/*; \
  # cleanup
  rm -rf terraform*

COPY --from=build /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
