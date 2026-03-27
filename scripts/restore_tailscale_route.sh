#!/bin/zsh
set -euo pipefail

ROUTE_PATH="/focustube-token"
TARGET_PORT="8787"
LOG="/Users/ryantaylorvegh/.openclaw/workspace/FocusTube/.secrets/tailscale-route.log"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG"; }

# Check if route already exists
CURRENT=$(tailscale serve status --json 2>/dev/null || echo "{}")
if echo "$CURRENT" | grep -q "\"$ROUTE_PATH\""; then
    log "Route $ROUTE_PATH already present"
    exit 0
fi

log "Route $ROUTE_PATH missing, restoring..."
tailscale serve --bg --set-path="$ROUTE_PATH" "$TARGET_PORT" 2>&1 | tee -a "$LOG"
log "Restore complete"
