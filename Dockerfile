# syntax=docker/dockerfile:1
# checkov:skip=CKV_DOCKER_3: docker-gen must be root to access /var/run/docker.sock
# checkov:skip=CKV_DOCKER_7: docker-gen has no other tags except "latest"
# checkov:skip=CKV_DOCKER_8: docker-gen must be root to access /var/run/docker.sock

FROM docker.io/nginxproxy/docker-gen:latest AS docker-gen

FROM haproxy:3.0

USER root
# procps for: kill
# netcat-openbsd for: nc
RUN apt-get update -y \
    && apt-get install -y procps netcat-openbsd supervisor

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

HEALTHCHECK  --interval=15m \
    --start-period=1m \
    --start-interval=15s \
    CMD pgrep docker-gen && pgrep haproxy && nc -z localhost 443 || exit 1
