#!/bin/bash

# shellcheck disable=SC2046
docker run \
  --rm \
  -v "${PWD}:/mnt" \
  koalaman/shellcheck \
  $(find . -type f | sed "s|^./||" | grep ".sh$" | sed "s|\n| |")
