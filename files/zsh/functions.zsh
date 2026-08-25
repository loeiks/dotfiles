mcd() {
  mkdir -p "${1:?Need to specify an argument}" && cd "$1"
}

portkill() {
  ps="$(lsof -t -i:"$1")"
  if [[ -z "$ps" ]]; then
    echo "no processes found"
  else
    kill -9 "$ps" && echo "$ps"
  fi
}

dwnv() {
  local downloads="$HOME/Downloads"
  [[ $CURRENT_OS == wsl ]] && downloads="/mnt/c/Users/loeiks/Downloads"

  yt-dlp \
    --js-runtimes "bun:$(which bun)" \
    --concurrent-fragments 16 \
    # --cookies "~/www.youtube.com_cookies.txt" \
    -f "bestvideo[height<=1080]+bestaudio" \
    --merge-output-format mp4 \
    -o "$downloads/%(title)s.%(ext)s" \
    "$1"
}