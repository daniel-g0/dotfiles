#!/usr/bin/env bash
COLS=$(tput cols)
TITLE="✦  Quote of the Day"
TITLE_LEN=${#TITLE}
SEP=$(printf '━%.0s' $(seq 1 $COLS))
TITLE_PAD=$(printf ' %.0s' $(seq 1 $(( (COLS - TITLE_LEN) / 2 ))))

echo ""
echo "${SEP}"
echo "${TITLE_PAD}${TITLE}"
echo "${SEP}"
echo ""

# Center each line of the fortune output
fortune | while IFS= read -r line; do
    line_len=${#line}
    if (( line_len < COLS )); then
        pad=$(printf ' %.0s' $(seq 1 $(( (COLS - line_len) / 2 ))))
        echo "${pad}${line}"
    else
        echo "$line"
    fi
done

echo ""
