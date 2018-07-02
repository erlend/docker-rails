#!/bin/sh

if [ $# -eq 0 ]; then
  set -- rails server -b 0.0.0.0
fi

if [ "$1 $2" = "rails server" ] || [ "$1 $2" = "rails s" ]; then
  chown rails:rails /usr/local/bundle/gems node_modules

  if [ -x bin/setup ]; then
    su-exec rails ./bin/setup
  else
    [ -f Gemfile   ] && su-exec rails bundle
    [ -f yarn.lock ] && su-exec rails yarn
  fi

  rm -f tmp/pids/server.pid
fi

exec su-exec rails $@
