FROM docker.io/nginxproxy/docker-gen:latest AS docker-gen

FROM haproxy:latest

USER root
RUN apt-get update -y
RUN apt-get install -y procps             # for kill command
RUN apt-get install -y netcat-openbsd     # for nc
RUN apt-get install -y supervisor

ENV LOG_LEVEL=info
ENV DOCKER_HOST=unix:///tmp/docker.sock
ENV HAPROXY_CONFIG=/etc/haproxy/haproxy.cfg
ENV HAPROXY_TEMPLATE=/etc/haproxy/haproxy.tmpl
ENV HAPROXY_PID=/run/haproxy.pid

COPY --from=docker-gen /usr/local/bin/docker-gen /usr/local/bin/docker-gen
COPY ./haproxy.tmpl $HAPROXY_TEMPLATE
COPY ./haproxy.cfg $HAPROXY_CONFIG
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY --chmod=755 reload.sh /reload.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

HEALTHCHECK CMD supervisorctl status docker-gen && supervisorctl status haproxy && nc -z localhost 443 || exit 1
