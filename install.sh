if [ "$1" = "server" ]; then
    read -p "Enter install directory [default:$HOME/.kcptun]: " -e kcpath
    # Check whether use default path
    if [ "$kcpath" = "" ]; then
        kcpath=$HOME/.kcptun
    fi
    # Check whether kcpath exists
    if [ ! -d "$kcpath" ]; then
        mkdir -p "$kcpath"
    fi
    # Copy and link kcptun.sh
    cp kcptun.sh "$kcpath/"
    # Goto kcpath
    cd "$kcpath"
    # make link
    echo sudo ln kcptun.sh /usr/local/bin/kcptun
    echo sudo chmod +x kcptun.sh
    sudo ln -s kcptun.sh /usr/local/bin/kcptun && chmod +x kcptun.sh
    # Download kcptun
    # TODO: Auto detect latest release
    # reference URL: http://stackoverflow.com/questions/24987542/is-there-a-link-to-github-for-downloading-a-file-in-the-latest-release-of-a-repo
    wget https://github.com/xtaci/kcptun/releases/download/v20160725/kcptun-linux-amd64-20160725.tar.gz
    tar -zxf kcptun-linux-amd64-*.tar.gz
    rm kcptun-linux-amd64-*.tar.gz
    # Auto start
    read -p "Would like to start kcptun when system start?[N/y]: " yn
    case $yn in
        [Yy]* ) sudo chmod +x /etc/rc.local; sudo echo "bash /usr/bin/kcptun start" >> /etc/rc.local;break;;
        * ) echo "Don't start kcptun when system start";;
    esac
elif [ "$1" = "client" ]; then
    # TODO: 
    echo "coming soon"
else
    echo "ERROR: Wrong options"
    echo "Usage:"
    echo "      bash install.sh server"
    echo "      bash install.sh client"
    echo
fi

