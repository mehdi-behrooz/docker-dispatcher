#!/bin/bash

if [ "$LOG_LEVEL" == "debug" ]
then
        echo "$HAPROXY_CONFIG:"
        cat $HAPROXY_CONFIG
fi

kill -USR2 `cat $HAPROXY_PID`

