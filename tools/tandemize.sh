#!/bin/bash

awk '/^@/ {current_header=$1} !/^@/ {print ">" current_header "_" ++count[current_header] "\n" $14 $14}' "$1"

