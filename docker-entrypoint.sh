#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

RAILS_ENV=production bundle exec ./bin/rails assets:precompile
bundle exec ./bin/rails s -b 0.0.0.0
