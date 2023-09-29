FROM alpine:3.18.3
ARG ARCH=amd64
RUN apk update && \
  apk add python3 py3-pip jq git && \
  wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_$ARCH.zip && \
  wget https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-$ARCH.tar.xz && \
  unzip terraform_1.5.7_linux_$ARCH.zip && \
  tar -xf tmate-2.4.0-static-linux-$ARCH.tar.xz && \
  mv terraform /usr/local/bin/ && \
  mv tmate-2.4.0-static-linux-$ARCH/tmate /usr/local/bin/ && \
  pip3 install GitPython yamllint pylint jinja2 && \
  rm -rf terraform* tmate*
