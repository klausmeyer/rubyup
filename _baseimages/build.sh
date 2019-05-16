#!/bin/bash -e

registry="localhost:5000"
namespace="rubyup"

versions=(
  2.6.1
  2.6.2
  2.6.3
)

echo "(Re-)Building docker images"

docker build -t "$registry/$namespace/worker:base" .

for version in $versions
do
  echo "Building Image with Ruby $version"
  docker run -it --name "rubyup-worker-$version" "$registry/$namespace/worker:base" bash -l -c "rvm install $version"

  docker commit "rubyup-worker-$version" "$registry/$namespace/worker:ruby-$version"
  docker rm "rubyup-worker-$version"

  docker push "$registry/$namespace/worker:ruby-$version"
done
