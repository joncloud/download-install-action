#!/bin/bash
set -e

# Compatibility with runner, and running on host OS
if [[ "${OSTYPE}" == "darwin"* ]]
then
  OS_MONIKER=darwin
else
  OS_MONIKER=linux
fi

CPU_ARCH="$(uname -m)"
if [[ "${CPU_ARCH}" == "arm64" || "${CPU_ARCH}" == "aarch64" ]]
then
  CPU_MONIKER=arm64
else
  CPU_MONIKER=amd64
fi

TERRAFORM_VERSION="1.5.3"

# get-checksum
export CHECKSUM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS
export CHECKSUM_ENTRY=terraform_${TERRAFORM_VERSION}_${OS_MONIKER}_${CPU_MONIKER}.zip
CHECKSUM="$(./get-checksum.sh)"
export CHECKSUM
echo "CHECKSUM=${CHECKSUM}"

# download-archive
export ARCHIVE_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS_MONIKER}_${CPU_MONIKER}.zip
export SHA_ALGORITHM=sha256sum
ARCHIVE_FILE="$(./download-archive.sh)"
export ARCHIVE_FILE
echo "ARCHIVE_FILE=${ARCHIVE_FILE}"

# extract-archive
export ARCHIVE_ENTRIES=terraform
export TARGET_PATH="${PWD}/tmp"
export MODIFIER=+x
./extract-archive.sh

# cleanup
rm -rf "$(dirname "${ARCHIVE_FILE}")"

./tmp/terraform -version | grep "Terraform v${TERRAFORM_VERSION}"

rm -rf ./tmp
