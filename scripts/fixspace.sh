#!/bin/sh
# From https://stackoverflow.com/a/43640405
perl -CSDA -plE 's/[^\S\t]/ /g' ${1}
