FROM python:3.13-alpine3.19 AS build
COPY requirements.txt .
RUN apk add --update --no-cache gcc build-base musl-dev libffi-dev && \
    pip3 install --user -r requirements.txt --no-cache-dir --break-system-packages --no-warn-script-location

FROM python:3.13-alpine3.19

RUN adduser -D ansible && \
    apk add --no-cache jq openssh-client openssl

COPY --from=build /root/.local /home/ansible/.local

RUN chown -R ansible:ansible /home/ansible/.local

ENV PATH=/home/ansible/.local/bin:$PATH
USER ansible
WORKDIR /home/ansible
