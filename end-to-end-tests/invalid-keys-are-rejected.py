import subprocess
import shlex
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)
plugin = f"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"

# Keys the alphanumeric key regex must reject, including the empty key.
INVALID_KEYS = ["BAD-KEY", "bad key", "bad.key", "bad_key", "key!", "gp/2", "", "$HOME"]


def run(script):
    """Source the plugin in a non-interactive Zsh, then run the script.

    Returns the completed process so the exit code, standard output and
    standard error can each be asserted upon separately.
    """
    return subprocess.run(['/usr/bin/env', 'zsh', '--no-rcs', '-c', f"source \"{plugin}\"\n{script}"],
                          capture_output=True, text=True)


# Setting a non-alphanumeric key is an error naming the offending key.
for key in INVALID_KEYS:
    completed = run(f"zsh-simple-abbreviations --set {shlex.quote(key)} 'git pull'")
    assert completed.returncode == 1, key
    assert completed.stdout == "", key
    assert completed.stderr == f"zsh-simple-abbreviations key '{key}' contains non-alphanumeric characters.\n", key

# Unsetting a non-alphanumeric key is an error naming the offending key.
for key in INVALID_KEYS:
    completed = run(f"zsh-simple-abbreviations --unset {shlex.quote(key)}")
    assert completed.returncode == 1, key
    assert completed.stdout == "", key
    assert completed.stderr == f"zsh-simple-abbreviations key '{key}' contains non-alphanumeric characters.\n", key

# A rejected set leaves the abbreviations untouched, so the listing is empty.
completed = run("""zsh-simple-abbreviations --set BAD-KEY 'git pull' 2>/dev/null
zsh-simple-abbreviations --list""")
assert completed.returncode == 0
assert completed.stdout == ""

# A rejected unset does not remove any existing abbreviation.
completed = run("""zsh-simple-abbreviations --set GP 'git pull'
zsh-simple-abbreviations --unset 'BAD-KEY' 2>/dev/null
zsh-simple-abbreviations --list""")
assert completed.returncode == 0
assert completed.stdout == "zsh-simple-abbreviations --set GP 'git pull'\n"

# Alphanumeric keys of either case, and with digits, are accepted.
for key in ["GP", "gp", "Gp2", "2gp"]:
    completed = run(f"zsh-simple-abbreviations --set {key} 'git pull'")
    assert completed.returncode == 0, key
    assert completed.stdout == "", key
    assert completed.stderr == "", key
