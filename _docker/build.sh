#!/bin/bash -e

echo "(Re-)Building docker images"

docker build -t rubyup:base -f Dockerfile-base .

docker build -t rubyup:ruby-2.6.2 -f Dockerfile-ruby2.6.2 .
docker build -t rubyup:ruby-2.6.3 -f Dockerfile-ruby2.6.3 .

echo Done
