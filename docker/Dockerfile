ARG prometheus_version=2.25.0
ARG thanos_version=0.18.0
ARG aplipe_version=3.13

FROM alpine:$aplipe_version AS prometheus
ARG prometheus_version
ENV PROMETHEUS_VERSION ${prometheus_version}
RUN apk add --no-cache curl
WORKDIR /app
RUN curl -L -Os https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
 && tar zxvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz --strip 1 
RUN ls -l /app

## Build exporter
FROM golang:alpine as exporter
RUN apk add --no-cache git
WORKDIR /app
RUN git clone https://github.com/alphagov/paas-prometheus-exporter.git .
RUN CGO_ENABLED=0 GOOS=linux go build 

## Build thanos
FROM alpine:$aplipe_version AS thanos
ARG thanos_version
ENV THANOS_VERSION ${thanos_version}
RUN apk add --no-cache curl
WORKDIR /app
RUN curl -L -Os https://github.com/thanos-io/thanos/releases/download/v${THANOS_VERSION}/thanos-${THANOS_VERSION}.linux-amd64.tar.gz \
 && tar zxvf thanos-${THANOS_VERSION}.linux-amd64.tar.gz --strip 1

## Build final image
FROM alpine:$aplipe_version
LABEL maintainer="andy.lo-a-foe@philips.com"
RUN apk add --no-cache supervisor jq curl && rm -rf /tmp/* /var/cache/apk/*
RUN apk add --no-cache yq --repository http://dl-cdn.alpinelinux.org/alpine/edge/community

RUN mkdir -p /sidecars/bin /sidecars/supervisor/conf.d sidecars/etc /prometheus /thanos

COPY --from=prometheus /app/prometheus /sidecars/bin
COPY --from=thanos     /app/thanos     /sidecars/bin
COPY --from=exporter   /app/paas-prometheus-exporter /sidecars/bin

COPY prometheus.yml  /sidecars/etc
COPY supervisord_configs/ /sidecars/supervisor/conf.d
COPY scripts/ /sidecars/bin
COPY crontab.txt /var/crontab.txt

RUN crontab /var/crontab.txt

EXPOSE 9090

COPY supervisord.conf /etc/
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
