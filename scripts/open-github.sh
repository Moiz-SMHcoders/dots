#!/usr/bin/env bash

# Get the directory of the active tmux pane
cd "$(tmux display-message -p -F "#{pane_start_path}")" || exit

url=$(git remote get-url origin 2>/dev/null) || {
  echo "Not a git repository"
  exit 1
}

branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)

# Convert SSH to HTTPS if needed
if [[ $url == git@* ]]; then
    url="${url#git@}"
    url="${url/:/\/}"
    url="https://$url"
fi

url="${url%.git}"
url="$url/tree/$branch"

# Open in browser
if command -v open >/dev/null 2>&1; then
    open "$url"
elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url"
else
    echo "link: $url"
fi
