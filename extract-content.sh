#!/bin/bash
set -e

if [[ -z $DOWNLOAD_FILE ]]
then
  >&2 echo "DOWNLOAD_FILE is required"
  exit 1
fi

if [[ -z $DOWNLOAD_ENTRIES ]]
then
  >&2 echo "DOWNLOAD_ENTRIES is required"
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

pushd "$(dirname "${DOWNLOAD_FILE}")" > /dev/null

move-file() {
  >&2 echo "move-file $1 $2"
  if [[ -n "${MODIFIER}" ]]
  then
    chmod "${MODIFIER}" "${1}" > /dev/null
  fi
  mv "${1}" "${2}" > /dev/null
}

extract-file() {
  for ENTRY in $(echo "${DOWNLOAD_ENTRIES}" | xargs -n 1 echo); do
    move-file "${ENTRY}" "${TARGET_PATH}"
    echo "${TARGET_PATH}/${ENTRY}"
  done
}

if [[ $DOWNLOAD_FILE == *".tar.gz" || $DOWNLOAD_FILE == *".tgz" ]]
then
  tar -zxvf "${DOWNLOAD_FILE}" "${DOWNLOAD_ENTRIES}" > /dev/null
  extract-file
elif [[ $DOWNLOAD_FILE == *".zip" ]]
then
  unzip -o -qq "${DOWNLOAD_FILE}" "${DOWNLOAD_ENTRIES}" > /dev/null
  extract-file
else
  move-file "${DOWNLOAD_FILE}" "${TARGET_PATH}/${DOWNLOAD_ENTRIES}"
fi

popd > /dev/null
