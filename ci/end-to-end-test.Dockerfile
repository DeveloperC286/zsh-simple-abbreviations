FROM python:3.14.0-alpine3.21@sha256:814983b0c51602a3fecc22afaff2321f79b547230020e1428e2d778367e2ffed
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
