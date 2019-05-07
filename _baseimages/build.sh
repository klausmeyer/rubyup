#!/bin/bash -e

echo "(Re-)Building docker images"

docker build -t localhost:5000/rubyup/worker:base -f Dockerfile-base .

docker build -t localhost:5000/rubyup/worker:ruby-2.6.2 -f Dockerfile-ruby2.6.2 .
docker build -t localhost:5000/rubyup/worker:ruby-2.6.3 -f Dockerfile-ruby2.6.3 .

docker push localhost:5000/rubyup/worker
docker push localhost:5000/rubyup/worker:ruby-2.6.2
docker push localhost:5000/rubyup/worker:ruby-2.6.3

echo Done
