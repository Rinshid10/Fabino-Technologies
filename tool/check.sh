#!/usr/bin/env bash
# Generates code, then formats, analyzes and tests the project.
# Run from the project root:  bash tool/check.sh
set -e
dart run build_runner build --force-jit
dart fix --apply
dart format lib test
flutter analyze
flutter test
