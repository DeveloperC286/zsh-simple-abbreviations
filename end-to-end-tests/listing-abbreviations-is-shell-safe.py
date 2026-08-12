import os

import pexpect

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
zsh.sendline("zsh-simple-abbreviations --set glog \"git log --format='%h %s'\"")

# Ready to take a command.
zsh.expect('>')
# Set an abbreviation whose value contains a literal backslash, which `echo`
# would interpret as an escape sequence in the --list output.
zsh.sendline("zsh-simple-abbreviations --set grept \"grep -P '\\t'\"")

# Ready to take a command.
zsh.expect('>')
# Capture the --list output, forget the abbreviations, then re-source the
# captured output to prove the --list format round-trips exactly.
zsh.sendline("LISTING=$(zsh-simple-abbreviations --list)")

# Ready to take a command.
zsh.expect('>')
zsh.sendline("zsh-simple-abbreviations --unset glog")

# Ready to take a command.
zsh.expect('>')
zsh.sendline("zsh-simple-abbreviations --unset grept")

# Ready to take a command.
zsh.expect('>')
zsh.sendline("eval \"$LISTING\"")

# Ready to take a command.
zsh.expect('>')
before = zsh.after
# Use `print -r --` so the verification output itself does not mangle the
# backslash we are checking for.
zsh.sendline("print -r -- \"ROUNDTRIP_glog:${ZSH_SIMPLE_ABBREVIATIONS[glog]}:END\"")

# Ready to take a command.
zsh.expect('>')
before = before + zsh.before
zsh.sendline("print -r -- \"ROUNDTRIP_grept:${ZSH_SIMPLE_ABBREVIATIONS[grept]}:END\"")

# Ready to take a command.
zsh.expect('>')
output = (before + zsh.before)

# Assert both values survived the list-then-re-source round-trip unchanged.
assert "ROUNDTRIP_glog:git log --format='%h %s':END" in output
assert "ROUNDTRIP_grept:grep -P '\\t':END" in output

# Done with test close Zsh.
zsh.close()
