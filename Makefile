# So new files are owned by the user.
UID := $(shell id -u)
GID := $(shell id -g)

.PHONY: check-clean-git-history check-conventional-commits-linting check-python-formatting check-yaml-formatting fix-python-formatting fix-yaml-formatting end-to-end-test check-shell-formatting fix-shell-formatting

check-clean-git-history:
	docker build -t check-clean-git-history -f ci/check-clean-git-history.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) check-clean-git-history $(FROM)

check-conventional-commits-linting:
	docker build -t check-conventional-commits-linting -f ci/check-conventional-commits-linting.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) check-conventional-commits-linting $(FROM)

check-python-formatting:
	docker build -t check-python-formatting -f ci/check-python-formatting.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) check-python-formatting

check-shell-formatting:
	docker pull mvdan/shfmt:v3.11.0-alpine
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) mvdan/shfmt:v3.11.0-alpine --simplify --diff ./ci/* ./src/* zsh-simple-abbreviations.zsh

check-yaml-formatting:
	docker pull ghcr.io/google/yamlfmt:0.17.0
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/google/yamlfmt:0.17.0 -verbose -lint -dstar .github/workflows/*

fix-python-formatting:
	docker build -t fix-python-formatting -f ci/fix-python-formatting.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) fix-python-formatting

fix-shell-formatting:
	docker pull mvdan/shfmt:v3.11.0-alpine
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) mvdan/shfmt:v3.11.0-alpine --simplify --write ./ci/* ./src/* zsh-simple-abbreviations.zsh

fix-yaml-formatting:
	docker pull ghcr.io/google/yamlfmt:0.17.0
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/google/yamlfmt:0.17.0 -verbose -dstar .github/workflows/*

check-github-actions-workflows-linting:
	docker pull rhysd/actionlint:1.7.7
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) rhysd/actionlint:1.7.7 -verbose -color

end-to-end-test:
	docker build -t end-to-end-test -f ci/end-to-end-test.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/abbreviation-finding-ignores-arguments.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/abbreviation-finding-ignores-environment-variables.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/setting-abbreviation.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/unsetting-abbreviation.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/no-space-does-not-expand-abbreviation.py
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) end-to-end-test end-to-end-tests/no-abbreviations.py