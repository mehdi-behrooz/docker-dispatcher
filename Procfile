haproxy: /usr/local/sbin/haproxy -Ws -f $HAPROXY_CONFIG -p $HAPROXY_PID 

dockergen: bash -c "sleep 5 && /usr/local/bin/docker-gen -watch -notify-output -notify '/reload.sh' $HAPROXY_TEMPLATE $HAPROXY_CONFIG"
