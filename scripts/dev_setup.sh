#!/usr/bin/env bash
set -e
if ! command -v flutter >/dev/null 2>&1; then
    echo "Flutter not found – installing locally..."
    git clone https://github.com/flutter/flutter.git -b stable flutter-sdk
    export PATH="$PWD/flutter-sdk/bin:$PATH"
fi
flutter pub get -C app
npm ci -C functions
npm ci -C print-daemon
