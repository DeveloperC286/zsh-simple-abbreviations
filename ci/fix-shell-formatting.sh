#!/usr/bin/env sh

set -o errexit
set -o xtrace

shfmt --simplify --write ./ci/* ./src/* zsh-simple-abbreviations.zsh
