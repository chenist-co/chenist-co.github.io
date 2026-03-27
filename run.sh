#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

PORT="${1:-3049}"

echo "Starting Quarto preview on port $PORT..."
quarto preview --port "$PORT" --no-browser &
QUARTO_PID=$!

# Wait for the server to be ready
for i in $(seq 1 30); do
  if curl -s "http://localhost:$PORT" > /dev/null 2>&1; then
    break
  fi
  sleep 1
done

# Open in Firefox
if [[ -d "/Applications/Firefox Developer Edition.app" ]]; then
  open -a "Firefox Developer Edition" "http://localhost:$PORT"
elif [[ -d "/Applications/Firefox.app" ]]; then
  open -a "Firefox" "http://localhost:$PORT"
else
  echo "Firefox not found, opening in default browser..."
  open "http://localhost:$PORT"
fi

echo "Quarto running (PID $QUARTO_PID). Press Ctrl+C to stop."
wait $QUARTO_PID
