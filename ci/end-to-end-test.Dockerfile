FROM python:3.14.0-alpine3.21@sha256:c2410fbf9690a8c4ee6482dd0da61cd0b5ee78bcbd3b3b0855a5295a35da0089
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
