#!/usr/bin/env bash
# Builds the Flutter web app on Vercel's build machine.
#
# Vercel does not ship Flutter, so this downloads the pinned version first and
# then runs a normal release build. vercel.json calls this script, because
# Vercel limits `buildCommand` to 256 characters.
set -euo pipefail

# Keep in sync with the Flutter version you build with locally
# (Flutter 3.38.9 ships Dart 3.10.8, which pubspec.yaml requires).
FLUTTER_VERSION="3.38.9"
FLUTTER_DIR="${HOME}/flutter"

# Vercel builds as root. Flutter only prints a warning for that, and CI=true
# silences it.
export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true

git config --global --add safe.directory '*'

if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  # A shallow clone of the release tag needs no xz or unzip, and the files are
  # owned by the user running the build, so git does not complain about it.
  git clone --depth 1 --branch "${FLUTTER_VERSION}" \
    https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
fi
export PATH="${FLUTTER_DIR}/bin:${PATH}"

flutter --version
flutter config --no-analytics
flutter precache --web
flutter pub get
flutter build web --release --no-tree-shake-icons
