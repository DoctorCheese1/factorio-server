#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env from .env.example. Edit .env if you want to change ports, save name, or login settings."
fi

mkdir -p data config
docker compose up -d

echo "Factorio server is starting. Follow logs with: docker compose logs -f factorio"
