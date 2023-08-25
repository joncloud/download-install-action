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

TERRAGRUNT_VERSION="v0.48.4"

export CHECKSUM_URL=https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/SHA256SUMS
export CHECKSUM_ENTRY=terragrunt_${OS_MONIKER}_${CPU_MONIKER}
CHECKSUM="$(./get-checksum.sh)"
export CHECKSUM
echo "CHECKSUM=${CHECKSUM}"

# download-content
export DOWNLOAD_URL=https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_${OS_MONIKER}_${CPU_MONIKER}
export SHA_ALGORITHM=sha256sum
DOWNLOAD_FILE="$(./download-content.sh)"
export DOWNLOAD_FILE
echo "DOWNLOAD_FILE=${DOWNLOAD_FILE}"

# extract-content
export DOWNLOAD_ENTRIES=terragrunt
export TARGET_PATH="${PWD}/tmp"
export MODIFIER=+x
./extract-content.sh

# cleanup
rm -rf "$(dirname "${DOWNLOAD_FILE}")"

./tmp/terragrunt -version | grep "terragrunt version ${TERRAGRUNT_VERSION}"

rm -rf ./tmp
