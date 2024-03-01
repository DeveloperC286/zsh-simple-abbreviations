import pexpect
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)

zsh = pexpect.spawnu('/usr/bin/env zsh --no-rcs',
                     env=os.environ | {'PROMPT': '>'})

# Ready to take a command.
zsh.expect('>')
# Source the plugin and add an abbreviation.
zsh.sendline(
    f"source \"{test_directory}/../zsh-simple-abbreviations.zsh\" && zsh-simple-abbreviations --set C 'clear'")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
# Use the abbreviation.
zsh.sendline("echo ZSH_C ")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)

# Assert the abbreviation was expanded to 'hello'.
print(output)
assert "ZSH_clear" not in output

# Done with test close Zsh.
zsh.close()
