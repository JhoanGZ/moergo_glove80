#!/bin/bash

set -euo pipefail

IMAGE=glove80-zmk-config-docker
ZMK_REVISION="${1:-8aeaaa66fbb4b94948c8763e06f1920ab0b69480}"

docker build --build-arg "ZMK_REVISION=$ZMK_REVISION" -t "$IMAGE" .
docker run --rm -v "$PWD:/config" -e UID="$(id -u)" -e GID="$(id -g)" "$IMAGE"
