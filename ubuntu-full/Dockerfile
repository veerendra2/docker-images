FROM ubuntu:22.04
RUN apt-get update && \
  apt-get -y install wget sudo
RUN useradd \
    --user-group \
    --create-home \
    --no-log-init \
    --disabled-password \
    --shell /bin/bash \
    ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/custom
USER ubuntu
WORKDIR /home/ubuntu
RUN wget https://raw.githubusercontent.com/veerendra2/prepare-my-machine/master/bootstrap.sh && \
  bash bootstrap.sh
