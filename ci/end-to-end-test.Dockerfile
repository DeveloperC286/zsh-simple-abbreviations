FROM python:3.14.0-alpine3.21@sha256:a9bf2b3856bc05b63ee77a83af8b38b4378135e8bce3c5f7455252fa2ac5abe4
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
