#!/usr/bin/env bash
# analyze + test — run after codegen or feature work.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "==> flutter analyze"
flutter analyze

echo "==> flutter test"
flutter test

echo "Verify done."
