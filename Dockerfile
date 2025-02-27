FROM gristlabs/grist:latest

RUN \
  apt update && apt install -y openssl && \
  python3 -m pip install sqids ulid-py