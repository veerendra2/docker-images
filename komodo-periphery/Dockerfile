FROM ghcr.io/mbecker20/periphery:latest
RUN groupadd -g 9999 periphery && \
    useradd -u 9999 -g periphery -m -s /usr/sbin/nologin periphery
USER 9999:9999
WORKDIR /home/periphery
ENV HOME=/home/periphery