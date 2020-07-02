#!/bin/bash

set -eu

bundle exec rake db:migrate || echo 'Skip migration'

exec "$@"
