#!/bin/sh
# 如果工程名称和Framework的Target名称不一样的话,要自定义FMKNAME
# 例如: FMK_NAME = "RH_Platform"
FMK_NAME=${PROJECT_NAME}

echo "FMK_NAME: ${FMK_NAME}"
# Install dir will be the final output to the framework.
# The following line create it in thse root folder of the current project.
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework
echo "INSTALL_DIR: ${INSTALL_DIR}"

# Working dir will be deleted after the framework creation.
WRK_DIR=build
# DEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework
DEVICE_DIR=${WRK_DIR}/${CONFIGURATION}-iphoneos/${FMK_NAME}.framework
echo "DEVICE_DIR: ${DEVICE_DIR}"

# SIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework
SIMULATOR_DIR=${WRK_DIR}/${CONFIGURATION}-iphonesimulator/${FMK_NAME}.framework
echo "SIMULATOR_DIR: ${SIMULATOR_DIR}"

# -configuration ${CONFIGURATION}
echo "CONFIGURATION: ${CONFIGURATION}"

# Clean and Building both architectures.
#xcodebuild -configuration "Release" -target "${FMK_NAME}" -sdk iphoneos clean build
xcodebuild -configuration ${CONFIGURATION} -target "${FMK_NAME}" -sdk iphoneos clean build
xcodebuild -configuration ${CONFIGURATION} -target "${FMK_NAME}" -sdk iphonesimulator clean build
# Cleaning the oldest.
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi
mkdir -p "${INSTALL_DIR}"
cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"
# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"
rm -r "${WRK_DIR}"
open "${INSTALL_DIR}"



