FROM gristlabs/grist:stable

RUN \
  apt update && apt install -y openssl && \
  python3 -m pip install sqids python-ulid