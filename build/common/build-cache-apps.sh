#!/usr/bin/env bash
# shellcheck disable=SC1091
#
# Cache builder script for apps
#

COMMON_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "${COMMON_DIR}/bootstrap.sh"

# --- Metadata For Fuzzel Apps Cache ---
load_metadata "fuzzel" "apps"

# --- Variables for fuzzel-apps cache ---
PADDING_ARGS="35 20 20" # Column padding: name, type, group

desktop_value() {
  local file="$1" key="$2" value
  value="$(sed -n "s/^${key}=//p" "$file" | head -n1)"
  printf '%s' "${value%$'\r'}"
}

desktop_visible_application() {
  local file="$1" type hidden nodisplay name
  type="$(desktop_value "$file" Type)"
  hidden="$(desktop_value "$file" Hidden)"
  nodisplay="$(desktop_value "$file" NoDisplay)"
  name="$(desktop_value "$file" Name)"

  [[ "${type:-Application}" == "Application" ]] || return 1
  [[ "${hidden,,}" == "true" ]] && return 1
  [[ "${nodisplay,,}" == "true" ]] && return 1
  [[ -n "$name" ]]
}

parse_exec_line() {
  local file="$1" exec_line token cmd
  local -a tokens args
  local i=0 j=0 found=-1

  PARSED_CMD=""
  PARSED_ARGS=()

  exec_line="$(desktop_value "$file" Exec)"
  [[ -n "$exec_line" ]] || return 1
  exec_line="$(printf '%s\n' "$exec_line" | sed -E 's/%[fFuUdDnNickvm]//g')"

  read -ra tokens <<<"$exec_line"

  while ((i < ${#tokens[@]})); do
    token="${tokens[i]%\"}"
    token="${token#\"}"
    [[ "$token" == "env" ]] && {
      ((i++))
      continue
    }
    [[ "$token" == *=* && "$token" != */* ]] && {
      ((i++))
      continue
    }
    break
  done

  cmd="${tokens[i]:-}"
  cmd="${cmd%\"}"
  cmd="${cmd#\"}"
  [[ -n "$cmd" ]] || return 1

  args=("${tokens[@]:i+1}")

  if [[ "$cmd" == "kitty" || "$cmd" == "foot" || "$cmd" == "ghostty" ]]; then
    while ((j < ${#args[@]})); do
      token="${args[j]%\"}"
      token="${token#\"}"
      if [[ "$token" == "-e" ]]; then
        found=$j
        break
      fi
      ((j++))
    done

    if ((found >= 0)); then
      cmd="${args[found + 1]:-}"
      cmd="${cmd%\"}"
      cmd="${cmd#\"}"
      args=("${args[@]:found+2}")
    fi
  fi

  cmd="${cmd##*/}"
  [[ -n "$cmd" ]] || return 1

  PARSED_CMD="$cmd"
  PARSED_ARGS=("${args[@]}")
}

entry_is_installed() {
  parse_exec_line "$1" || return 1
  command -v -- "$PARSED_CMD" >/dev/null 2>&1
}

format_curated_category() {
  local categories="$1" formatted_cats="" cat
  local -a cat_array

  if [[ -n "$categories" ]]; then
    IFS=';' read -ra cat_array <<<"$categories"
    for cat in "${cat_array[@]}"; do
      cat="${cat#"${cat%%[![:space:]]*}"}"
      cat="${cat%"${cat##*[![:space:]]}"}"
      [[ -n "$cat" ]] && formatted_cats+="${formatted_cats:+, }${cat^}"
    done
  fi

  printf '%s' "${formatted_cats:-General}"
}

format_native_category() {
  local categories="$1" cat first=""
  local -a cat_array

  [[ -n "$categories" ]] || {
    printf 'General'
    return
  }

  IFS=';' read -ra cat_array <<<"$categories"

  for cat in "${cat_array[@]}"; do
    cat="${cat#"${cat%%[![:space:]]*}"}"
    cat="${cat%"${cat##*[![:space:]]}"}"
    [[ -n "$cat" ]] || continue
    [[ -n "$first" ]] || first="$cat"
    case "${cat,,}" in
    webbrowser*)
      printf 'Browser'
      return
      ;;
    terminalemulator*)
      printf 'Terminal'
      return
      ;;
    filemanager*)
      printf 'Files'
      return
      ;;
    texteditor*)
      printf 'Editor'
      return
      ;;
    esac
  done

  for cat in "${cat_array[@]}"; do
    cat="${cat#"${cat%%[![:space:]]*}"}"
    cat="${cat%"${cat##*[![:space:]]}"}"
    [[ -n "$cat" ]] || continue
    case "${cat,,}" in
    audio* | video* | media* | player* | music* | tv* | stream* | recorder*)
      printf 'Media'
      return
      ;;
    3d*)
      printf '3D'
      return
      ;;
    graphics* | photography* | 2d* | raster* | vector* | scan*)
      printf 'Graphics'
      return
      ;;
    development* | ide* | debugger* | building* | webdevelopment*)
      printf 'Dev'
      return
      ;;
    office* | spreadsheet* | wordprocessor* | presentation* | calendar* | contactmanagement* | database*)
      printf 'Office'
      return
      ;;
    settings*)
      printf 'Settings'
      return
      ;;
    system*)
      printf 'System'
      return
      ;;
    utility* | archiving* | compression* | filetools* | calculator* | clock*)
      printf 'Utility'
      return
      ;;
    network*)
      printf 'Network'
      return
      ;;
    game*)
      printf 'Games'
      return
      ;;
    education* | science* | math*)
      printf 'Science'
      return
      ;;
    esac
  done

  if [[ -n "$first" ]]; then
    printf '%s' "${first^}"
  else
    printf 'General'
  fi
}

