#!/bin/bash

set -eu

bundle exec rake railties:install:migrations db:migrate

exec "$@"
