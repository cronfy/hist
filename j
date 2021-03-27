#!/usr/bin/env bash

JEKYLL_VERSION=3.8

if [ "$#" -lt 1 ] ; then
	echo "Syntax: ./j <command>" >&2
	echo -e "\nTry:\n\t./j bash" >&2
	exit 1
fi

cd `dirname $0`/jekyll || {
	echo "Failed cd to dir ./jekyll, exiting." >&2
	exit 1
}

docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -p 4000:4000 \
  -it jekyll/jekyll:$JEKYLL_VERSION "$@"

