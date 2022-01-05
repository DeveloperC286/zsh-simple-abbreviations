# Zsh Simple Abbreviations
[![pipeline status](https://img.shields.io/badge/Version-0.3.0-blue)](https://gitlab.com/DeveloperC/zsh-simple-abbreviations/commits/main)
[![pipeline status](https://gitlab.com/DeveloperC/zsh-simple-abbreviations/badges/main/pipeline.svg)](https://gitlab.com/DeveloperC/zsh-simple-abbreviations/commits/main)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org) [![License: AGPL v3](https://img.shields.io/badge/License-AGPLv3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)


A simple manager for abbreviations in Z shell (Zsh).


## What is an abbreviation?
Abbreviations are a concept inspired by the fish shell. They are very similar to aliases, being used to reference commands in order to reduce keystrokes and improve efficiency.

The difference between aliases and abbreviations are that aliases are left in place and reference commands, where as abbreviations are replaced with the commands they reference.

E.g.

### Aliases
```
alias GP="git pull"
```

If you create an alias called `GP` standing for `git pull`.

```
GP<enter>
```

And you type `GP` and hit enter the alias will be looked up behind the scenes and the command `git pull` will be executed.

### Abbreviations
```
zsh-simple-abbreviations --add GP "git pull"
```

If you create an abbreviation called `GP` standing for `git pull`.

```
GP<space>
```

And you type `GP` followed by a space.

```
git pull<space>
```

The command referenced by the abbreviation will be inlined into the place of the abbreviation.
Now when you hit enter to execute the command nothing is being looked up/processed behind the scenes.


## Why use abbreviations over aliases?
### 1. Know what is actual being executed.
When you hit enter you do not have to guess what is being executed and hope something in your command will not be misinterpreted.
Because abbreviations inline the referenced commands, therefore you will never be surprised by what is actually being executed.

### 2. Accurate history.
Because abbreviations inline the referenced commands your history now accurately stores exactly what was executed at the time.
Where as if you change an alias, your history no longer matches what was actually executed.

### 3. Enable collaboration.
If you are collaborating with others and they are viewing your terminal, your custom aliases will seem like magic; they have no idea what `GRM` means or does.
However, if you are using abbreviations it will be inlined to `git rebase master` and others will not have to guess what you are doing.


## Why use zsh-simple-abbreviations?
zsh-simple-abbreviations is a simple manager for abbreviations with a minimal but useful set of features.


## Content
 * [Usage](#usage)
   + [Usage - Add abbreviation](#usage-add-abbreviation)
   + [Usage - Remove abbreviation](#usage-remove-abbreviation)
   + [Usage - List abbreviations](#usage-list-abbreviations)
   + [Usage - Insert space and do not expand](#usage-insert-space-and-do-not-expand)
 * [Installation](#installation)
   + [Installation - Standalone](#installation-standalone)
   + [Installation - oh-my-minimal](#installation-oh-my-minimal)
 * [Issues/Feature Requests](#issuesfeature-requests)


## Usage
### Usage - Add abbreviation
```
zsh-simple-abbreviations --add <abbreviation> <command abbreviation expands to>
```

E.g.
```
zsh-simple-abbreviations --add GP "git pull"
```

### Usage - Remove abbreviation
```
zsh-simple-abbreviations --remove <abbreviation>
```

E.g.
```
zsh-simple-abbreviations --remove GP
```

### Usage - List abbreviations
```
zsh-simple-abbreviations --list
```

### Usage - Insert space and do not expand
If you want to insert a space and not expand the any abbreviations to the left of the cursor then simply use control plus space to insert a space.


## Installation
### Installation - Standalone
You first need to clone zsh-simple-abbreviations.

```
git clone https://gitlab.com/DeveloperC/zsh-simple-abbreviations/ "${HOME}/.zsh-simple-abbreviations"
```

Then in your `.zshrc` you need to source zsh-simple-abbreviations, before you can add, remove and use abbreviations.

```
source "${HOME}/.zsh-simple-abbreviations/zsh-simple-abbreviations.zsh"
```

### Installation - oh-my-minimal
zsh-simple-abbreviations is included as part of oh-my-minimal see [https://gitlab.com/DeveloperC/oh-my-minimal](https://gitlab.com/DeveloperC/oh-my-minimal) for more information.


## Issues/Feature Requests
To report a bug/issue or request a new feature use [https://gitlab.com/DeveloperC/zsh-simple-abbreviations/-/issues](https://gitlab.com/DeveloperC/zsh-simple-abbreviations/-/issues).
