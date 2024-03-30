#!/usr/bin/env zsh

# Only run if executed in Zsh environment.
if [[ -n ${ZSH_VERSION} ]]; then
	# Create a new global(-g) abbreviations associative array parameters(-A).
	# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Array-Parameters
	typeset -Ag ZSH_SIMPLE_ABBREVIATIONS

	# Add the src directory to the function path.
	# So we can do `> zsh-simple-abbreviations --set ...` from the CLI.
	fpath+=${0:A:h}/src
	autoload -Uz zsh-simple-abbreviations

	# Create key binding on space to expand into a possible abbreviations.
	autoload -Uz __zsh_simple_abbreviations_expand
	zle -N zsh_simple_abbreviations_expand __zsh_simple_abbreviations_expand
	bindkey " " zsh_simple_abbreviations_expand

	# Create key binding on control + space to insert a space without any possible abbreviations expansion.
	autoload -Uz __zsh_simple_abbreviations_insert_space
	zle -N zsh_simple_abbreviations_insert_space __zsh_simple_abbreviations_insert_space
	bindkey "^ " zsh_simple_abbreviations_insert_space
fi
