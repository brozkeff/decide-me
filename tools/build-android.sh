#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${JAVA_HOME:?Set JAVA_HOME to JDK 21 for this invocation}"
: "${ANDROID_HOME:?Set ANDROID_HOME to your Android SDK}"
export APP_VERSION="${APP_VERSION:-0.1.0-brozkeff.$(git rev-parse --short=7 HEAD)}"
export BUILD_NUMBER="${BUILD_NUMBER:-1}"
npm ci
npm test
npm run build
npx cap sync android
cd android
./gradlew assembleDebug --console=plain --max-workers=4
