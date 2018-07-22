#!/bin/sh

if [ $# -eq 0 ]; then
  set -- rails server -b 0.0.0.0
fi

if [ "$1" = "rails" ]; then
  [ -f Gemfile   ] && (bundle check || bundle install)
  [ -f yarn.lock ] && (yarn check   || yarn install)
  [ -f Rakefile  ] && rake db:create db:migrate

  if [ "$2" = "s" ] || [ "$2" == "server" ]; then
    rm -f tmp/pids/server.pid
  fi
fi

exec $@
