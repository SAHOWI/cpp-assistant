#!/usr/bin/env bash
set -euo pipefail

MODEL_DIR="${MODEL_DIR:-/models/Falcon3-3B-Instruct-1.58bit}"
QUANT_TYPE="${QUANT_TYPE:-i2_s}"
HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8080}"
THREADS="${THREADS:-8}"

cd /opt/BitNet

python setup_env.py -md "${MODEL_DIR}" -q "${QUANT_TYPE}"

exec ./build/bin/llama-server \
  -m "${MODEL_DIR}" \
  --host "${HOST}" \
  --port "${PORT}" \
  -t "${THREADS}"
