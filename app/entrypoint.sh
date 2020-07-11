#!/bin/bash

set -eu

mkdir -p /root/.ssh
chmod 700 /root/.ssh
echo ${GITHUB_PRIVATE_KEY} | sed -e 's#\\n#\n#g' > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

bundle exec rake railties:install:migrations
bundle exec rake db:migrate || echo 'Skip migration'

exec "$@"
