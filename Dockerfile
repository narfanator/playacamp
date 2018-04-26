FROM ruby:2.3.3
ENV APP_NAME=swinder
ENV APP_HOME=/opt/swing-city/${APP_NAME}

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

COPY Gemfile ${APP_HOME}/Gemfile
COPY Gemfile.lock ${APP_HOME}/Gemfile.lock

RUN bundle install

EXPOSE 3000
COPY . ${APP_HOME}
