import pexpect
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)

zsh = pexpect.spawnu('/usr/bin/env zsh --no-rcs',
                     env=os.environ | {'PROMPT': '>'})

# Ready to take a command.
zsh.expect('>')
# Source the plugin.
zsh.sendline(f"source \"{test_directory}/../zsh-simple-abbreviations.zsh\"")

# Ready to take a command.
zsh.expect('>')
# Set two abbreviations.
zsh.sendline("zsh-simple-abbreviations --set GP 'git pull'")

# Ready to take a command.
zsh.expect('>')
zsh.sendline("zsh-simple-abbreviations --set GS 'git status'")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
# List abbreviations.
zsh.sendline("zsh-simple-abbreviations --list")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)

# Assert both abbreviations are in the output in correct format.
assert "zsh-simple-abbreviations --set GP 'git pull'" in output
assert "zsh-simple-abbreviations --set GS 'git status'" in output

# Done with test close Zsh.
zsh.close()
