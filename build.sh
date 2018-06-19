#!/bin/sh
BUILD_DEPS="git su-exec alpine-sdk yarn"
BUILD_LIBS="libxml2-dev libxslt-dev libffi-dev"
BUILD_DB="mariadb-dev postgresql-dev sqlite-dev"
RUN_DB="mariadb-client-libs postgresql-libs sqlite-libs"
INSTALL_PACKAGES="$INSTALL_PACKAGES $BUILD_DEPS $BUILD_LIBS $BUILD_DB $RUN_DB"

function notice {
  echo
  echo "==> $@"
  echo
}

chown -R rails:rails .

notice Installing dependencies...
apk add -U dumb-init $INSTALL_PACKAGES

su-exec rails bundle config build.nokogiri --use-system-libraries
su-exec rails bundle config build.nokogumbo --use-system-libraries

notice Installing ruby gems...
su-exec rails gem install $INSTALL_GEMS -N
su-exec rails bundle install --deployment --without=$BUNDLER_WITHOUT

notice Installing node packages...
su-exec rails yarn install --production --non-interactive

notice Compiling assets...
su-exec rails bundle exec rake assets:precompile

notice Removing database dependencies...
bundle list | grep -q "\* mysql\d "  || apk del mariadb-client-libs
bundle list | grep -q "\* pg"        || apk del postgresql-libs
bundle list | grep -q "\* sqlite\d " || apk del sqlite-libs

notice Cleaning up...
apk del $BUILD_DEPS $BUILD_LIBS $BUILD_DB
rm -f /var/cache/apk/* /usr/local/lib/ruby/gems/*/cache/* /build.sh
