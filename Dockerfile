FROM ruby:2.6.2-alpine3.9
LABEL maintainer="Serg Podtynnyi <serg@podtynnyi.com>"

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

COPY docker/cleanup ./docker/

ENV BUILD_PACKAGES build-base bash less mariadb-connector-c-dev postgresql-dev nodejs \
                   libxml2-dev libxslt-dev exim tzdata

ENV PURGE_PACKAGES build-base gcc g++ make mariadb-connector-c-dev postgresql-dev libxslt-dev \
                   libxml2-dev yaml-dev gmp-dev zlib-dev libffi-dev

ENV RUNTIME_PACKAGES mariadb-connector-c postgresql-libs libxslt libxml2 yaml gmp zlib libffi

RUN apk add --update -q $BUILD_PACKAGES && \
    bundle install --quiet && \
    apk del --purge -q $PURGE_PACKAGES  && \
    apk add -q $RUNTIME_PACKAGES && \
    docker/cleanup

COPY . .

ENTRYPOINT ["docker/entry"]
