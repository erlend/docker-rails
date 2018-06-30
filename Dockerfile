ARG RUBY_VERSION="2.5.1"
ARG ALPINE_VERSION="3.7"

FROM ruby:${RUBY_VERSION}-alpine${ALPINE_VERSION}
MAINTAINER Erlend Finvåg <erlend.finvag@gmail.com>

ENV RAILS_ENV="production" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true" \
    PATH="/app/bin:$PATH"

WORKDIR /app

RUN apk add --no-cache dumb-init libxml2 libxslt tzdata && \
    addgroup rails && \
    adduser -DG rails rails

COPY build/* /build/

ONBUILD ARG RAILS_ENV="production"
ONBUILD ARG BUNDLE_WITHOUT="development:test"

ONBUILD COPY Gemfile* /app/

ONBUILD RUN /build/system.sh

ONBUILD COPY . /app

ONBUILD RUN /build/assets.sh

ONBUILD USER rails
ENTRYPOINT ["dumb-init"]
CMD bundle exec rails server -b 0.0.0.0
EXPOSE 3000
