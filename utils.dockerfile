FROM postgres:10.3

ENV APP_HOME=/opt/swing-city/utils

RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

# RUN apt-get update && apt-get install -y curl
# RUN mkdir -p /etc/apt/sources.list.d/
# RUN curl https://cli-assets.heroku.com/install-debian.sh | sh

RUN apt-get update
RUN apt-get install -y software-properties-common curl apt-transport-https
RUN add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
RUN curl -L https://cli-assets.heroku.com/apt/release.key | apt-key add -
RUN apt-get update
RUN apt-get install -y heroku

COPY ./docker-bin ${APP_HOME}/bin
