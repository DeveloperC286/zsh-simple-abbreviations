#!/usr/bin/env sh

set -o errexit
set -o xtrace

shfmt --simplify --diff ./ci/* ./src/* zsh-simple-abbreviations.zsh
