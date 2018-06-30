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
      libffi-dev \
      libxml2-dev \
      libxslt-dev \
      mariadb-dev \
      postgresql-dev \
      sqlite-dev \
      tzdata && \
    addgroup rails && \
    adduser -DG rails rails && \
    chown rails:rails /app

# USER rails

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle config build.nokogumbo --use-system-libraries

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 3000
