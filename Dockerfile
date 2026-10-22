# Pinned by digest so builds are reproducible. The publish workflow's daily run bumps
# this line when gristlabs/grist:stable moves.
FROM gristlabs/grist:stable@sha256:577918affbc446f77382b6049c06226488a086a3ea52c2661154b1252d5ff873

RUN apt-get update && apt-get install -y --no-install-recommends openssl ca-certificates && \
    python3 -m pip install --no-cache-dir sqids python-ulid html2text policyengine-uk && \
    rm -rf /var/lib/apt/lists/*

COPY ./dist /grist/plugins/gwhthompson-widgets
COPY ./scripts /grist/scripts

ENTRYPOINT ["/grist/scripts/docker-entrypoint-wrapper.sh"]

# Setting ENTRYPOINT clears the base image's CMD, so restate upstream's. Not
# sandbox/supervisor.mjs: it's deprecated, and exits on SIGTERM without forwarding it,
# so every `docker stop` SIGKILLed Grist before it could push open docs to storage.
CMD ["./sandbox/run.sh"]
