#!/usr/bin/env bash
# Full lab post-change ritual: codegen then verify.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
"$DIR/codegen.sh"
"$DIR/verify.sh"
