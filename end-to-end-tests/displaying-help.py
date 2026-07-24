import pexpect
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)

# Use a wide terminal so the usage line is not wrapped by the pseudo terminal.
zsh = pexpect.spawnu('/usr/bin/env zsh --no-rcs',
                     env=os.environ | {'PROMPT': '>'},
                     dimensions=(24, 200))

# Ready to take a command.
zsh.expect('>')
# Source the plugin.
zsh.sendline(
    f"source \"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh\"")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
# Display the help message.
zsh.sendline("zsh-simple-abbreviations --help")

# Ready to take a command.
zsh.expect('>')
before = before + zsh.before
# Capture the return code of the help sub-command.
zsh.sendline("print -r -- \"HELP_RETURN_CODE:$?:END\"")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)

# Assert every line of the help message is displayed.
assert "Usage: zsh-simple-abbreviations [--set KEY VALUE | --unset KEY | --list | --help]" in output
assert "--set KEY VALUE   Set an abbreviation for KEY to VALUE." in output
assert "--unset KEY       Remove the abbreviation for KEY." in output
assert "--list            List all abbreviations." in output
assert "--help            Display this help message." in output
# Assert the help sub-command is successful.
assert "HELP_RETURN_CODE:0:END" in output

# Done with test close Zsh.
zsh.close()
