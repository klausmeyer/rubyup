FROM ruby:2.7.1-alpine

MAINTAINER Klaus Meyer <spam@klaus-meyer.net>

ENV PORT 8080
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV SECRET_KEY_BASE changeme

EXPOSE 8080

WORKDIR /usr/local/rubyup

ADD . .

RUN apk update \
 && apk add build-base zlib-dev tzdata nodejs yarn postgresql-dev \
 && rm -rf /var/cache/apk/* \
 && gem install bundler \
 && bundle install --without development test \
 && bundle exec rake assets:precompile \
 && addgroup -S rubyup && adduser -S rubyup -G rubyup -h /usr/local/rubyup \
 && chown -R rubyup.rubyup /usr/local/rubyup \
 && chown -R rubyup.rubyup /usr/local/bundle \
 && apk del build-base yarn

USER rubyup

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["web"]
