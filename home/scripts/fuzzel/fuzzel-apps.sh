#!/usr/bin/env bash

set -euo pipefail

# --- Imports ---
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../common/bootstrap.sh"

# --- Main Configuration ---
load_metadata "fuzzel" "apps"

# --- Configuration ---
PADDING_ARGS="35 20 20" # Column padding: name, type, group

desktop_value() {
  local file="$1" key="$2" value
  # Keys may be localized (Name[es]); only take the unlocalized form and stop
  # at the first match so [Desktop Action ...] sections are ignored.
  value="$(awk -v k="$key" 'index($0, k "=") == 1 { sub("^" k "=", ""); print; exit }' "$file")"
  printf '%s' "${value%$'\r'}"
}

launch_in_terminal() {
  local exec_line="$1" cmd
  # Strip desktop-entry field codes (%f, %F, %u, %U, %i, %c, %k). They are
  # placeholders, not command arguments.
  cmd="$(printf '%s' "$exec_line" | sed -E 's/%[fFuUdDnNickvm]//g')"
  # shellcheck disable=SC2086
  setsid ${TERMINAL:-kitty} -e bash -lc "$cmd" >/dev/null 2>&1 &
}

launch_app() {
  CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/$APP_NAME"
  CACHE_FILE="$CACHE_DIR/formatted_apps.cache"

  # Display from cache
  selected=$(cut -f1 "$CACHE_FILE" | fuzzel --dmenu --prompt="$PROMPT" -w 85) || return 0
  [[ -z "$selected" ]] && return

  # Find corresponding file from cache
  filename=$(awk -F'\t' -v sel="$selected" '$1 == sel { print $2; exit }' "$CACHE_FILE")
  [[ -n "$filename" ]] || return

  local terminal exec_line
  terminal="$(desktop_value "$filename" Terminal)"
  exec_line="$(desktop_value "$filename" Exec)"

  # gtk-launch (and gio) ignore Terminal=true, so start the terminal ourselves.
  if [[ "${terminal,,}" == "true" && -n "$exec_line" ]]; then
    launch_in_terminal "$exec_line"
    return
  fi

  # gio launch takes a path and honours DBusActivatable. gtk-launch needs the
  # application id to be registered with GIO, which fails for several entries.
  if command -v gio >/dev/null 2>&1; then
    setsid gio launch "$filename" >/dev/null 2>&1 &
    return
  fi

  (gtk-launch "$(basename "$filename" .desktop)" || true) >/dev/null 2>&1 &
}

main() {
  launch_app
}

main
