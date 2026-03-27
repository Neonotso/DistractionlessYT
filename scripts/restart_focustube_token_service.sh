#!/bin/zsh
set -euo pipefail

cd /Users/ryantaylorvegh/.openclaw/workspace/FocusTube

PORT=8787
HOST=127.0.0.1
HEALTH_URL="http://${HOST}:${PORT}/health"
PID_MATCH='python .*scripts/focustube_token_service.py'

if curl -fsS --max-time 2 "$HEALTH_URL" >/dev/null 2>&1; then
  echo "FocusTube token service already healthy on ${HOST}:${PORT}; exiting"
  exit 0
fi

if pgrep -f "$PID_MATCH" >/dev/null 2>&1; then
  echo "FocusTube token service process exists but is not healthy yet; waiting briefly"
  sleep 2
  if curl -fsS --max-time 2 "$HEALTH_URL" >/dev/null 2>&1; then
    echo "FocusTube token service became healthy after brief wait; exiting"
    exit 0
  fi
fi

source .venv/bin/activate
export FOCUSTUBE_ALLOWED_ORIGIN="https://focustube.web.app"
export FOCUSTUBE_TOKEN_HOST="$HOST"
export FOCUSTUBE_TOKEN_PORT="$PORT"
exec python scripts/focustube_token_service.py
