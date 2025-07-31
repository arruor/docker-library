#!/usr/bin/env bash

set -euo pipefail

# Define default values for various settings
: "${RECURSOR_LOG_LEVEL:=0}"
: "${RECURSOR_WEB_LOG_LEVEL:=none}"
: "${RECURSOR_WEBSERVER_ALLOWED_FROM:=127.0.0.1,::1}"
: "${RECURSOR_WEBSERVER_PASSWORD:=password}"
: "${RECURSOR_API_KEY:=api-key}"

# Run Service
exec "${@}" --loglevel=${RECURSOR_LOG_LEVEL} --webserver-loglevel=${RECURSOR_WEB_LOG_LEVEL} --webserver-allow-from=${RECURSOR_WEBSERVER_ALLOWED_FROM} --webserver-password=${RECURSOR_WEBSERVER_PASSWORD} --api-key=${RECURSOR_API_KEY}