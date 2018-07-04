#!/bin/sh

if [ $# -eq 0 ]; then
  set -- rails server -b 0.0.0.0
fi

if [ "$1 $2" = "rails server" ] || [ "$1 $2" = "rails s" ]; then
  [ -f Gemfile   ] && bundle
  [ -f yarn.lock ] && yarn
  [ -f Rakefile  ] && rake db:create db:migrate

  rm -f tmp/pids/server.pid
fi

exec $@
