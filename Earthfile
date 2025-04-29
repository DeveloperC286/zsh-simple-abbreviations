VERSION 0.7


COPY_CI_DATA:
    COMMAND
    COPY --dir "ci/" ".github/" "./"


COPY_METADATA:
    COMMAND
    DO +COPY_CI_DATA
    COPY --dir ".git/" "./"


alpine-base:
    FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
    # renovate: datasource=repology depName=alpine_3_21/bash versioning=loose
    ENV BASH_VERSION="5.2.37-r0"
    RUN apk add --no-cache bash=$BASH_VERSION
    WORKDIR "/zsh-simple-abbreviations"


check-clean-git-history:
    FROM +alpine-base
    # renovate: datasource=github-releases depName=DeveloperC286/clean_git_history
    ENV CLEAN_GIT_HISTORY_VERSION="v1.0.1"
    RUN wget -O - "https://github.com/DeveloperC286/clean_git_history/releases/download/${CLEAN_GIT_HISTORY_VERSION}/x86_64-unknown-linux-musl.tar.gz" | tar xz --directory "/usr/bin/"
    DO +COPY_METADATA
    ARG from="origin/HEAD"
    RUN ./ci/check-clean-git-history.sh "${from}"


check-conventional-commits-linting:
    FROM +alpine-base
    # renovate: datasource=github-releases depName=DeveloperC286/conventional_commits_linter
    ENV CONVENTIONAL_COMMITS_LINTER_VERSION="v0.14.3"
    RUN wget -O - "https://github.com/DeveloperC286/conventional_commits_linter/releases/download/${CONVENTIONAL_COMMITS_LINTER_VERSION}/x86_64-unknown-linux-musl.gz" | gzip -d > /usr/bin/conventional_commits_linter && chmod 755 /usr/bin/conventional_commits_linter
    DO +COPY_METADATA
    ARG from_reference="origin/HEAD"
    RUN ./ci/check-conventional-commits-linting.sh --from-reference "${from_reference}"


COPY_SOURCECODE:
    COMMAND
    DO +COPY_CI_DATA
    COPY --dir "zsh-simple-abbreviations.zsh" "src/" "end-to-end-tests/" "./"


python-base:
    FROM +alpine-base
    # renovate: datasource=repology depName=alpine_3_21/python3 versioning=loose
    ENV PYTHON_VERSION="3.12.10-r0"
    # renovate: datasource=repology depName=alpine_3_21/py3-pip versioning=loose
    ENV PIP_VERSION="24.3.1-r0"
    # renovate: datasource=repology depName=alpine_3_21/zsh versioning=loose
    ENV ZSH_VERSION="5.9-r4"
    RUN apk add --no-cache py3-pip=$PIP_VERSION python3=$PYTHON_VERSION zsh=$ZSH_VERSION
    DO +COPY_SOURCECODE
    RUN pip3 install -r end-to-end-tests/requirements.txt --break-system-packages


check-python-formatting:
    FROM +python-base
    RUN ./ci/check-python-formatting.sh


golang-base:
    FROM golang:1.24.2@sha256:f52b85c1b58271ba213ac59878c4fe2fdbb41ac842c5c69f9e7a9d16d53c4ad8
    WORKDIR "/zsh-simple-abbreviations"


shell-formatting-base:
    FROM +golang-base
    # renovate: datasource=github-releases depName=mvdan/sh
    ENV SHFMT_VERSION="v3.11.0"
    RUN go install mvdan.cc/sh/v3/cmd/shfmt@$SHFMT_VERSION
    DO +COPY_SOURCECODE


check-shell-formatting:
    FROM +shell-formatting-base
    RUN ./ci/check-shell-formatting.sh


yaml-formatting-base:
    FROM +golang-base
    # renovate: datasource=github-releases depName=google/yamlfmt
    ENV YAMLFMT_VERSION="v0.16.0"
    RUN go install github.com/google/yamlfmt/cmd/yamlfmt@$YAMLFMT_VERSION
    COPY ".yamlfmt" "./"
    DO +COPY_CI_DATA


check-yaml-formatting:
    FROM +yaml-formatting-base
    RUN ./ci/check-yaml-formatting.sh


check-formatting:
    BUILD +check-python-formatting
    BUILD +check-shell-formatting
    BUILD +check-yaml-formatting


fix-python-formatting:
    FROM +python-base
    RUN ./ci/fix-python-formatting.sh
    SAVE ARTIFACT "end-to-end-tests/" AS LOCAL "./"


fix-shell-formatting:
    FROM +shell-formatting-base
    RUN ./ci/fix-shell-formatting.sh
    SAVE ARTIFACT "ci/" AS LOCAL "./"
    SAVE ARTIFACT "src/" AS LOCAL "./"
    SAVE ARTIFACT "zsh-simple-abbreviations.zsh" AS LOCAL "./"


fix-yaml-formatting:
    FROM +yaml-formatting-base
    RUN ./ci/fix-yaml-formatting.sh
    SAVE ARTIFACT ".github/" AS LOCAL "./"


fix-formatting:
    BUILD +fix-python-formatting
    BUILD +fix-shell-formatting
    BUILD +fix-yaml-formatting


check-shell-linting:
    FROM +alpine-base
    # renovate: datasource=repology depName=alpine_3_21/shellcheck versioning=loose
    ENV SHELLCHECK_VERSION="0.10.0-r1"
    RUN apk add --no-cache shellcheck=$SHELLCHECK_VERSION
    DO +COPY_SOURCECODE
    RUN ./ci/check-shell-linting.sh


check-github-actions-workflows-linting:
    FROM +golang-base
    # renovate: datasource=github-releases depName=rhysd/actionlint
    ENV ACTIONLINT_VERSION="v1.7.7"
    RUN go install github.com/rhysd/actionlint/cmd/actionlint@$ACTIONLINT_VERSION
    DO +COPY_CI_DATA
    RUN ./ci/check-github-actions-workflows-linting.sh


check-linting:
    BUILD +check-shell-linting
    BUILD +check-github-actions-workflows-linting


e2e-test:
    BUILD +abbreviation-finding-ignores-arguments-e2e-test
    BUILD +abbreviation-finding-ignores-environment-variables-e2e-test
    BUILD +setting-abbreviation-e2e-test
    BUILD +unsetting-abbreviation-e2e-test
    BUILD +no-space-does-not-expand-abbreviation-e2e-test
    BUILD +no-abbreviations-e2e-test


abbreviation-finding-ignores-arguments-e2e-test:
    FROM +python-base
    RUN python3 end-to-end-tests/abbreviation-finding-ignores-arguments.py


abbreviation-finding-ignores-environment-variables-e2e-test:
    FROM +python-base
    RUN python3 end-to-end-tests/abbreviation-finding-ignores-environment-variables.py


setting-abbreviation-e2e-test:
    FROM +python-base
    RUN python3 end-to-end-tests/setting-abbreviation.py


unsetting-abbreviation-e2e-test:
    FROM +python-base
    RUN python3 end-to-end-tests/unsetting-abbreviation.py


no-space-does-not-expand-abbreviation-e2e-test:
    FROM +python-base
    RUN python3 end-to-end-tests/no-space-does-not-expand-abbreviation.py


no-abbreviations-e2e-test:
    FROM +python-base
    RUN python3 end-to-end-tests/no-abbreviations.py
