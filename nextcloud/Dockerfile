FROM debian:stable-slim as ffmpeg-build
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

FROM nextcloud:30.0.1-apache
COPY --from=ffmpeg-build /usr/bin/ffmpeg /usr/bin/ffmpeg