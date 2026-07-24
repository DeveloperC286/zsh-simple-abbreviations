import subprocess
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)
plugin = f"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"

# Options a user could set in their .zshrc which change parameter and array
# semantics, individually and all together.
SHELL_OPTIONS = ["ksh_arrays", "nounset", "sh_word_split", "ksh_glob", "ksh_arrays nounset sh_word_split"]


def run(script):
    """Source the plugin in a non-interactive Zsh, then run the script.

    Returns the completed process so the exit code, standard output and
    standard error can each be asserted upon separately.
    """
    return subprocess.run(['/usr/bin/env', 'zsh', '--no-rcs', '-c', f"source \"{plugin}\"\n{script}"],
                          capture_output=True, text=True)


for options in SHELL_OPTIONS:
    # Assert setting and listing are unaffected by the caller's options, rather
    # than mangling the key and value as `ksh_arrays` subscripting would.
    completed = run(f"""setopt {options}
zsh-simple-abbreviations --set GP 'git pull'
zsh-simple-abbreviations --list""")
    assert completed.returncode == 0, options
    assert completed.stderr == "", options
    assert completed.stdout == "zsh-simple-abbreviations --set GP 'git pull'\n", options

    # Assert unsetting is unaffected by the caller's options.
    completed = run(f"""setopt {options}
zsh-simple-abbreviations --set GP 'git pull'
zsh-simple-abbreviations --unset GP
zsh-simple-abbreviations --list""")
    assert completed.returncode == 0, options
    assert completed.stderr == "", options
    assert completed.stdout == "", options

    # Assert the error paths are unaffected by the caller's options.
    completed = run(f"""setopt {options}
zsh-simple-abbreviations --set 'BAD-KEY' 'git pull'""")
    assert completed.returncode == 1, options
    assert completed.stdout == "", options
    assert completed.stderr == "zsh-simple-abbreviations key 'BAD-KEY' contains non-alphanumeric characters.\n", options

# The options are reset only for the duration of the call, so the caller's
# options are still set once the CLI returns.
completed = run("""setopt ksh_arrays nounset sh_word_split
zsh-simple-abbreviations --set GP 'git pull'
[[ -o ksh_arrays && -o nounset && -o sh_word_split ]] && print -r -- 'OPTIONS_RESTORED'""")
assert completed.returncode == 0
assert completed.stderr == ""
assert completed.stdout == "OPTIONS_RESTORED\n"
