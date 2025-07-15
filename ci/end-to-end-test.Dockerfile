FROM python:3.13.5-alpine3.21@sha256:6a5f50aba058538dc0098afd77fa264b7382972d8457df5d940355132e27253a
RUN apk add --no-cache zsh=5.9-r4

COPY end-to-end-tests/requirements.txt ./
RUN pip3 install -r requirements.txt

WORKDIR /workspace

ENTRYPOINT ["python3"]
