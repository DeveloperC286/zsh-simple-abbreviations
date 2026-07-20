import pexpect
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)

installation_directory = f"{test_directory}/../result/share/zsh-simple-abbreviations"

# The installation layout every documented install method depends upon; the
# plugin autoloads its functions from the src directory sitting alongside it.
assert os.path.isfile(f"{installation_directory}/zsh-simple-abbreviations.zsh")
assert os.path.isdir(f"{installation_directory}/src")

zsh = pexpect.spawnu('/usr/bin/env zsh --no-rcs',
                     env=os.environ | {'PROMPT': '>'})

# Ready to take a command.
zsh.expect('>')
# Source the plugin from the installation exactly as the instructions describe.
zsh.sendline(
    f"source \"{installation_directory}/zsh-simple-abbreviations.zsh\"")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
# Call the command, proving the function autoloaded from the installed src directory.
zsh.sendline("zsh-simple-abbreviations --help")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)

# Assert sourcing and autoloading from the installation succeeded.
assert "command not found" not in output
assert "Usage:" in output

# Done with test close Zsh.
zsh.close()
