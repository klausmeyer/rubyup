#!/bin/sh

set -e

case $1 in

  migrations)
    exec rails db:migrate
  ;;

  web)
    exec puma -C config/puma.rb
  ;;

  worker)
    exec sidekiq
  ;;

esac
