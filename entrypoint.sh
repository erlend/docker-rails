#!/bin/sh

if [ $# -eq 0 ]; then
  set -- rails server -b 0.0.0.0
fi

if [ "$1" = "rails" ] || [ "$1" = "rspec" ]; then

  if [ -x bin/setup ]; then
    bin/setup
  else
    bundle
  fi

  if [ "$2" = "server" ] || [ "$2" = "s" ]; then
    rm -f /tmp/pids/server.pid
  fi

fi

exec $@
