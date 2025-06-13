FROM python:3.13.5-alpine3.21@sha256:c9a09c45a4bcc618c7f7128585b8dd0d41d0c31a8a107db4c8255ffe0b69375d
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
