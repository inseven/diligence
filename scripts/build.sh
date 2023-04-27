#!/bin/bash

set -e
set -o pipefail
set -x

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIRECTORY="${SCRIPT_DIRECTORY}/.."

cd "$ROOT_DIRECTORY"

xcodebuild -scheme Diligence -showdestinations

# Build.
xcodebuild -scheme Diligence -destination "platform=macOS" clean build
xcodebuild -scheme Diligence -destination "platform=iOS Simulator,name=iPhone 14 Pro" clean build

# Test.
xcodebuild -scheme Diligence -destination "platform=macOS" test
xcodebuild -scheme Diligence -destination "platform=iOS Simulator,name=iPhone 14 Pro" test
