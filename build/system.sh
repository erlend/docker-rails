#!/bin/sh
set -e
. /build/env

BUILD_DEPS="git alpine-sdk"
BUILD_LIBS="libxml2-dev libxslt-dev libffi-dev"

notice() {
  echo -e "\n\033[0;32m==> $@\033[0m\n"
}

notice Detecting database adapter
if grep -q "gem ['\"]pg['\"]" Gemfile; then
  echo PostgreSQL
  BUILD_LIBS="$BUILD_LIBS postgresql-dev"
  RUN_LIBS="$RUN_LIBS postgresql-libs"
  echo "export DATABASE_URL=postgres:/" >> /build/env
fi

if grep -q "gem ['\"]mysql2['\"]" Gemfile; then
  echo MySQL
  BUILD_LIBS="$BUILD_LIBS mariadb-dev"
  RUN_LIBS="$RUN_LIBS mariadb-client-libs"
  echo "export DATABASE_URL=mysql:/" >> /build/env
fi

if grep -q "gem ['\"]sqlite3['\"]" Gemfile; then
  echo SQLite
  BUILD_LIBS="$BUILD_LIBS sqlite-dev"
  RUN_LIBS="$RUN_LIBS sqlite-libs"
  echo "export DATABASE_URL=sqlite:db/$RAILS_ENV.sqlite3" >> /build/env
fi

notice Installing system dependencies...
apk add -U dumb-init $BUILD_DEPS $BUILD_LIBS $RUN_LIBS

bundle config build.nokogiri --use-system-libraries
bundle config build.nokogumbo --use-system-libraries

export \
  AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID-x} \
  AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY-x}

notice Installing Ruby packages...
bundle install --deployment --without="$BUNDLE_WITHOUT"

notice Cleaning up...
apk del $BUILD_DEPS $BUILD_LIBS
rm -rf tmp/* /home/rails/.cache /var/cache/apk/* /usr/local/lib/ruby/gems/*/cache/*

notice build/system.sh completed
