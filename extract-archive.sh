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

if [[ $ARCHIVE_FILE == *".tar.gz" || $ARCHIVE_FILE == *".tgz" ]]
then
  tar -zxvf "${ARCHIVE_FILE}" "${ARCHIVE_ENTRIES}" > /dev/null
else [[ $ARCHIVE_FILE == *".zip" ]]
  unzip -o -qq "${ARCHIVE_FILE}" "${ARCHIVE_ENTRIES}" > /dev/null
fi

for ENTRY in $(echo "${ARCHIVE_ENTRIES}" | xargs -n 1 echo); do
  if [[ -n "${MODIFIER}" ]]
  then
    chmod "${MODIFIER}" "${ENTRY}" > /dev/null
  fi
  mv "${ENTRY}" "${TARGET_PATH}" > /dev/null
  echo "${TARGET_PATH}/${ENTRY}"
done

popd > /dev/null
