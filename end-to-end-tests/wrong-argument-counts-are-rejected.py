import subprocess
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)
plugin = f"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"


def run(script):
    """Source the plugin in a non-interactive Zsh, then run the script.

    Returns the completed process so the exit code, standard output and
    standard error can each be asserted upon separately.
    """
    return subprocess.run(['/usr/bin/env', 'zsh', '--no-rcs', '-c', f"source \"{plugin}\"\n{script}"],
                          capture_output=True, text=True)


# Calling with no sub-command at all is an error.
completed = run("zsh-simple-abbreviations")
assert completed.returncode == 1
assert completed.stdout == ""
assert completed.stderr == "zsh-simple-abbreviations no sub-command or arguments provided.\n"

# The set sub-command requires exactly a key and a value.
for arguments in ["--set", "--set KEY", "--set KEY VALUE EXTRA"]:
    completed = run(f"zsh-simple-abbreviations {arguments}")
    assert completed.returncode == 1, arguments
    assert completed.stdout == "", arguments
    assert completed.stderr == "zsh-simple-abbreviations set sub-command requires a key and value.\n", arguments

# The unset sub-command requires exactly a key.
for arguments in ["--unset", "--unset KEY EXTRA"]:
    completed = run(f"zsh-simple-abbreviations {arguments}")
    assert completed.returncode == 1, arguments
    assert completed.stdout == "", arguments
    assert completed.stderr == "zsh-simple-abbreviations unset sub-command requires only a key.\n", arguments

# The list sub-command takes no arguments.
for arguments in ["--list EXTRA", "--list KEY VALUE"]:
    completed = run(f"zsh-simple-abbreviations {arguments}")
    assert completed.returncode == 1, arguments
    assert completed.stdout == "", arguments
    assert completed.stderr == "zsh-simple-abbreviations list sub-command takes no other arguments.\n", arguments

# A rejected set does not create an abbreviation and a rejected unset does not
# remove one, so the listing after both still holds only the valid abbreviation.
completed = run("""zsh-simple-abbreviations --set GP 'git pull'
zsh-simple-abbreviations --set GS
zsh-simple-abbreviations --unset GP EXTRA
zsh-simple-abbreviations --list""")
assert completed.stdout == "zsh-simple-abbreviations --set GP 'git pull'\n"
