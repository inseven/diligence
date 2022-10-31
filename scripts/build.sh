#!/bin/bash

set -e
set -o pipefail
set -x

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIRECTORY="${SCRIPT_DIRECTORY}/.."

cd "$ROOT_DIRECTORY"

xcodebuild -scheme Interact -showdestinations
xcodebuild -scheme Interact -destination "platform=macOS" clean build
xcodebuild -scheme Interact -destination "platform=iOS Simulator,name=iPhone 14 Pro" clean build
