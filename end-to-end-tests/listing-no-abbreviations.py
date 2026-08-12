import pexpect
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)

zsh = pexpect.spawnu('/usr/bin/env zsh --no-rcs',
                     env=os.environ | {'PROMPT': '>'})

# Ready to take a command.
zsh.expect('>')
# Source the plugin and do not set an abbreviation.
zsh.sendline(
    f"source \"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh\"")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
# List the abbreviations, capturing the output so the assertion is not confused
# by the echoing of the command itself.
zsh.sendline("LISTING=$(zsh-simple-abbreviations --list); RETURN_CODE=$?")

# Ready to take a command.
zsh.expect('>')
before = before + zsh.before
zsh.sendline("print -r -- \"EMPTY_LISTING:${LISTING}:END\"")

# Ready to take a command.
zsh.expect('>')
before = before + zsh.before
# Capture the return code of the list sub-command.
zsh.sendline("print -r -- \"LIST_RETURN_CODE:${RETURN_CODE}:END\"")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)

# Assert listing zero abbreviations outputs nothing.
assert "EMPTY_LISTING::END" in output
# Assert listing zero abbreviations is not an error.
assert "LIST_RETURN_CODE:0:END" in output
assert "zsh-simple-abbreviations list sub-command" not in output
assert "zsh-simple-abbreviations unrecognised sub-command." not in output

# Done with test close Zsh.
zsh.close()
