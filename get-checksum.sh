#!/bin/bash
set -e

if [[ -z $CHECKSUM_URL ]]
then
  >&2 echo "CHECKSUM_URL is required"
  exit 1
fi

if [[ -z $CHECKSUM_ENTRY ]]
then
  >&2 echo "CHECKSUM_ENTRY is required"
  exit 1
fi

CHECKSUM=$(curl --silent --location "${CHECKSUM_URL}" | grep "${CHECKSUM_ENTRY}")
echo "${CHECKSUM}"
