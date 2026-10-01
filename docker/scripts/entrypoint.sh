#!/bin/bash

set -eo pipefail

PORT=${PORT:? The PORT environment variable must be set}

source /app/bin/activate

exec uvicorn npg_porch.server:app \
  --host 0.0.0.0 --port "$PORT" \
  --log-config /app/docker/logging.json
