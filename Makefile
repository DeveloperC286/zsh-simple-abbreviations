.PHONY: default
default: end-to-end-test

.PHONY: check-python-formatting
check-python-formatting:
	autopep8 --exit-code --diff --aggressive --aggressive --max-line-length 120 --recursive end-to-end-tests/

.PHONY: check-yaml-formatting
check-yaml-formatting:
	yamlfmt -verbose -lint -dstar .github/workflows/*

.PHONY: fix-python-formatting
fix-python-formatting:
	autopep8 --in-place --aggressive --aggressive --max-line-length 120 --recursive end-to-end-tests/

.PHONY: fix-yaml-formatting
fix-yaml-formatting:
	yamlfmt -verbose -dstar .github/workflows/*

.PHONY: check-github-actions-workflows-linting
check-github-actions-workflows-linting:
	actionlint -verbose -color

.PHONY: end-to-end-test
end-to-end-test:
	python3 end-to-end-tests/abbreviation-finding-ignores-arguments.py
	python3 end-to-end-tests/abbreviation-finding-ignores-environment-variables.py
	python3 end-to-end-tests/setting-abbreviation.py
	python3 end-to-end-tests/unsetting-abbreviation.py
	python3 end-to-end-tests/no-space-does-not-expand-abbreviation.py
	python3 end-to-end-tests/no-abbreviations.py
