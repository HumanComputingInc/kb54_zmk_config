#!/bin/bash

CONTAINER_NAME=kb54_firmware_build
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

rm -rf zephyr/.git
# Clean up all untracked files
git clean -ffdx
