# Zsh Simple Abbreviations
![GitHub Release](https://img.shields.io/github/v/release/DeveloperC286/zsh-simple-abbreviations)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![License](https://img.shields.io/badge/License-AGPLv3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)


A simple manager for abbreviations in Z shell (Zsh).


## What is an abbreviation?
Abbreviations are a concept inspired by the fish shell. They are very similar to aliases, being used to reference commands in order to reduce keystrokes and improve efficiency.

The difference between aliases and abbreviations is that aliases are left in place and reference commands, where as abbreviations are replaced with the commands they reference.

E.g.

### Aliases
```sh
alias GP="git pull"
```

If you create an alias called `GP` standing for `git pull`.

```sh
GP<enter>
```

And you type `GP` and hit enter the alias will be looked up behind the scenes and the command `git pull` will be executed.

### Abbreviations
```sh
zsh-simple-abbreviations --set GP "git pull"
```

If you create an abbreviation called `GP` standing for `git pull`.

```sh
GP<space>
```

And you type `GP` followed by a space.

```sh
git pull<space>
```

The command referenced by the abbreviation will be inlined into the place of the abbreviation.
Now when you hit enter to execute the command nothing is being looked up/processed behind the scenes.


## Why use abbreviations over aliases?
### 1. Know what is actually being executed.
When you hit enter you do not have to guess what is being executed and hope something in your command will not be misinterpreted.
Because abbreviations inline the referenced commands, therefore you will never be surprised by what is actually being executed.

### 2. Accurate history.
Because abbreviations inline the referenced commands your history now accurately stores exactly what was executed at the time.
Whereas if you change an alias, your history no longer matches what was actually executed.

### 3. Enable collaboration.
If you are collaborating with others and they are viewing your terminal, your custom aliases will seem like magic; they have no idea what `GRM` means or does.
However, if you are using abbreviations it will be inlined to `git rebase master` and others will not have to guess what you are doing.


## Why use zsh-simple-abbreviations?
zsh-simple-abbreviations is a simple manager for abbreviations with a minimal but useful set of features.


## Content
 * [Usage](#usage)
   + [Usage - Set an abbreviation](#usage-set-an-abbreviation)
   + [Usage - Unset an abbreviation](#usage-unset-an-abbreviation)
   + [Usage - List abbreviations](#usage-list-abbreviations)
   + [Usage - Insert space and do not expand](#usage-insert-space-and-do-not-expand)
 * [Installation](#installation)
   + [Installation - Nix Home Manager](#installation-nix-home-manager)
   + [Installation - Plugin manager](#installation-plugin-manager)
   + [Installation - Standalone](#installation-standalone)
 * [Issues/Feature Requests](#issuesfeature-requests)


## Usage
### Usage - Set an abbreviation
```sh
zsh-simple-abbreviations --set <abbreviation> <command abbreviation expands to>
```

E.g.
```sh
zsh-simple-abbreviations --set GP "git pull"
```

### Usage - Unset an abbreviation
```sh
zsh-simple-abbreviations --unset <abbreviation>
```

E.g.
```sh
zsh-simple-abbreviations --unset GP
```

### Usage - List abbreviations
```sh
zsh-simple-abbreviations --list
```

### Usage - Insert space and do not expand
If you want to insert a space and not expand any abbreviations to the left of the cursor then simply use control plus space to insert a space.


## Installation
### Installation - Nix Home Manager
My recommended approach is to use Nix Home Manager to set up your overall shell experience declaratively, including installing your Zsh plugins.

Add zsh-simple-abbreviations as a flake input, pinned to the latest release.

<!-- x-release-please-start-version -->
```nix
inputs.zsh-simple-abbreviations.url = "github:DeveloperC286/zsh-simple-abbreviations/v1.2.0";
```
<!-- x-release-please-end -->

Then enable it as a Zsh plugin in your Home Manager configuration.

```nix
programs.zsh.plugins = [
  {
    name = "zsh-simple-abbreviations";
    src = inputs.zsh-simple-abbreviations.packages.${pkgs.system}.default;
    file = "share/zsh-simple-abbreviations/zsh-simple-abbreviations.zsh";
  }
];
```

### Installation - Plugin manager
Alternatively, install zsh-simple-abbreviations with a Zsh plugin manager such as zplug or zinit. This is more adaptable because it makes it easier to add, remove and update plugins.

Using [zplug](https://github.com/zplug/zplug), add the following to your `.zshrc`.

```sh
zplug "DeveloperC286/zsh-simple-abbreviations", use:"zsh-simple-abbreviations.zsh"
```

Using [zinit](https://github.com/zdharma-continuum/zinit), add the following to your `.zshrc`.

```sh
zinit light DeveloperC286/zsh-simple-abbreviations
```

### Installation - Standalone
If you do not use a Zsh plugin manager, you can clone zsh-simple-abbreviations manually.

<!-- x-release-please-start-version -->
```sh
version="1.2.0" && curl -sL "https://github.com/DeveloperC286/zsh-simple-abbreviations/archive/refs/tags/v${version}.tar.gz" | tar xz --directory "/tmp/" && rm -rf "${HOME}/.zsh-simple-abbreviations" && mv "/tmp/zsh-simple-abbreviations-${version}" "${HOME}/.zsh-simple-abbreviations"
```
<!-- x-release-please-end -->

Then in your `.zshrc` you need to source zsh-simple-abbreviations, before you can add, remove and use abbreviations.

```sh
source "${HOME}/.zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"
```


## Issues/Feature Requests
To report a bug/issue or request a new feature use [https://github.com/DeveloperC286/zsh-simple-abbreviations/issues](https://github.com/DeveloperC286/zsh-simple-abbreviations/issues).
