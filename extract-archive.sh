#!/bin/bash
set -e

if [[ -z $ARCHIVE_FILE ]]
then
  >&2 echo "ARCHIVE_FILE is required"
  exit 1
fi

if [[ -z $ARCHIVE_ENTRIES ]]
then
  >&2 echo "ARCHIVE_ENTRIES is required"
  exit 1
fi

if [[ -z $TARGET_PATH ]]
then
  >&2 echo "TARGET_PATH is required"
  exit 1
fi

if [[ ! -d "${TARGET_PATH}" ]]
then
  mkdir "${TARGET_PATH}" > /dev/null
fi

pushd "$(dirname "${ARCHIVE_FILE}")" > /dev/null

move-file() {
  >&2 echo "move-file $1 $2"
  if [[ -n "${MODIFIER}" ]]
  then
    chmod "${MODIFIER}" "${1}" > /dev/null
  fi
  mv "${1}" "${2}" > /dev/null
}

extract-file() {
  for ENTRY in $(echo "${ARCHIVE_ENTRIES}" | xargs -n 1 echo); do
    move-file "${ENTRY}" "${TARGET_PATH}"
    echo "${TARGET_PATH}/${ENTRY}"
  done
}

if [[ $ARCHIVE_FILE == *".tar.gz" || $ARCHIVE_FILE == *".tgz" ]]
then
  tar -zxvf "${ARCHIVE_FILE}" "${ARCHIVE_ENTRIES}" > /dev/null
  extract-file
elif [[ $ARCHIVE_FILE == *".zip" ]]
then
  unzip -o -qq "${ARCHIVE_FILE}" "${ARCHIVE_ENTRIES}" > /dev/null
  extract-file
else
  move-file "${ARCHIVE_FILE}" "${TARGET_PATH}/${ARCHIVE_ENTRIES}"
fi

popd > /dev/null
