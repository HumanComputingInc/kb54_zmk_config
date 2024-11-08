#!/bin/bash
set -ex

SOURCE_DIR=$(pwd)
TARGET_DIR=/home/ubuntu/kb54_zmk_config
CONTAINER_NAME=kb54_firmware_build
IMAGE_NAME=zmkfirmware/zmk-build-arm:stable

if ! [ -x "$(command -v docker)" ]; then
  echo "Error: docker is not installed." >&2
  exit 1
fi

if [ "$(docker ps --all -q -f name=$CONTAINER_NAME)" ]; then
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

docker run -it\
  --name $CONTAINER_NAME \
  -v $SOURCE_DIR:$TARGET_DIR \
  --entrypoint "/bin/bash" \
  -e HOME_DIR=$TARGET_DIR \
  $IMAGE_NAME "$TARGET_DIR/scripts/build.sh"
