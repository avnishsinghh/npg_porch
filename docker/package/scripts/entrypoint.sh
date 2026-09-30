#!/bin/bash

set -eo pipefail

PORT=${PORT:? The PORT environment variable must be set}
APP_ENV=${APP_ENV:-prod}

source /app/bin/activate

uvicorn_args=(--host 0.0.0.0 --port "$PORT" --log-config /app/docker/logging.json)

case "$APP_ENV" in
  dev)  uvicorn_args+=(--app-dir /app/src --reload --reload-dir /app/src) ;;
  prod) ;;
  *)    echo "APP_ENV must be 'dev' or 'prod', got '$APP_ENV'" >&2; exit 1 ;;
esac

exec uvicorn npg_porch.server:app "${uvicorn_args[@]}" "$@"
