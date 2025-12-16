#!/usr/bin/env bash

set -e
set -x

pre-commit run --all-files
bash scripts/format.sh
bash scripts/lint.sh
pytest tests
