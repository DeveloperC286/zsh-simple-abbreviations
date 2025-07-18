FROM python:3.13.5-alpine3.21@sha256:763eee4b5cf4dfcfbf76a5a5f8177317ac531c635b855cdc5a95e17fe1e4a44d
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
