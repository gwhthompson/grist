FROM gristlabs/grist:stable

RUN \
  apt update && apt install -y openssl ca-certificates && \
  python3 -m pip install sqids python-ulid

ENTRYPOINT ["sh", "-c", "update-ca-certificates && exec ./sandbox/docker_entrypoint.sh"]
CMD ["node", "./sandbox/supervisor.mjs"]
