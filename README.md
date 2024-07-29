### Intro

An automatic request dispatcher based on HAProxy for docker environment. The difference between this dispatcher and most of others is that is handles the requests on TCP level.

### Example

```yaml

  dispatcher:
    image: ghcr.io/mehdi-behrooz/docker-dispatcher
    ports:
      - 443:443
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - /var/certs/:/certs/:ro
    environment:
      - LOG_LEVEL=debug

  webserver1:
    image: nginx1
    labels:
      - dispatcher.type=http
      - dispatcher.host=a.example1.com
      - dispatcher.port=80

  webserver2:
    image: nginx2
    labels:
      - dispatcher.type=http
      - dispatcher.host=a.example2.com
      - dispatcher.port=80

  webserver3:
    image: nginx3
    labels:
      - dispatcher.type=https
      - dispatcher.host=a.example2.com
      - dispatcher.port=443

  tcpserver:
    image: some_tcp_server
    labels:
      - dispatcher.type=tcp
      - dispatcher.port=443

```

### Labels

`dispatcher.type` (*required*): can be `http` or `https` or `tcp`
  - `http`: tells the dispatcher to decode the SSL request using SSL certificates in `/certs/` folder before dispatching.
  - `https`: tells the dispatcheer to forward requests without decoding SSL. The SSL decoding should be handled by the destination server itself.
  - `tcp`: tells the dispatcher to forward any request without SSL SNI to this server. Only one TCP server can be declared.

`dispatcher.host` (*required*): the SNI that server can handle.

`dispatcher.port`: optinally you can set the destination port. If not set, the first open port of the container is used. if no open port can be found, the dispatcher will use 80 for http requests and 443 for https and tcp request.  


