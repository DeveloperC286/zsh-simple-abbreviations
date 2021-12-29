#!/usr/bin/env zsh

if [[ -n $ZSH_VERSION ]]; then
		# Create new abbreviations map.
		typeset -Ag _zsh_simple_abbreviations

		fpath+=${0:A:h}/src
		autoload -Uz zsh-simple-abbreviations

		# Create key binding on space to expand into a possible abbreviations.
		zle -N __zsh_simple_abbreviations::expand
		bindkey " "    __zsh_simple_abbreviations::expand

		# Create key binding on control + space to insert a space without any possible abbreviations expansion.
		zle -N __zsh_simple_abbreviations::insert_space
		bindkey "^ "    __zsh_simple_abbreviations::insert_space
fi
