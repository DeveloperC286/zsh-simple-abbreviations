DOCKER_RUN_OPTS := --rm -v $(PWD):/workspace -w /workspace

UID := $(shell id -u)
GID := $(shell id -g)
DOCKER_RUN_WRITE_OPTS := $(DOCKER_RUN_OPTS) -u $(UID):$(GID)

.PHONY: default
default: end-to-end-test

# renovate: depName=ghcr.io/developerc286/clean_git_history
CLEAN_GIT_HISTORY_VERSION=1.0.4@sha256:5783341a3377a723e409e72b9ec0826a75ba944288d030978355de05ef65b186

.PHONY: check-clean-git-history
check-clean-git-history:
	docker run $(DOCKER_RUN_WRITE_OPTS) ghcr.io/developerc286/clean_git_history:$(CLEAN_GIT_HISTORY_VERSION) $(FROM)

# renovate: depName=ghcr.io/developerc286/conventional_commits_linter
CONVENTIONAL_COMMITS_LINTER_VERSION=0.15.0@sha256:b631a3cdcbed28c8938a2a6b63e16ecfd0d7ff71c28e878815adf9183e1fb599

.PHONY: check-conventional-commits-linting
check-conventional-commits-linting:
	docker run $(DOCKER_RUN_WRITE_OPTS) ghcr.io/developerc286/conventional_commits_linter:$(CONVENTIONAL_COMMITS_LINTER_VERSION) --allow-angular-type-only $(FROM)

.PHONY: check-python-formatting
check-python-formatting:
	docker build -t check-python-formatting -f ci/check-python-formatting.Dockerfile .
	docker run $(DOCKER_RUN_OPTS) check-python-formatting

# renovate: depName=mvdan/shfmt
SHFMT_VERSION=v3.11.0-alpine@sha256:394d755b6007056a2e6d7537ccdbdcfca01b9855ba91e99df0166ca039c9d422

.PHONY: check-shell-formatting
check-shell-formatting:
	docker run $(DOCKER_RUN_OPTS) mvdan/shfmt:$(SHFMT_VERSION) --simplify --diff ./ci/* ./src/* zsh-simple-abbreviations.zsh

# renovate: depName=ghcr.io/google/yamlfmt
YAMLFMT_VERSION=0.17.2@sha256:fa6874890092db69f35ece6a50e574522cae2a59b6148a1f6ac6d510e5bcf3cc

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
ACTIONLINT_VERSION=1.7.7@sha256:887a259a5a534f3c4f36cb02dca341673c6089431057242cdc931e9f133147e9

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
