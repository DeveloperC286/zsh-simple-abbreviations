DOCKER_RUN_OPTS := --rm -v $(PWD):/workspace -w /workspace

UID := $(shell id -u)
GID := $(shell id -g)
DOCKER_RUN_WRITE_OPTS := $(DOCKER_RUN_OPTS) -u $(UID):$(GID)

.PHONY: default
default: end-to-end-test

# renovate: depName=ghcr.io/developerc286/clean_git_history
CLEAN_GIT_HISTORY_VERSION=1.1.5@sha256:b1374591d48393f6b5fcc888f6bc7da05f7d218961f7850112130b1cad78186a

.PHONY: check-clean-git-history
check-clean-git-history:
	docker run $(DOCKER_RUN_WRITE_OPTS) ghcr.io/developerc286/clean_git_history:$(CLEAN_GIT_HISTORY_VERSION) $(FROM)

# renovate: depName=ghcr.io/developerc286/conventional_commits_linter
CONVENTIONAL_COMMITS_LINTER_VERSION=0.17.0@sha256:d6fb0dfd79c2e06897692bc3f0dc62bcb7ce90a92030c81a3137935516d525d7

.PHONY: check-conventional-commits-linting
check-conventional-commits-linting:
	docker run $(DOCKER_RUN_WRITE_OPTS) ghcr.io/developerc286/conventional_commits_linter:$(CONVENTIONAL_COMMITS_LINTER_VERSION) --type angular $(FROM)

.PHONY: check-python-formatting
check-python-formatting:
	docker build -t check-python-formatting -f ci/check-python-formatting.Dockerfile .
	docker run $(DOCKER_RUN_OPTS) check-python-formatting

# renovate: depName=mvdan/shfmt
SHFMT_VERSION=v3.12.0-alpine@sha256:204a4d2d876123342ad394bd9a28fb91e165abc03868790d4b39cfa73233f150

.PHONY: check-shell-formatting
check-shell-formatting:
	docker run $(DOCKER_RUN_OPTS) mvdan/shfmt:$(SHFMT_VERSION) --simplify --diff ./ci/* ./src/* zsh-simple-abbreviations.zsh

# renovate: depName=ghcr.io/google/yamlfmt
YAMLFMT_VERSION=0.20.0@sha256:cd11483ba1119371593a7d55386d082da518e27dd932ee00db32e5fb6f3a58c0

.PHONY: check-yaml-formatting
check-yaml-formatting:
	docker run $(DOCKER_RUN_OPTS) ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION) -verbose -lint -dstar .github/workflows/*

.PHONY: fix-python-formatting
fix-python-formatting:
	docker build -t fix-python-formatting -f ci/fix-python-formatting.Dockerfile .
	docker run $(DOCKER_RUN_WRITE_OPTS) fix-python-formatting

.PHONY: fix-shell-formatting
fix-shell-formatting:
	docker run $(DOCKER_RUN_WRITE_OPTS) mvdan/shfmt:$(SHFMT_VERSION) --simplify --write ./ci/* ./src/* zsh-simple-abbreviations.zsh

.PHONY: fix-yaml-formatting
fix-yaml-formatting:
	docker run $(DOCKER_RUN_WRITE_OPTS) ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION) -verbose -dstar .github/workflows/*

# renovate: depName=rhysd/actionlint
ACTIONLINT_VERSION=1.7.10@sha256:ef8299f97635c4c30e2298f48f30763ab782a4ad2c95b744649439a039421e36

.PHONY: check-github-actions-workflows-linting
check-github-actions-workflows-linting:
	docker run $(DOCKER_RUN_OPTS) rhysd/actionlint:$(ACTIONLINT_VERSION) -verbose -color

.PHONY: end-to-end-test
end-to-end-test:
	docker build -t end-to-end-test -f ci/end-to-end-test.Dockerfile .
	docker run $(DOCKER_RUN_OPTS) end-to-end-test end-to-end-tests/abbreviation-finding-ignores-arguments.py
	docker run $(DOCKER_RUN_OPTS) end-to-end-test end-to-end-tests/abbreviation-finding-ignores-environment-variables.py
	docker run $(DOCKER_RUN_OPTS) end-to-end-test end-to-end-tests/setting-abbreviation.py
	docker run $(DOCKER_RUN_OPTS) end-to-end-test end-to-end-tests/unsetting-abbreviation.py
	docker run $(DOCKER_RUN_OPTS) end-to-end-test end-to-end-tests/no-space-does-not-expand-abbreviation.py
	docker run $(DOCKER_RUN_OPTS) end-to-end-test end-to-end-tests/no-abbreviations.py
