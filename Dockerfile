FROM ruby:2.4-alpine3.6

RUN bundle config --global frozen 1
RUN bundle config --global --jobs 4

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
COPY docker/cleanup /usr/src/app/docker/cleanup

RUN apk add -v --no-cache --progress \
  build-base \
  bash \
  less \
  mariadb-dev \
  postgresql-dev \
  nodejs \
  libxml2-dev \
  libxslt-dev \
  tzdata && \
  bundle install && \
  docker/cleanup  && \
  apk del --purge -v build-base gcc g++ make mariadb-dev  && \
  apk add -v --no-cache --progress mariadb-client-libs

COPY . /usr/src/app

ENTRYPOINT ["docker/entry"]
