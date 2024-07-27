FROM docker.io/nginxproxy/docker-gen:latest AS docker-gen
FROM docker.io/nginxproxy/forego:0.18.1-debian AS forego

FROM haproxy:latest

USER root
RUN apt-get update -y
RUN apt-get install -y procps  # for kill command

ENV LOG_LEVEL=info
ENV DOCKER_HOST=unix:///tmp/docker.sock
ENV HAPROXY_CONFIG=/etc/haproxy/haproxy.cfg
ENV HAPROXY_TEMPLATE=/etc/haproxy/haproxy.tmpl
ENV HAPROXY_PID=/run/haproxy.pid

COPY --from=forego /usr/local/bin/forego /usr/local/bin/forego
COPY --from=docker-gen /usr/local/bin/docker-gen /usr/local/bin/docker-gen
COPY ./haproxy.tmpl $HAPROXY_TEMPLATE
COPY ./haproxy.cfg $HAPROXY_CONFIG
COPY ./Procfile /Procfile
COPY --chmod=755 reload.sh /reload.sh


CMD ["forego", "start", "-r", "-f", "/Procfile"]

