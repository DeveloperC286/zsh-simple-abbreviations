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
    f"source \"{test_directory}/../zsh-simple-abbreviations.zsh\"")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
# Run any command.
zsh.sendline("echo hello ")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)
# Assert the expand abbreviation function is not an issue.
assert "zsh: command not found: echohello" not in output
assert "\nhello" in output

# Done with test close Zsh.
zsh.close()
