ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}

ARG RAILS_VERSION
ARG NODE_VERSION
ARG APP_NAME

ENV RUBYOPT -EUTF-8
ENV PATH $PATH:/usr/local/lib/nodejs/bin

RUN gem install rails -v ${RAILS_VERSION} --no-document

RUN wget -q https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz\
  && tar -xJf node-v${NODE_VERSION}-linux-x64.tar.xz\
  && rm -f node-v${NODE_VERSION}-linux-x64.tar.xz\
  && mv node-v${NODE_VERSION}-linux-x64 /usr/local/lib/nodejs\
  && npm install --quiet -g npm

WORKDIR /opt

RUN rails _${RAILS_VERSION}_ new ${APP_NAME}\
  --skip-action-cable\
  --skip-action-mailbox\
  --skip-action-mailer\
  --skip-action-text\
  --skip-active-storage\
  --skip-bundle\
  --skip-gemfile\
  --skip-git\
  --skip-javascript\
  --skip-keeps\
  --skip-listen\
  --skip-spring\
  --skip-system-test\
  --skip-test\
  --skip-turbolinks\
  --skip-webpack-install\
  --skip-yarn

WORKDIR /opt/${APP_NAME}

RUN rm -f config/environments/*

COPY Gemfile Gemfile
COPY application.rb config/application.rb
COPY database.yml config/database.yml
COPY routes.rb config/routes.rb
COPY secrets.yml config/secrets.yml
COPY sidekiq.rb config/initializers/sidekiq.rb
COPY sidekiq.yml config/sidekiq.yml

RUN bundle install --jobs=4
RUN bundle exec rake assets:precompile
RUN bundle exec rake railties:install:migrations

COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
