#!/bin/sh

if [ $# -eq 0 ]; then
  set -- rails server -b 0.0.0.0
fi
 
if [ "$1" = "rails" ]; then
  bundle
  yarn
fi

exec $@
