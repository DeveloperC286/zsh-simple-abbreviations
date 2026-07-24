import subprocess
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)
plugin = f"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"

# Every way of failing, one per error message the CLI can produce.
FAILING_INVOCATIONS = [
    "zsh-simple-abbreviations",
    "zsh-simple-abbreviations --set KEY",
    "zsh-simple-abbreviations --set 'BAD-KEY' 'git pull'",
    "zsh-simple-abbreviations --unset KEY EXTRA",
    "zsh-simple-abbreviations --unset 'BAD-KEY'",
    "zsh-simple-abbreviations --list EXTRA",
    "zsh-simple-abbreviations --nope",
]


def run(script):
    """Source the plugin in a non-interactive Zsh, then run the script.

    Returns the completed process so the exit code, standard output and
    standard error can each be asserted upon separately.
    """
    return subprocess.run(['/usr/bin/env', 'zsh', '--no-rcs', '-c', f"source \"{plugin}\"\n{script}"],
                          capture_output=True, text=True)


for invocation in FAILING_INVOCATIONS:
    completed = run(invocation)
    # Assert the error goes to standard error, leaving standard output empty so
    # scripts consuming the CLI's output never capture error text.
    assert completed.stdout == "", invocation
    assert completed.stderr != "", invocation
    # Assert the error names the command as it is actually invoked, hyphenated,
    # rather than the underscored function-style spelling.
    assert completed.stderr.startswith("zsh-simple-abbreviations "), invocation
    assert "zsh_simple_abbreviations" not in completed.stderr, invocation

# Assert a command substitution capturing a failed listing captures nothing, as
# the error text is on standard error rather than in the captured output.
completed = run("""LISTING=$(zsh-simple-abbreviations --list EXTRA 2>/dev/null)
print -r -- "LISTING:${LISTING}:END\"""")
assert completed.returncode == 0
assert completed.stdout == "LISTING::END\n"

# Assert discarding standard error silences the CLI entirely on failure, which
# is only true when nothing is written to standard output.
for invocation in FAILING_INVOCATIONS:
    completed = run(f"{invocation} 2>/dev/null")
    assert completed.returncode == 1, invocation
    assert completed.stdout == "", invocation
    assert completed.stderr == "", invocation
