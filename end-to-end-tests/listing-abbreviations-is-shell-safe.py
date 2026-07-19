import pexpect
import os


full_path = os.path.realpath(__file__)
test_directory = os.path.dirname(full_path)

zsh = pexpect.spawnu('/usr/bin/env zsh --no-rcs',
                     env=os.environ | {'PROMPT': '>'})

# Ready to take a command.
zsh.expect('>')
# Source the plugin.
zsh.sendline(f"source \"{test_directory}/../result/share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh\"")

# Ready to take a command.
zsh.expect('>')
# Set an abbreviation whose value contains a single quote, which would break
# naive '...' quoting in the --list output.
zsh.sendline("zsh-simple-abbreviations --set F \"echo it's\"")

# Ready to take a command.
zsh.expect('>')
# Capture the --list output, forget the abbreviation, then re-source the
# captured output to prove the --list format round-trips exactly.
zsh.sendline("LISTING=$(zsh-simple-abbreviations --list)")

# Ready to take a command.
zsh.expect('>')
zsh.sendline("zsh-simple-abbreviations --unset F")

# Ready to take a command.
zsh.expect('>')
zsh.sendline("eval \"$LISTING\"")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
zsh.sendline("echo \"ROUNDTRIP:${ZSH_SIMPLE_ABBREVIATIONS[F]}:END\"")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)

# Assert the value survived the list-then-re-source round-trip unchanged.
assert "ROUNDTRIP:echo it's:END" in output

# Done with test close Zsh.
zsh.close()
