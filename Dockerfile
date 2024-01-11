FROM ruby:3.2.2-alpine AS chat

RUN apk --update add \
    build-base \
    tzdata \
    yarn \
    git \
    bash \
    libxml2\
    libxml2-dev\
    && rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile* /app/
RUN gem update --system 3.5.4
RUN gem install bundler -v $(tail -n 1 Gemfile.lock)
#RUN bundle config set path 'vendor/bundle'
RUN bundle check || bundle install

COPY package.json yarn.lock /app/
RUN yarn install --check-files

COPY . /app/

#ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["/bin/bash"]