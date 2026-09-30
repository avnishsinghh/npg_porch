#!/bin/bash

set -eo pipefail

PORT=${PORT:? The PORT environment variable must be set}
APP_ENV=${APP_ENV:-prod}

source /app/bin/activate

uvicorn_args=(--host 0.0.0.0 --port "$PORT" --log-config /app/docker/logging.json)

if [[ "$APP_ENV" == "dev" ]]; then
  uvicorn_args+=(--reload --reload-dir /app/src)
fi

exec uvicorn npg_porch.server:app "${uvicorn_args[@]}" "$@"
