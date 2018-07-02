#!/bin/sh

if [ $# -eq 0 ]; then
  set -- rails server -b 0.0.0.0
fi

if [ "$1 $2" = "rails server" ] || [ "$1 $2" = "rails s" ]; then
  if [ -x bin/setup ]; then
    ./bin/setup
  else
    [ -f Gemfile   ] && rails bundle
    [ -f yarn.lock ] && rails yarn
  fi

  rm -f tmp/pids/server.pid
fi

exec $@
