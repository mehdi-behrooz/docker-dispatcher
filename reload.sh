#!/bin/bash

if [ "$LOG_LEVEL" == "debug" ]; then
    echo "$HAPROXY_CONFIG:"
    cat "$HAPROXY_CONFIG"
fi

pid=$(cat "$HAPROXY_PID")
kill -USR2 "$pid"
