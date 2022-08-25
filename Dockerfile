FROM alpine:3 AS download
ARG PREFILL_VERSION=1.4.1

RUN \
    cd /tmp && \
    wget -O BattleNetPrefill.zip https://github.com/tpill90/battlenet-lancache-prefill/releases/download/v${PREFILL_VERSION}/BattleNetPrefill-${PREFILL_VERSION}-linux-x64.zip && \
    unzip BattleNetPrefill && \
    mv BattleNetPrefill-${PREFILL_VERSION}-linux-x64\\BattleNetPrefill BattleNetPrefill && \
    chmod +x BattleNetPrefill


FROM ubuntu:22.04
LABEL maintainer="jess@mintopia.net"
ARG DEBIAN_FRONTEND=noninteractive
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
RUN \
    apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /app

COPY --from=download /tmp/BattleNetPrefill /app/BattleNetPrefill

WORKDIR /app
ENTRYPOINT [ "/app/BattleNetPrefill" ]
