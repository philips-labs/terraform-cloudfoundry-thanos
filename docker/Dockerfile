ARG prometheus_version=2.20.1
ARG thanos_version=0.14.0

FROM alpine:latest AS prometheus
ARG prometheus_version
ENV PROMETHEUS_VERSION ${prometheus_version}
RUN apk update \
 && apk add curl
WORKDIR /app
RUN curl -L -Os https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
 && tar zxvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz --strip 1 
RUN ls -l /app

FROM alpine:latest AS thanos
ARG thanos_version
ENV THANOS_VERSION ${thanos_version}
RUN apk update \
 && apk add curl
WORKDIR /app
RUN curl -L -Os https://github.com/thanos-io/thanos/releases/download/v${THANOS_VERSION}/thanos-${THANOS_VERSION}.linux-amd64.tar.gz \
 && tar zxvf thanos-${THANOS_VERSION}.linux-amd64.tar.gz --strip 1

FROM alpine:latest
LABEL maintainer="andy.lo-a-foe@philips.com"
RUN apk add --update supervisor jq && rm  -rf /tmp/* /var/cache/apk/*
RUN mkdir -p /sidecars/bin /sidecars/supervisor/conf.d sidecars/etc
RUN mkdir -p /prometheus /thanos
COPY --from=prometheus /app/prometheus /sidecars/bin
COPY --from=thanos     /app/thanos     /sidecars/bin
COPY prometheus.yml  /sidecars/etc
COPY prometheus.conf /sidecars/supervisor/conf.d
COPY thanos.conf /sidecars/supervisor/conf.d
COPY scripts/thanos_s3.sh /sidecars/bin

EXPOSE 9090

ADD supervisord.conf /etc/
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
