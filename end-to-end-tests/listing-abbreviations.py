import pexpect
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)

zsh = pexpect.spawnu('/usr/bin/env zsh --no-rcs',
                     env=os.environ | {'PROMPT': '>'})

# Ready to take a command.
zsh.expect('>')
# Source the plugin and test listing with no abbreviations.
zsh.sendline(
    f"source \"{test_directory}/../zsh-simple-abbreviations.zsh\" && zsh-simple-abbreviations --list")

# Ready to take a command.
zsh.expect('>')
output = zsh.before

# Assert no abbreviations message is shown.
assert "No abbreviations set." in output

# Set some abbreviations.
zsh.sendline("zsh-simple-abbreviations --set GP 'git pull'")
zsh.expect('>')
zsh.sendline("zsh-simple-abbreviations --set GS 'git status'")
zsh.expect('>')

# List abbreviations.
zsh.sendline("zsh-simple-abbreviations --list")
zsh.expect('>')
output = zsh.before

# Assert both abbreviations are listed.
assert "GP -> git pull" in output
assert "GS -> git status" in output

# Done with test close Zsh.
zsh.close()