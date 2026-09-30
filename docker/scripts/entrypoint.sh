#!/bin/bash

set -eo pipefail

PORT="${PORT:? The PORT environment variable must be set}"

SSL_CERT="${SSL_CERT:? SSL_CERT not set}"
SSL_KEY="${SSL_KEY:? SSL_KEY not set}"

source /app/bin/activate

exec uvicorn npg_porch.server:app \
  --host 0.0.0.0 --port "$PORT" \
  --log-config /app/docker/logging.json \
  --ssl-certfile "$SSL_CERT" --ssl-keyfile "$SSL_KEY"
