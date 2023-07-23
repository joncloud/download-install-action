#!/bin/bash
set -e

if [[ -z $ARCHIVE_URL ]]
then
  >&2 echo "ARCHIVE_URL is required"
  exit 1
fi

if [[ -z $CHECKSUM && -z $SKIP_CHECKSUM ]]
then
  >&2 echo "CHECKSUM is required"
  exit 1
fi

if [[ -z $SHA_ALGORITHM && -z $SKIP_CHECKSUM ]]
then
  >&2 echo "SHA_ALGORITHM is required"
  exit 1
fi

WORKING_DIR=$(mktemp -d)
ARCHIVE_FILE="${WORKING_DIR}/$(basename "$ARCHIVE_URL")"

curl "${ARCHIVE_URL}" --silent --output "${ARCHIVE_FILE}" > /dev/null

pushd "${WORKING_DIR}" > /dev/null

if [[ $SKIP_CHECKSUM == "true" ]]
then
  echo "${CHECKSUM}" | $SHA_ALGORITHM --check --status
fi

popd > /dev/null

echo "${ARCHIVE_FILE}"
