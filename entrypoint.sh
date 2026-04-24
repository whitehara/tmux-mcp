#!/bin/sh
set -e

TARGET_UID="${HOST_UID:-1000}"
TARGET_GID="${HOST_GID:-${TARGET_UID}}"

if ! getent group "${TARGET_GID}" > /dev/null 2>&1; then
    addgroup -g "${TARGET_GID}" tmuxuser
fi

if ! getent passwd "${TARGET_UID}" > /dev/null 2>&1; then
    adduser -D -u "${TARGET_UID}" -G "$(getent group "${TARGET_GID}" | cut -d: -f1)" \
        -h /home/tmuxuser tmuxuser
fi

exec su-exec "${TARGET_UID}:${TARGET_GID}" "$@"
