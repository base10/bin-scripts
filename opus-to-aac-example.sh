#!/usr/bin/env zsh

ffmpeg \
    -i "Severance — Music To Refine To feat. ODESZA ｜ Apple TV+ [JRnDYB28bL8].opus" \
    -c:a aac_at \
    -vbr 3 \
    "Severance - Music to Refine To feat. ODESZA.m4a"