# --- Build Fuzzel-apps Cache ---
build_cache_apps() {
  local APP_DIR="$HOME/.local/share/applications"
  local CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/$APP_NAME"
  local CACHE_FILE="$CACHE_DIR/formatted_apps.cache"
  local sep=$'\x1f'

  print_pending "Building fuzzel-apps cache..."

  mkdir -p "$CACHE_DIR"

  local -a paddings
  read -ra paddings <<<"$PADDING_ARGS"

  declare -A name_map type_map cat_map native_files native_names native_sigs used_names
  local file base name entry_type categories sig
  local dir

  local -a data_dirs=("${XDG_DATA_HOME:-$HOME/.local/share}")
  local -a xdg_dirs
  IFS=':' read -ra xdg_dirs <<<"${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
  data_dirs+=("${xdg_dirs[@]}")

  for dir in "${data_dirs[@]}"; do
    [[ -d "$dir/applications" ]] || continue
    for file in "$dir/applications"/*.desktop; do
      [[ -f "$file" ]] || continue
      base="$(basename "$file")"
      [[ "$base" == rh-* ]] && continue
      [[ -z "${native_files[$base]:-}" ]] || continue
      native_files["$base"]="$file"
    done
  done

  for base in "${!native_files[@]}"; do
    file="${native_files[$base]}"
    desktop_visible_application "$file" || continue

    name="$(desktop_value "$file" Name)"
    native_names["${name,,}"]=1

    if parse_exec_line "$file"; then
      sig="${PARSED_CMD}${sep}${PARSED_ARGS[*]}"
      native_sigs["$sig"]=1
    fi

    name_map["$file"]="$name"
    type_map["$file"]="application"
    cat_map["$file"]="$(format_native_category "$(desktop_value "$file" Categories)")"
  done

  for file in "$APP_DIR"/rh-*.desktop; do
    [[ -f "$file" ]] || continue
    entry_is_installed "$file" || continue

    name="$(desktop_value "$file" Name)"
    [[ -n "$name" ]] || continue

    entry_type="$(desktop_value "$file" X-Entry-Type)"
    entry_type="${entry_type:-application}"

    if [[ "$entry_type" == "application" ]]; then
      [[ -z "${native_names["${name,,}"]:-}" ]] || continue
      sig="${PARSED_CMD}${sep}${PARSED_ARGS[*]}"
      [[ -z "${native_sigs["$sig"]:-}" ]] || continue
    fi

    name_map["$file"]="$name"
    type_map["$file"]="$entry_type"
    cat_map["$file"]="$(format_curated_category "$(desktop_value "$file" X-Category)")"
  done

  local -a sorted_files
  readarray -t sorted_files < <(
    for file in "${!name_map[@]}"; do
      printf '%s\t%s\n' "${name_map[$file]}" "$file"
    done | sort -k1,1 | cut -f2
  )

  {
    for file in "${sorted_files[@]}"; do
      name="${name_map[$file]}"
      entry_type="${type_map[$file]:-application}"
      case "$entry_type" in
      application | app) entry_type="App" ;;
      bookmark) entry_type="Bookmark" ;;
      profile) entry_type="Profile" ;;
      *) entry_type="${entry_type^}" ;;
      esac

      categories="${cat_map[$file]:-General}"

      if [[ -n "${used_names["$name"]:-}" ]]; then
        local suffix=2
        while [[ -n "${used_names["$name ($suffix)"]:-}" ]]; do
          ((suffix++))
        done
        name="$name ($suffix)"
      fi

      used_names["$name"]=1

      local formatted_text=""
      local parts=("$(provide_fuzzel_entry) $name" "$entry_type" "$categories")
      local num_parts=${#parts[@]}
      local num_paddings=${#paddings[@]}

      for ((i = 0; i < num_parts; i++)); do
        local part="${parts[i]}"
        if ((i < num_paddings)); then
          local pad_to=${paddings[i]}
          formatted_text+=$(printf "%-*s" "$pad_to" "$part")
        else
          formatted_text+="$part"
        fi
        if ((i < num_parts - 1)); then
          formatted_text+=" "
        fi
      done

      printf '%s\t%s\n' "$formatted_text" "$file"
    done
  } >"$CACHE_FILE"

  print_success "Fuzzel-apps cache built"
}
