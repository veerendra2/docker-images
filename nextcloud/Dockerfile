FROM debian:bookworm-slim AS ffmpeg-installer
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

FROM nextcloud:30.0.2-apache
COPY --from=ffmpeg-installer /usr/bin/ffmpeg /usr/bin/ffmpeg
COPY --from=ffmpeg-installer /usr/bin/ffprobe /usr/bin/ffprobe
COPY --from=ffmpeg-installer /usr/lib/*-linux-gnu/* /usr/lib/
COPY --from=ffmpeg-installer /lib/*-linux-gnu/* /usr/lib/