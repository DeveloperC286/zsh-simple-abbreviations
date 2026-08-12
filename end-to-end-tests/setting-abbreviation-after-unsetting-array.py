import os

import pexpect

full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)

zsh = pexpect.spawnu('/usr/bin/env zsh --no-rcs',
                     env=os.environ | {'PROMPT': '>'})

# Ready to take a command.
zsh.expect('>')
# Source the plugin then unset the abbreviations array out from under it, as a
# user could, to check --set does not abort with 'assignment to invalid
# subscript range'.
zsh.sendline(
    f"source \"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh\" && unset ZSH_SIMPLE_ABBREVIATIONS && zsh-simple-abbreviations --set H 'hello'")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
# Use the abbreviation.
zsh.sendline("echo H ")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)

# Assert the abbreviation was set and expanded to 'hello', which only happens if
# --set succeeded rather than aborting on the unset array.
assert "hello" in output

# Done with test close Zsh.
zsh.close()
