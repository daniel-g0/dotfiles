#!/usr/bin/env bash
# Claude Code statusLine — Tokyo Night theme, Starship-inspired
# Mirrors: cwd (blue), git branch (green), git status (yellow), model (purple)
# Also forwards to caveman-statusline if active.

# --- Colours (Tokyo Night palette) ---
BLUE='\033[38;2;122;162;247m'    # #7aa2f7
GREEN='\033[38;2;158;206;106m'   # #9ece6a
YELLOW='\033[38;2;224;175;104m'  # #e0af68
PURPLE='\033[38;2;187;154;247m'  # #bb9af7
CYAN='\033[38;2;125;207;255m'    # #7dcfff
RESET='\033[0m'

# --- Read JSON from stdin ---
INPUT=$(cat)

# --- CWD (shortened, home as ~) ---
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')
if [ -n "$CWD" ]; then
  HOME_DIR="$HOME"
  CWD="${CWD/#$HOME_DIR/\~}"
  # Keep last 3 path segments to stay compact
  SEGMENTS=$(printf '%s' "$CWD" | tr '/' '\n' | grep -c .)
  if [ "$SEGMENTS" -gt 3 ]; then
    CWD="…/$(printf '%s' "$CWD" | rev | cut -d'/' -f1-3 | rev)"
  fi
fi

# --- Git branch (read from repo field, fallback to git cmd in cwd) ---
BRANCH=""
REAL_CWD=$(printf '%s' "$INPUT" | jq -r '.workspace.current_dir // empty')
if [ -n "$REAL_CWD" ] && [ -d "$REAL_CWD/.git" ] || git -C "${REAL_CWD:-$PWD}" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  BRANCH=$(git -C "${REAL_CWD:-$PWD}" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
fi

# --- Git status symbols (matching starship.toml) ---
GIT_STATUS=""
if [ -n "$BRANCH" ] && [ -n "$REAL_CWD" ]; then
  STATUS_OUT=$(git -C "$REAL_CWD" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null)
  MODIFIED=$(printf '%s' "$STATUS_OUT" | grep -c '^1 .M')
  STAGED=$(printf '%s' "$STATUS_OUT" | grep -c '^1 [MARC]')
  UNTRACKED=$(printf '%s' "$STATUS_OUT" | grep -c '^?')
  AHEAD=$(printf '%s' "$STATUS_OUT" | grep '^# branch.ab' | grep -oP '(?<=\+)\d+' || true)
  BEHIND=$(printf '%s' "$STATUS_OUT"| grep '^# branch.ab' | grep -oP '(?<=-)\d+' || true)

  [ "${MODIFIED:-0}" -gt 0 ]   && GIT_STATUS="${GIT_STATUS} "
  [ "${STAGED:-0}" -gt 0 ]     && GIT_STATUS="${GIT_STATUS}++${STAGED}"
  [ "${UNTRACKED:-0}" -gt 0 ]  && GIT_STATUS="${GIT_STATUS}?"
  [ "${AHEAD:-0}" -gt 0 ]      && GIT_STATUS="${GIT_STATUS}⇡${AHEAD}"
  [ "${BEHIND:-0}" -gt 0 ]     && GIT_STATUS="${GIT_STATUS}⇣${BEHIND}"
fi

# --- Model (display_name, shortened) ---
MODEL=$(printf '%s' "$INPUT" | jq -r '.model.display_name // empty')

# --- Token usage (rate limits, Pro/Max only; absent until first API response) ---
TOK_5H=$(printf '%s' "$INPUT" | jq -r '.rate_limits.five_hour.used_percentage // empty | if type == "number" then round else . end')
TOK_WK=$(printf '%s' "$INPUT" | jq -r '.rate_limits.seven_day.used_percentage // empty | if type == "number" then round else . end')

# --- Time until 5h window resets ---
RESET_TIME=""
RESETS_AT=$(printf '%s' "$INPUT" | jq -r '.rate_limits.five_hour.resets_at // empty')
if [ -n "$RESETS_AT" ]; then
  SECS_LEFT=$(( RESETS_AT - $(date +%s) ))
  [ "$SECS_LEFT" -gt 0 ] && RESET_TIME="$(( SECS_LEFT / 60 ))m"
fi

# --- Build output ---
OUT=""

# cwd
[ -n "$CWD" ] && OUT="${OUT}$(printf "${BLUE}%s${RESET}" "$CWD")"

# branch
if [ -n "$BRANCH" ]; then
  OUT="${OUT} $(printf "${GREEN}${BRANCH}${RESET}")"
  # git status symbols
  [ -n "$GIT_STATUS" ] && OUT="${OUT}$(printf " ${YELLOW}%s${RESET}" "$GIT_STATUS")"
fi

# model
if [ -n "$MODEL" ]; then
  SHORT_MODEL=$(printf '%s' "$MODEL" | sed 's/Claude //' | sed 's/ Sonnet/S/' | sed 's/ Haiku/H/' | sed 's/ Opus/O/')
  OUT="${OUT} $(printf "${PURPLE}[%s]${RESET}" "$SHORT_MODEL")"
fi

# token usage % + time until reset
if [ -n "$TOK_5H" ] || [ -n "$RESET_TIME" ]; then
  TOK_PART="${TOK_5H:+${TOK_5H}%}"
  RESET_PART="${RESET_TIME:+⟳${RESET_TIME}}"
  SEP=$( [ -n "$TOK_PART" ] && [ -n "$RESET_PART" ] && printf ' ' )
  OUT="${OUT} ${CYAN}5h:${TOK_PART}${SEP}${RESET_PART}${RESET}"
fi
[ -n "$TOK_WK" ] && OUT="${OUT} ${CYAN}wk:${TOK_WK}%${RESET}"

# --- Caveman badge (append if active) ---
CAVEMAN_HOOK=$(ls "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/plugins/cache/caveman/caveman/"*/src/hooks/caveman-statusline.sh 2>/dev/null | head -1)
[ -n "$CAVEMAN_HOOK" ] && CAVEMAN_BADGE=$(bash "$CAVEMAN_HOOK" 2>/dev/null)
[ -n "$CAVEMAN_BADGE" ] && OUT="${OUT} ${CAVEMAN_BADGE}"

printf '%b' "$OUT"
