FROM ruby:2.7-alpine

ENV SRC_PATH /app
RUN mkdir -p $SRC_PATH
WORKDIR $SRC_PATH

COPY . $SRC_PATH

ENV VM_NUMBER 10

CMD ruby report.rb