FROM ruby:3.2.2-alpine AS chat

RUN apk --update add \
    build-base \
    tzdata \
    yarn \
    libc6-compat \
    postgresql-dev \
    postgresql-client \
    redis \
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile* /app/
RUN gem update --system 3.5.6
RUN gem install bundler -v $(tail -n 1 Gemfile.lock)
RUN bundle check || bundle install

COPY package.json yarn.lock /app/
RUN yarn install --check-files

EXPOSE 3000

COPY . /app/

ENTRYPOINT ["./docker-entrypoint.sh"]