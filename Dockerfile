FROM gristlabs/grist:stable

RUN apt-get update && apt-get install -y openssl ca-certificates curl && \
    python3 -m pip install sqids python-ulid html2text policyengine-uk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./dist /grist/plugins/gwhthompson-widgets
COPY ./scripts /grist/scripts

ENTRYPOINT ["/grist/scripts/docker-entrypoint-wrapper.sh"]

CMD ["node", "./sandbox/supervisor.mjs"]