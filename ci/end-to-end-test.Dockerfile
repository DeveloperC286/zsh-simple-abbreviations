FROM python:3.13.6-alpine3.21@sha256:5bcbb2a02505d35034426faf87c647adfa7b42c275a21ef0b5014350e99991f0
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
