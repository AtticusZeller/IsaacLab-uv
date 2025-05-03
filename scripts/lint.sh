#!/usr/bin/env bash

set -e
set -x

ruff check src          # linter
ruff format src --check # formatter
mypy src                # type check
