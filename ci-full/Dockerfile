FROM ubuntu:24.04 AS build
COPY requirements.txt .
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl gnupg software-properties-common jq gcc python3 python3-dev python3-pip && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    curl -fsSL "https://pkgs.k8s.io/core:/stable:/$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN{FS=OFS="."} NF>2{print $(NF-2), $(NF-1)}')/deb/Release.key" | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN{FS=OFS="."} NF>2{print $(NF-2), $(NF-1)}')/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y terraform kubectl && \
    rm -rf /var/lib/apt/lists/* apt-key.gpg && \
    pip3 install --user -r requirements.txt --no-cache-dir --no-warn-script-location --break-system-packages

FROM ubuntu:24.04

RUN useradd -ms /bin/bash ci && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    tmate jq

COPY --from=build /usr/bin/terraform /usr/bin/terraform
COPY --from=build /usr/bin/kubectl /usr/bin/kubectl
COPY --from=build /root/.local /home/ci/.local

RUN chown ci:ci -R /home/ci/.local

ENV PATH=/home/ci/.local/bin:$PATH

WORKDIR /home/ci
USER ci
