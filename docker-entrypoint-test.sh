#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec ./bin/rails db:reset
bundle exec rspec -f d
echo "+++++++++++++++ Test success! ++++++++++++++++++++"
exit
