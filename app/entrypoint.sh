#!/bin/bash

set -eu

bundle exec rake railties:install:migrations
bundle exec rake db:migrate || echo 'Skip migration'

exec "$@"
