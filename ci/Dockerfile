FROM alpine:3.18.3

# ------ arch and os -------
ARG ARCH=amd64
ARG OS=linux
ARG TMATE_ARCH=amd64

# ------ versions -------
ARG ANSIBLE_VERSION=9.0.1
ARG TERRAFORM_VERSION=1.5.7

RUN apk add --update --no-cache && \
  python3 py3-pip jq git && \
  wget -O terraform.zip https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_$OS_$ARCH.zip && \
  wget -O tmate.tar.xz https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-$OS-$TMATE_ARCH.tar.xz && \
  unzip terraform.zip && \
  tar -xf tmate.tar.xz && \
  mv terraform /usr/local/bin/ && \
  mv tmate-2.4.0-static-$OS-$TMATE_ARCH/tmate /usr/local/bin/ && \
  pip3 install GitPython yamllint pylint jinja2 ansible && \
  rm -rf terraform* tmate*
