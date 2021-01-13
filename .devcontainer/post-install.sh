#!/bin/sh

DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y --no-install-recommends apt-utils dialog dnsutils httpie wget unzip curl jq
DEBIAN_FRONTEND=dialog

getLatestVersion() {
LATEST_ARR=($(wget -q -O- https://api.github.com/repos/hashicorp/terraform/releases 2> /dev/null | awk '/tag_name/ {print $2}' | cut -d '"' -f 2 | cut -d 'v' -f 2))
for ver in "${LATEST_ARR[@]}"; do
  if [[ ! $ver =~ beta ]] && [[ ! $ver =~ rc ]] && [[ ! $ver =~ alpha ]]; then
    LATEST="$ver"
    break
  fi
done
echo -n "$LATEST"
}

VERSION=$(getLatestVersion)

cd ~
wget "https://releases.hashicorp.com/terraform/"$VERSION"/terraform_"$VERSION"_linux_amd64.zip"
unzip "terraform_"$VERSION"_linux_amd64.zip"
sudo install terraform /usr/local/bin/

# install tfsec
cd ~
wget "https://github-production-release-asset-2e65be.s3.amazonaws.com/173785481/6b952800-5431-11eb-91ff-3345a2dbc66f?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210113%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210113T120613Z&X-Amz-Expires=300&X-Amz-Signature=a91edcc6e22b8e6bb6323b7fd29e7c5d4cd05b0f3dbd9e71385ad4a61ab71ccf&X-Amz-SignedHeaders=host&actor_id=866719&key_id=0&repo_id=173785481&response-content-disposition=attachment%3B%20filename%3Dtfsec-linux-amd64&response-content-type=application%2Foctet-stream"
cp tfsec-linux-amd64 /usr/local/bin/
