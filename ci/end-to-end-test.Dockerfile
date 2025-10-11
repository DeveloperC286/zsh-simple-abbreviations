FROM python:3.14.0-alpine3.21@sha256:f1ac9e01293a18a24919826ea8c7bb8f7bbc25497887a0a1cade58801bb83d1c
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
