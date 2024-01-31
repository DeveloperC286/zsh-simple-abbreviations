VERSION 0.7


COPY_CI_DATA:
    COMMAND
    COPY "./ci" "./ci"
    COPY ".github" ".github"


COPY_METADATA:
    COMMAND
    DO +COPY_CI_DATA
    COPY ".git" ".git"


rust-base:
    FROM rust:1.70.0


check-clean-git-history:
    FROM +rust-base
    RUN cargo install clean_git_history --version 0.1.2
    DO +COPY_METADATA
    ARG from_reference="origin/HEAD"
    RUN ./ci/check-clean-git-history.sh --from-reference "${from_reference}"


golang-base:
    FROM golang:1.20.13
    ENV GOPROXY=direct
    ENV CGO_ENABLED=0
    ENV GOOS=linux
    ENV GOARCH=amd64


shell-formatting-base:
    FROM +golang-base
	RUN go install mvdan.cc/sh/v3/cmd/shfmt@v3.7.0
    DO +COPY_CI_DATA


check-shell-formatting:
    FROM +shell-formatting-base
    RUN ./ci/check-shell-formatting.sh


yaml-formatting-base:
    FROM +golang-base
	RUN go install github.com/google/yamlfmt/cmd/yamlfmt@v0.10.0
    COPY ".yamlfmt" ".yamlfmt"
    DO +COPY_CI_DATA

check-yaml-formatting:
    FROM +yaml-formatting-base
    RUN ./ci/check-yaml-formatting.sh


check-formatting:
    BUILD +check-shell-formatting
    BUILD +check-yaml-formatting


fix-shell-formatting:
    FROM +sh-formatting-base
    RUN ./ci/fix-shell-formatting.sh
    SAVE ARTIFACT "./ci" AS LOCAL "./ci"


fix-yaml-formatting:
    FROM +yaml-formatting-base
    RUN ./ci/fix-yaml-formatting.sh
    SAVE ARTIFACT "./.github" AS LOCAL "./.github"


fix-formatting:
    BUILD +fix-shell-formatting
    BUILD +fix-yaml-formatting


check-conventional-commits-linting:
    FROM +rust-base
    RUN cargo install conventional_commits_linter --version 0.12.3
    DO +COPY_METADATA
    ARG from_reference="origin/HEAD"
    RUN ./ci/check-conventional-commits-linting.sh --from-reference "${from_reference}"


check-github-actions-workflows-linting:
    FROM +golang-base
    RUN go install github.com/rhysd/actionlint/cmd/actionlint@v1.6.26
    DO +COPY_CI_DATA
    RUN ./ci/check-github-actions-workflows-linting.sh
