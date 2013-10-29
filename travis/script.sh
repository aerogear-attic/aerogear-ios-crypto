#!/bin/sh
set -e

# TODO once xcode5 is available on Travis
# see https://issues.jboss.org/browse/AGIOS-72
#xcodebuild -workspace crypto-sdk.xcworkspace/ -scheme crypto-sdk clean test -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO
xctool -workspace crypto-sdk.xcworkspace/ -scheme crypto-sdk