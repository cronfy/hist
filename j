#!/usr/bin/env bash

export JEKYLL_VERSION=3.8

cd `dirname $0`/jekyll

docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -p 4000:4000 \
  -it jekyll/jekyll:$JEKYLL_VERSION "$@"

