# reference URL: https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
_get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}
_update_kcp() {
  if [ "" = "$kcpath" ]; then
    read -rp "Enter install directory [default:$HOME/.kcptun]: " -e kcpath
    # Check whether use default path
    if [ "$kcpath" = "" ]; then
      kcpath=$HOME/.kcptun
    fi
    echo kcpath="$kcpath" >> config.conf
  fi
  # Check whether kcpath exists
  if [ ! -d "$kcpath" ]; then
      mkdir -p "$kcpath"
  fi
  # Goto kcpath
  cd "$kcpath" || exit
  touch config.conf
  # Download kcptun
  read -rp "kcptun version(e.g. v20181101) [Default:latest]:" -e latest
  if [ "" = "$latest" ]; then
    latest=$(_get_latest_release "xtaci/kcptun")
  fi
  echo "Download $latest"
  wget -q "https://github.com/xtaci/kcptun/releases/download/$latest/kcptun-linux-amd64-${latest#*v}.tar.gz"
  echo "Extract $latest"
  tar -zxvf kcptun-linux-amd64-*.tar.gz
  rm kcptun-linux-amd64-*.tar.gz
  cd - || exit
}

if [ -f config.conf ]; then
  source config.conf
else
  touch config.conf
fi
if [ "$1" = "server" ] || [ "$1" = "client" ]; then
  _update_kcp
  kcpname=kcp$1
  # Copy and link kcptun.sh
  cp "$kcpname.sh" "$kcpath/"
  # make link
  sudo ln -s "$kcpath/$kcpname.sh" "/usr/local/bin/$kcpname" && chmod +x "$kcpname.sh"
  # Auto start
  read -rp "Would like to start $kcpname when system start?[N/y]: " yn
  case $yn in
      [Yy]* ) sudo chmod +x /etc/rc.local; echo "bash /usr/bin/$kcpname start" | sudo tee -a /etc/rc.local;;
      * ) echo "Don't start $kcpname when system start";;
  esac
  echo "$kcpname installed!"
  echo "Use $kcpname start/stop/restart to control kcptun"
elif [ "$1" = "update" ]; then
  _update_kcp
else
  echo "ERROR: Wrong options"
  echo "Usage:"
  echo "      bash install.sh server"
  echo "      bash install.sh client"
  echo "      bash install.sh update"
  echo
fi

