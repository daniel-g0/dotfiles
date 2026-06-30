#!/usr/bin/env bash
# Shim — calls doller
exec "$(dirname "${BASH_SOURCE[0]}")/doller" "$@"
