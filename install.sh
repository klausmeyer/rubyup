#!/usr/bin/env bash

set -e

registry="127.0.0.1:5000"
namespace="rubyup"

## Setup a local docker registry

docker stack deploy -c docker-stack-registry.yml rubyup_registry

## Build the socat image

image="$registry/$namespace/socat:latest"

cat Dockerfile.socat | docker build -t $image - # build with no context
docker push $image

## Build the platform image

image="$registry/$namespace/platform:latest"

docker build -t $image .
docker push $image

## Deploy the platform stack

docker stack deploy -c docker-stack-platform.yml rubyup_platform

## Build the worker images

versions="2.6.1 2.6.2 2.6.3"

baseimage="$registry/$namespace/worker:base"

cat Dockerfile.worker | docker build -t $baseimage - # build with no context
docker push $baseimage

for version in $versions
do
  container="rubyup-worker-$version"

  docker run -it --name $container $baseimage bash -l -c "rvm install $version"

  image="$registry/$namespace/worker:ruby-$version"

  docker commit $container $image
  docker push $image

  docker rm $container
done
