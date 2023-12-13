#!/bin/sh
# GNU All-Permissive License
# From https://opensource.com/article/21/9/sed-replace-smart-quotes
SED=$(which sed)
SDQUO=$(echo -ne '\u2018\u2019')
RDQUO=$(echo -ne '\u201C\u201D')
$SED -i -e "s/[$SDQUO]/\'/g" -e "s/[$RDQUO]/\"/g" "${1}"
