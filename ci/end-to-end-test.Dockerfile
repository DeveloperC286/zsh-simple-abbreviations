FROM python:3.13.5-alpine3.21@sha256:716e13ae565fb303ab17959bba89fabce3e69c41ddc59985a9dd941c42baa517
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
