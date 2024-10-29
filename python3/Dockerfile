FROM python:3.11-alpine3.19 as build
RUN apk add --update --no-cache gcc build-base musl-dev libffi-dev
COPY requirements.txt .
RUN pip3 install --user -r requirements.txt --no-cache-dir --break-system-packages --no-warn-script-location

FROM python:3.11-alpine3.19

RUN apk add --no-cache jq git

RUN adduser -D appuser

COPY --from=build /root/.local /home/appuser/.local
RUN chown -R appuser:appuser /home/appuser/.local

ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser

WORKDIR /home/appuser