#!/bin/sh
set -e

BUILD_DEPS="git alpine-sdk yarn"
BUILD_LIBS="libxml2-dev libxslt-dev libffi-dev"

# Make sure some commonly required environment variables are set
export \
  AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID-x} \
  AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY-x} \
  AWS_S3_BUCKET=${AWS_S3_BUCKET-x}

notice() {
  echo -e "\n\033[0;32m==> $@\033[0m\n"
}

notice Detecting database adapter
if grep -q "gem ['\"]pg['\"]" Gemfile; then
  echo PostgreSQL
  BUILD_LIBS="$BUILD_LIBS postgresql-dev"
  RUN_LIBS="$RUN_LIBS postgresql-libs"
  DATABASE_URL="postgres:/"
fi

if grep -q "gem ['\"]mysql2['\"]" Gemfile; then
  echo MySQL
  BUILD_LIBS="$BUILD_LIBS mariadb-dev"
  RUN_LIBS="$RUN_LIBS mariadb-client-libs"
  DATABASE_URL="mysql:/"
fi

if grep -q "gem ['\"]sqlite3['\"]" Gemfile; then
  echo SQLite
  BUILD_LIBS="$BUILD_LIBS sqlite-dev"
  RUN_LIBS="$RUN_LIBS sqlite-libs"
  DATABASE_URL="sqlite:db/$RAILS_ENV.sqlite3"
fi

notice Installing system dependencies...
apk add -U dumb-init $BUILD_DEPS $BUILD_LIBS $RUN_LIBS

bundle config build.nokogiri --use-system-libraries
bundle config build.nokogumbo --use-system-libraries

notice Installing Ruby packages...
bundle install --deployment --without="$BUNDLE_WITHOUT"

# Ruby bundle must be installed this row or "bundle exec" will work
export SECRET_KEY_BASE=${SECRET_KEY_BASE-`bundle exec rake secret`} DATABASE_URL

notice Compiling assets...
bundle exec rake assets:precompile

chown -R rails:rails tmp

notice Cleaning up...
apk del $BUILD_DEPS $BUILD_LIBS
rm -rf \
  node_modules \
  /home/rails/.cache \
  /var/cache/apk/* \
  /usr/local/lib/ruby/gems/*/cache/* \
  /build.sh
