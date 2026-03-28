#!/bin/bash

input=$1
output=$2

awk '
BEGIN { RS=">"; ORS="" }
NR>1 {
    gsub(/\r/, "", $0)
    n = split($0, lines, "\n")

    header = lines[1]
    sub(/\/.*/, "", header)
    sub(/ .*/, "", header)

    seq=""
    for(i=2;i<=n;i++){
        seq=seq lines[i]
    }

    print ">" header "\n" seq "\n"
}
' "$input" > "$output"


