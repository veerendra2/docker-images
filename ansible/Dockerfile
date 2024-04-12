FROM python:3.12-alpine3.19 as build
RUN apk add --update --no-cache --virtual .build-deps \
    gcc build-base musl-dev libffi-dev
COPY requirements.txt .
RUN pip3 install --user -r requirements.txt \
    --no-cache-dir \
    --break-system-packages \
    --no-warn-script-location

FROM python:3.12-alpine3.19

RUN apk add --no-cache --virtual .build-deps jq
COPY --from=build /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
