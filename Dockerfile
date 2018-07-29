ARG RUBY_VERSION="2.5.1"
ARG ALPINE_VERSION="3.7"

FROM ruby:${RUBY_VERSION}-alpine${ALPINE_VERSION}
MAINTAINER Erlend Finvåg <erlend.finvag@gmail.com>

ENV RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true" \
    PATH="/app/bin:$PATH"

WORKDIR /app

RUN apk add --no-cache \
      build-base \
      dumb-init \
      git \
      graphviz \
      less \
      nodejs \
      yarn \
      libffi-dev \
      libxml2-dev \
      libxslt-dev \
      mariadb-dev \
      postgresql-dev \
      sqlite-dev \
      tzdata && \
    gem install graphviz -N && \
    addgroup rails && \
    adduser -DG rails rails && \
    mkdir node_modules tmp && \
    chown rails:rails . tmp node_modules /usr/local/bundle

VOLUME /app/tmp /app/node_modules /usr/local/bundle

COPY entrypoint.sh /

EXPOSE 3000

USER rails
RUN bundle config build.nokogiri --use-system-libraries && \
    bundle config build.nokogumbo --use-system-libraries

ENTRYPOINT ["/entrypoint.sh"]
