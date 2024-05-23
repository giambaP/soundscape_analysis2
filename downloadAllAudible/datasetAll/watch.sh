#!/bin/sh

watch -n 5 'for dir in YAT1Audible YAT2Audible YAT3Audible; do echo -e "> $dir \n   - files $(find "$dir" -type f | wc -l) \n   - size  $(du -sh "$dir" | cut -f1)"; done'

