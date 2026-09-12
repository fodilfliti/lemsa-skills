#!/usr/bin/env bash
# Seed Lab S01–S12 bd issues with dependencies. Run from repo root after `bd init --quiet`.
set -euo pipefail

create() {
  bd create "$1" -t task -p 1 --json | jq -r '.id'
}

S01=$(create "Lab S01: core failures")
S02=$(create "Lab S02: page harness")
S03=$(create "Lab S03: task list flow")
S04=$(create "Lab S04: task form flow")
S05=$(create "Lab S05: mock backend")
S06=$(create "Lab S06: supabase path")
S07=$(create "Lab S07: drift path")
S08=$(create "Lab S08: firebase path")
S09=$(create "Lab S09: nav + auth guard")
S10=$(create "Lab S10: i18n")
S11=$(create "Lab S11: retrofit path")
S12=$(create "Lab S12: loon path")

bd dep add "$S02" "$S01" --type blocks
bd dep add "$S03" "$S02" --type blocks
bd dep add "$S04" "$S03" --type blocks
bd dep add "$S05" "$S04" --type blocks
bd dep add "$S06" "$S05" --type blocks
bd dep add "$S07" "$S05" --type blocks
bd dep add "$S08" "$S05" --type blocks
bd dep add "$S09" "$S05" --type blocks
bd dep add "$S10" "$S04" --type blocks
bd dep add "$S11" "$S05" --type blocks
bd dep add "$S12" "$S05" --type blocks

echo "Seeded S01=$S01 … S12=$S12"
