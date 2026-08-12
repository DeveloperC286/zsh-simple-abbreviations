import subprocess
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)
plugin = f"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"

# Sub-commands which are not supported, including near misses of the supported
# ones such as the wrong case, a missing dash or a typo.
UNRECOGNISED_SUB_COMMANDS = ["--nope", "--sett", "set", "unset", "list", "-s", "-l", "--SET", "--LIST", "help", "-"]


def run(script):
    """Source the plugin in a non-interactive Zsh, then run the script.

    Returns the completed process so the exit code, standard output and
    standard error can each be asserted upon separately.
    """
    return subprocess.run(['/usr/bin/env', 'zsh', '--no-rcs', '-c', f"source \"{plugin}\"\n{script}"],
                          capture_output=True, text=True)


# Every unrecognised sub-command is an error.
for sub_command in UNRECOGNISED_SUB_COMMANDS:
    completed = run(f"zsh-simple-abbreviations {sub_command}")
    assert completed.returncode == 1, sub_command
    assert completed.stdout == "", sub_command
    assert completed.stderr == "zsh-simple-abbreviations unrecognised sub-command.\n", sub_command

# The arguments after an unrecognised sub-command do not change the rejection.
completed = run("zsh-simple-abbreviations --nope KEY VALUE")
assert completed.returncode == 1
assert completed.stdout == ""
assert completed.stderr == "zsh-simple-abbreviations unrecognised sub-command.\n"

# An unrecognised sub-command does not modify the abbreviations.
completed = run("""zsh-simple-abbreviations --set GP 'git pull'
zsh-simple-abbreviations set GS 'git status' 2>/dev/null
zsh-simple-abbreviations --list""")
assert completed.returncode == 0
assert completed.stdout == "zsh-simple-abbreviations --set GP 'git pull'\n"
