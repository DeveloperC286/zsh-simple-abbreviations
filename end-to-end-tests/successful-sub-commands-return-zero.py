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


# Setting an abbreviation succeeds silently.
completed = run("zsh-simple-abbreviations --set GP 'git pull'")
assert completed.returncode == 0
assert completed.stdout == ""
assert completed.stderr == ""

# Unsetting an abbreviation succeeds silently, whether it was set or not.
for script in ["zsh-simple-abbreviations --set GP 'git pull'\nzsh-simple-abbreviations --unset GP",
               "zsh-simple-abbreviations --unset NEVERSET"]:
    completed = run(script)
    assert completed.returncode == 0, script
    assert completed.stdout == "", script
    assert completed.stderr == "", script

# Listing succeeds with no abbreviations set, printing nothing.
completed = run("zsh-simple-abbreviations --list")
assert completed.returncode == 0
assert completed.stdout == ""
assert completed.stderr == ""

# Listing succeeds with abbreviations set, printing them in key order.
completed = run("""zsh-simple-abbreviations --set GS 'git status'
zsh-simple-abbreviations --set GP 'git pull'
zsh-simple-abbreviations --list""")
assert completed.returncode == 0
assert completed.stderr == ""
assert completed.stdout == ("zsh-simple-abbreviations --set GP 'git pull'\n"
                            "zsh-simple-abbreviations --set GS 'git status'\n")

# The help succeeds, documenting every sub-command on standard output.
completed = run("zsh-simple-abbreviations --help")
assert completed.returncode == 0
assert completed.stderr == ""
assert completed.stdout.startswith("Usage: zsh-simple-abbreviations ")
for sub_command in ["--set", "--unset", "--list", "--help"]:
    assert sub_command in completed.stdout, sub_command

# Setting after the abbreviations array has been unset succeeds silently, rather
# than failing on an assignment to an invalid subscript range.
completed = run("""unset ZSH_SIMPLE_ABBREVIATIONS
zsh-simple-abbreviations --set GP 'git pull'""")
assert completed.returncode == 0
assert completed.stdout == ""
assert completed.stderr == ""
