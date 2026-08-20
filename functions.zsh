portkill() {
  ps="$(lsof -t -i:"$1")"
  if [[ -z "$ps" ]]; then
    echo "no processes found"
  else
    kill -9 "$ps" && echo "$ps"
  fi
}

mcd() {
  mkdir -p "${1:?Need to specify an argument}" && cd "$1"
}
