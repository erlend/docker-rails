#!/bin/sh
[ "$1" = "rails" ] && bundle && yarn

exec $@
