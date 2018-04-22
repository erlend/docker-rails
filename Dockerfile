ARG RUBY_VERSION=2.5.1
FROM ruby:${RUBY_VERSION}-alpine
MAINTAINER Erlend Finvåg <erlend.finvag@gmail.com>

EXPOSE 3000
ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    PATH="/app/bin:$PATH"

WORKDIR /app

RUN apk add --no-cache libxml2 libxslt tzdata nodejs && \
    addgroup rails && \
    adduser -DG rails rails

ONBUILD COPY . /app

ONBUILD RUN \
    BUILD_DEPS="git su-exec alpine-sdk yarn" && \
    BUILD_LIBS="libxml2-dev libxslt-dev libffi-dev" && \
    BUILD_DB="mariadb-dev postgresql-dev sqlite-dev" && \
    RUN_DB="mariadb-client-libs postgresql-libs sqlite-libs" && \
    apk add -U $BUILD_DEPS $BUILD_LIBS $BUILD_DB $RUN_DB && \
    chown -R rails:rails . && \
    su-exec rails gem install foreman -N && \
    su-exec rails bundle config build.nokogiri --use-system-libraries && \
    su-exec rails bundle config build.nokogumbo --use-system-libraries && \
    su-exec rails bundle install --deployment --without=development:test && \
    su-exec rails yarn install --production --non-interactive && \
    su-exec rails bundle exec rake assets:precompile && \
    (bundle list | grep -q "\* mysql\d "  || apk del mariadb-client-libs) && \
    (bundle list | grep -q "\* pg"        || apk del postgresql-libs) && \
    (bundle list | grep -q "\* sqlite\d " || apk del sqlite-libs) && \
    apk del $BUILD_DEPS $BUILD_LIBS $BUILD_DB && \
    rm -f /var/cache/apk/* /usr/local/lib/ruby/gems/*/cache/*

ONBUILD USER rails
CMD ["rails", "server", "--bind=0.0.0.0"]
