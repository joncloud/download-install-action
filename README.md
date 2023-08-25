# Download Install Action

Downloads, extracts and installs programs.

## Inputs

### `checksum`

Checksum to validate the downloaded file against. Either this or checksum-url is required.

### `checksum-url`

URL to the checksum file to validate. Either this or checksum is required.

### `checksum-entry`

Used to determine the entry in the checksum file. Required when checksum-url is present.

### `skip-checksum`

Skips checksum evaluation

### `download-url`

URL to download the contents from. Alias for `archive-url`

### `sha-algorithm`

Algorithm used to compare the downloaded archive to the provided checksum. Defaults to `"sha256sum"`.

### `download-entries`

Entries in the content to install. Alias for `archive-entries`

### `target-path`

Where to extract and install the files. Defaults to `"/usr/local/bin"`.

### `modifier`

Modifier to apply to the extracted files. Defaults to `"+x"`.

## Examples

### Downloads and installs terraform

```yml
- uses: 'joncloud/download-install-action@main'
  with:
    checksum-url: 'https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_SHA256SUMS'
    checksum-entry: 'terraform_1.5.3_linux_amd64.zip'
    download-url: 'https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_linux_amd64.zip'
    download-entries: 'terraform'
```

### Downloads and installs terragrunt

```yml
- uses: 'joncloud/download-install-action@main'
  with:
    checksum-url: 'https://github.com/gruntwork-io/terragrunt/releases/download/v0.48.4/SHA256SUMS'
    checksum-entry: 'terragrunt_linux_amd64'
    download-url: 'https://github.com/gruntwork-io/terragrunt/releases/download/v0.48.4/terragrunt_linux_amd64'
    download-entries: 'terragrunt'
```
