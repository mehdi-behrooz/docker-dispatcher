#!/bin/bash

if [ "$LOG_LEVEL" == "debug" ]; then
    echo "$HAPROXY_CONFIG:"
    cat "$HAPROXY_CONFIG"
fi

if [[ -f "$HAPROXY_PID" ]]; then
    pid=$(cat "$HAPROXY_PID")
    kill -USR2 "$pid"
else
    echo "File does not exist: $HAPROXY_PID"
fi
