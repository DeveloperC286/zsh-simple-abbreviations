FROM python:3.13.6-alpine3.21@sha256:ae6439a27c05140111b240c4ff1ec49c29281470bdde8945a4dfa4ac2fee19f9
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
