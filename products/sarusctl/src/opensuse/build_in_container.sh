#!/usr/bin/bash

cd $(dirname $0)

ARCH=$(uname -m)

if [ "$ARCH" == "x86_64" ]
then
  GOARCH="amd64"
  TARGET_NAME="x86_64-unknown-linux-musl"
elif [ "$ARCH" == "aarch64" ]
then	
  GOARCH="arm64"
else
  GOARCH="${ARCH}"
fi

# if it is not a sarus-suite-deploy-build container, update it
PACKAGES_FILE="build.packages"
if [ ! -f /etc/sarus-suite-deploy.build ] && [ -f "${PACKAGES_FILE}" ]
then
  PACKAGES=$(cat ${PACKAGES_FILE} | paste -s -d" ")
  zypper install -y ${PACKAGES}

  # Rust toolchain
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  export PATH=$HOME/.cargo/bin:$PATH
fi

REPO="sarusctl"
cd ${REPO}
rm -rf dist

if [ -z "${VERSION}" ]
then
  VERSION=$(git describe --always --tags | tr '-' '_')	
fi	
COMMIT=$(git rev-parse HEAD)

RELEASE_VERSION=${VERSION}

sed -i -E -e "/^name = \"sarusctl\"/,/^version \=/ s/^version =.*$/version = \"${RELEASE_VERSION#v}\"/1" Cargo.toml

cargo build --release --target=${TARGET_NAME}

mkdir dist
cp target/${TARGET_NAME}/release/sarusctl dist/sarusctl-${GOARCH}
