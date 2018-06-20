ARG RUBY_VERSION="2.5.1"
ARG ALPINE_VERSION="3.7"

FROM ruby:${RUBY_VERSION}-alpine${ALPINE_VERSION}
MAINTAINER Erlend Finvåg <erlend.finvag@gmail.com>

ENV RAILS_ENV="production" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_LOG_TO_STDOUT="true" \
    PATH="/app/bin:$PATH"

WORKDIR /app

RUN apk add --no-cache libxml2 libxslt tzdata nodejs && \
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" \
    | tee -a /etc/apk/repositories
    addgroup rails && \
    adduser -DG rails rails

COPY build.sh /

ONBUILD ARG RAILS_ENV="production"
ONBUILD ARG BUNDLER_WITHOUT="development:test"
ONBUILD ARG INSTALL_GEMS=""
ONBUILD ARG INSTALL_PACKAGES=""

ONBUILD COPY . /app

ONBUILD RUN /build.sh

ONBUILD USER rails
ENTRYPOINT ["dumb-init"]
CMD ["rails", "server"]
EXPOSE 3000
