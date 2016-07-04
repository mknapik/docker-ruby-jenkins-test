FROM ruby:2.3
MAINTAINER Michał Knapik <michal.knapik@u2i.com>

RUN groupadd jenkins
RUN useradd -ms /bin/bash -g jenkins jenkins

USER jenkins
WORKDIR /home/jenkins
