#!/usr/bin/env bash
set -e
flutter pub get -C app
npm ci -C functions
npm ci -C print-daemon
