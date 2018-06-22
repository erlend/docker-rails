#!/bin/sh
set -e
. /build/env

BUILD_DEPS="nodejs yarn"

notice() {
  echo -e "\n\033[0;32m==> $@\033[0m\n"
}

notice Installing NodeJS packages
apk add -U $BUILD_DEPS

# Set rails required variables
export SECRET_KEY_BASE=${SECRET_KEY_BASE-`bundle exec rake secret`} DATABASE_URL

notice Compiling assets...
bundle exec rake assets:precompile
chown -R rails:rails tmp

notice Cleaning up...
apk del $BUILD_DEPS
rm -rf tmp/* node_modules /var/cache/apk/* /home/rails/.cache /build
