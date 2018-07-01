#!/bin/sh

if [ $# -eq 0 ]; then
  set -- rails server -b 0.0.0.0
fi

if [ "$1 $2" = "rails server" ] || [ "$1 $2" = "rails s" ]; then
  if [ -x bin/setup ]; then
    ./bin/setup
  else
    [ -f Gemfile   ] && bundle
    [ -f yarn.lock ] && yarn
  fi

  rm -f tmp/pids/server.pid
fi

exec $@
