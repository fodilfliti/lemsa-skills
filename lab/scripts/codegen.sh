#!/usr/bin/env bash
# Regenerate slang + auto_route + drift after i18n or @RoutePage / schema changes.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> flutter pub get"
flutter pub get

echo "==> dart run slang"
dart run slang

echo "==> dart run build_runner build --delete-conflicting-outputs"
dart run build_runner build --delete-conflicting-outputs

echo "Codegen done."
