#! /usr/bin/env bash

HEADER="//\n//  Copyright © {year} FINN.no AS, Inc. All rights reserved.\n//"

command="${SRCROOT}/Others/swiftformat"

OUTPUT=$($command \
--stripunusedargs closure-only \
--header "$HEADER" \
--disable redundantReturn \
*)

if [ "$OUTPUT" ]; then
echo "$OUTPUT" >&2
fi
