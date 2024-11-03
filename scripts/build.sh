#!/bin/bash
set -x

ZEPHYR_VERSION=3.5.0

# Check if HOME_DIR is set
if [ -z "$HOME_DIR" ]
then
  echo "HOME_DIR is not set"
  exit 1
fi

ZMK_CONFIG="$HOME_DIR/config"

cd $HOME_DIR
west init -l ./config

set -e
west update
west zephyr-export

function build_firmware {
  DISPLAY_NAME=$1
  BUILD_DIR=$2
  ARTIFACT_NAME="${DISPLAY_NAME}-zmk"
  west build -s zmk/app -d $BUILD_DIR -b $DISPLAY_NAME -- -DZMK_CONFIG=$ZMK_CONFIG

  # Kconfig file
  if [ -f "$BUILD_DIR/zephyr/.config" ]
  then
    grep -v -e "^#" -e "^$" "$BUILD_DIR/zephyr/.config" | sort
  else
    echo "No Kconfig output"
  fi

  # Devicetree file
  if [ -f "$BUILD_DIR/zephyr/zephyr.dts" ]
  then
    cat "$BUILD_DIR/zephyr/zephyr.dts"
  elif [ -f "$BUILD_DIR/zephyr/zephyr.dts.pre" ]
  then
    cat -s "$BUILD_DIR/zephyr/zephyr.dts.pre"
  else
    echo "No Devicetree output"
  fi

  # Rename artifacts
  mkdir "$BUILD_DIR/artifacts"
  if [ -f "$BUILD_DIR/zephyr/zmk.uf2" ]
  then
    cp "$BUILD_DIR/zephyr/zmk.uf2" "$BUILD_DIR/artifacts/$ARTIFACT_NAME.uf2"
  elif [ -f "$BUILD_DIR/zephyr/zmk.uf2" ]
  then
    cp "$BUILD_DIR/zephyr/zmk.uf2" "$BUILD_DIR/artifacts/$ARTIFACT_NAME.uf2"
  fi
}


DISPLAY_NAME_L=kb54_nrf52840_l
BUILD_DIR_L="$(mktemp -d)"
build_firmware $DISPLAY_NAME_L $BUILD_DIR_L

DISPLAY_NAME_R=kb54_nrf52840_r
BUILD_DIR_R="$(mktemp -d)"
build_firmware $DISPLAY_NAME_R $BUILD_DIR_R

# Copy artifacts into home directory
cp -r $BUILD_DIR_L/artifacts $HOME_DIR
rm -rf $BUILD_DIR_L
cp -r $BUILD_DIR_R/artifacts $HOME_DIR
rm -rf $BUILD_DIR_R

ls -l $HOME_DIR/artifacts

