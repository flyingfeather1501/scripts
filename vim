#!/bin/bash
# nvim wrapper
if type nvim >/dev/null 2>/dev/null; then
    nvim "$@"
else
    vim "$@"
fi
