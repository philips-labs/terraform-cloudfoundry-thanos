ARG prometheus_version=2.28.1
ARG thanos_version=0.21.1

FROM alpine:3.14.0 AS prometheus
ARG prometheus_version
ENV PROMETHEUS_VERSION ${prometheus_version}
RUN apk add --no-cache curl
WORKDIR /app
RUN curl -L -Os https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
 && tar zxvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz --strip 1 
RUN ls -l /app

## PAAS exporter
FROM philipslabs/paas-prometheus-exporter:latest as exporter

## Build thanos
FROM alpine:3.14.0 AS thanos
ARG thanos_version
ENV THANOS_VERSION ${thanos_version}
RUN apk add --no-cache curl
WORKDIR /app
RUN curl -L -Os https://github.com/thanos-io/thanos/releases/download/v${THANOS_VERSION}/thanos-${THANOS_VERSION}.linux-amd64.tar.gz \
 && tar zxvf thanos-${THANOS_VERSION}.linux-amd64.tar.gz --strip 1

## Variant
FROM philipslabs/variant:v0.0.18 AS variant

## Build final image
FROM alpine:3.14.0
LABEL maintainer="andy.lo-a-foe@philips.com"
RUN apk add --no-cache supervisor jq curl && rm -rf /tmp/* /var/cache/apk/*
RUN apk add --no-cache yq --repository http://dl-cdn.alpinelinux.org/alpine/edge/community

RUN mkdir -p /sidecars/bin /sidecars/supervisor/conf.d sidecars/etc /prometheus /thanos

COPY --from=prometheus /app/prometheus /sidecars/bin
COPY --from=thanos     /app/thanos     /sidecars/bin
COPY --from=variant    /app/app        /sidecars/bin/variant
COPY --from=exporter   /usr/local/bin/paas-prometheus-exporter /sidecars/bin

COPY prometheus/  /sidecars/etc
COPY supervisord_configs/ /sidecars/supervisor/conf.d
COPY scripts/ /sidecars/bin
COPY crontab.txt /var/crontab.txt

RUN crontab /var/crontab.txt

ENV ENABLE_CF_EXPORTER=false
ENV ENABLE_VARIANT=true

EXPOSE 9090

COPY supervisord.conf /etc/
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
