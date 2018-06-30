#!/bin/sh

if [ $# -eq 0 ]; then
  set -- rails server -b 0.0.0.0
fi
 
if [ "$1" = "rails" ]; then
  bundle
  yarn

  if [ "$2" = "server" ] || [ "$2" = "s" ]; then
    rm -f /tmp/pids/server.pid
  fi
fi

exec $@
