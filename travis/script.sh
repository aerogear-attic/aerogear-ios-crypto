#!/bin/sh
set -e

xcodebuild -workspace crypto-sdk.xcworkspace/ -scheme crypto-sdk clean test -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO