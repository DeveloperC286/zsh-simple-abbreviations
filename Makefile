# So new files are owned by the user.
UID := $(shell id -u)
GID := $(shell id -g)

.PHONY: check-clean-git-history check-conventional-commits-linting check-python-formatting check-yaml-formatting fix-python-formatting fix-yaml-formatting end-to-end-test check-shell-formatting fix-shell-formatting

# renovate: depName=ghcr.io/developerc286/clean_git_history
CLEAN_GIT_HISTORY_VERSION=1.0.4@sha256:5783341a3377a723e409e72b9ec0826a75ba944288d030978355de05ef65b186

check-clean-git-history:
	docker pull ghcr.io/developerc286/clean_git_history:$(CLEAN_GIT_HISTORY_VERSION)
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/developerc286/clean_git_history:$(CLEAN_GIT_HISTORY_VERSION) $(FROM)

# renovate: depName=ghcr.io/developerc286/conventional_commits_linter
CONVENTIONAL_COMMITS_LINTER_VERSION=0.15.0@sha256:b631a3cdcbed28c8938a2a6b63e16ecfd0d7ff71c28e878815adf9183e1fb599

check-conventional-commits-linting:
	docker pull ghcr.io/developerc286/conventional_commits_linter:$(CONVENTIONAL_COMMITS_LINTER_VERSION)
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/developerc286/conventional_commits_linter:$(CONVENTIONAL_COMMITS_LINTER_VERSION) --allow-angular-type-only $(FROM)

check-python-formatting:
	docker build -t check-python-formatting -f ci/check-python-formatting.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) check-python-formatting

# renovate: depName=mvdan/shfmt
SHFMT_VERSION=v3.11.0-alpine@sha256:394d755b6007056a2e6d7537ccdbdcfca01b9855ba91e99df0166ca039c9d422

check-shell-formatting:
	docker pull mvdan/shfmt:$(SHFMT_VERSION)
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) mvdan/shfmt:$(SHFMT_VERSION) --simplify --diff ./ci/* ./src/* zsh-simple-abbreviations.zsh

# renovate: depName=ghcr.io/google/yamlfmt
YAMLFMT_VERSION=0.17.0@sha256:b4ebf4ff064f5bcf779ef4799dad1fc52542e137677699210aea2de2b270e97f

check-yaml-formatting:
	docker pull ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION)
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION) -verbose -lint -dstar .github/workflows/*

fix-python-formatting:
	docker build -t fix-python-formatting -f ci/fix-python-formatting.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) fix-python-formatting

fix-shell-formatting:
	docker pull mvdan/shfmt:$(SHFMT_VERSION)
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) mvdan/shfmt:$(SHFMT_VERSION) --simplify --write ./ci/* ./src/* zsh-simple-abbreviations.zsh

fix-yaml-formatting:
	docker pull ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION)
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION) -verbose -dstar .github/workflows/*

# renovate: depName=rhysd/actionlint
ACTIONLINT_VERSION=1.7.7@sha256:887a259a5a534f3c4f36cb02dca341673c6089431057242cdc931e9f133147e9

check-github-actions-workflows-linting:
	docker pull rhysd/actionlint:$(ACTIONLINT_VERSION)
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) rhysd/actionlint:$(ACTIONLINT_VERSION) -verbose -color

end-to-end-test:
	docker build -t end-to-end-test -f ci/end-to-end-test.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/abbreviation-finding-ignores-arguments.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/abbreviation-finding-ignores-environment-variables.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/setting-abbreviation.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/unsetting-abbreviation.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/no-space-does-not-expand-abbreviation.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/no-abbreviations.py
