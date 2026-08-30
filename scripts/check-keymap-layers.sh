#!/usr/bin/env bash
# Sanity check: every layer in a .keymap should bind the same number of keys.
# Catches a dropped/duplicated row after editing shared row macros, before
# spending a `west build` cycle on it.
#
# Usage: scripts/check-keymap-layers.sh config/velvet_v3_ui_ruen.keymap
set -euo pipefail

keymap="$1"
dir="$(cd "$(dirname "$keymap")" && pwd)"
file="$(basename "$keymap")"

stubs="$(mktemp -d)"
trap 'rm -rf "$stubs"' EXIT

# ZMK/Zephyr headers referenced via #include <...> aren't vendored in this
# repo (they come from the zmk/zephyr west modules); stub them out. We only
# need macro/token *shape*, not their expansions, to count bindings per layer.
for h in \
    dt-bindings/zmk/input_transform.h \
    dt-bindings/zmk/bt.h \
    dt-bindings/zmk/keys.h \
    dt-bindings/zmk/outputs.h \
    dt-bindings/zmk/pointing.h \
    dt-bindings/zmk/hid_usage.h \
    dt-bindings/zmk/hid_usage_pages.h \
    dt-bindings/zmk/modifiers.h \
    zephyr/dt-bindings/input/input-event-codes.h \
    input/processors.dtsi \
    behaviors.dtsi; do
    mkdir -p "$stubs/$(dirname "$h")"
    : > "$stubs/$h"
done

preproc="$stubs/out.txt"
(cd "$dir" && gcc -E -P -x assembler-with-cpp -I "$stubs" "$file") > "$preproc"

python3 - "$preproc" <<'EOF'
import re
import sys

with open(sys.argv[1]) as f:
    text = f.read()

layer_pattern = re.compile(r'(\w+)\s*\{\s*bindings\s*=\s*<(.*?)>;', re.S)
counts = {}
for m in layer_pattern.finditer(text):
    name, body = m.group(1), m.group(2)
    tokens = re.findall(r'&\w+', body)
    # combos bind a single macro, not a full layer - skip those
    if len(tokens) <= 2:
        continue
    counts[name] = len(tokens)

if not counts:
    print("No layers found - check the file path / preprocessing.")
    sys.exit(1)

expected = max(set(counts.values()), key=list(counts.values()).count)
mismatched = {n: c for n, c in counts.items() if c != expected}

for name, count in counts.items():
    flag = "  <-- MISMATCH" if name in mismatched else ""
    print(f"{name:12s} {count:3d} bindings{flag}")

if mismatched:
    print(f"\nExpected {expected} bindings per layer (majority), "
          f"{len(mismatched)} layer(s) differ.")
    sys.exit(1)

print(f"\nAll {len(counts)} layers have {expected} bindings. OK.")
EOF
