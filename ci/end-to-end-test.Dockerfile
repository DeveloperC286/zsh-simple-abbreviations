FROM python:3.14.1-alpine3.21@sha256:fd8407cacb1028c803566276ae25eb7c2a00fbaa210a0a5670994f6866e29278
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
