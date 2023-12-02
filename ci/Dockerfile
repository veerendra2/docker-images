FROM alpine:3.18.3

# ------ packages target arch ------
ARG TERRAFORM_ARCH=amd64
ARG TMATE_ARCH=amd64

# ------ packages target os ------
ARG TERRAFORM_OS=linux

# ------ packages versions ------
ARG TERRAFORM_VERSION=1.5.7
ARG TMATE_VERSION=2.4.0

COPY requirements.txt requirements.txt
RUN apk add --update --no-cache && \
  python3 py3-pip jq git && \
  wget -O terraform.zip https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_$OS_$ARCH.zip && \
  wget -O tmate.tar.xz https://github.com/tmate-io/tmate/releases/download/$TMATE_VERSION/tmate-$TMATE_VERSION-static-linux-$TMATE_ARCH.tar.xz && \
  unzip terraform.zip && \
  tar -xf tmate.tar.xz && \
  mv terraform /usr/local/bin/ && \
  mv tmate-$TMATE_VERSION-static-linux-$TMATE_ARCH/tmate /usr/local/bin/ && \
  pip3 install --no-cache-dir -r requirements.txt && \
  rm -rf terraform* tmate* requirements.txt
