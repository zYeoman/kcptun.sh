echo "rm -rf $HOME/.kcptun"
rm -rf $HOME/.kcptun
echo "rm /usr/local/bin/kcpclient"
rm /usr/local/bin/kcpclient
echo "rm /usr/local/bin/kcpserver" 
rm /usr/local/bin/kcpserver
echo "sed -ie '/kcpserver start/d' /etc/rc.local"
sed -ie '/kcpserver start/d' /etc/rc.local
echo "sed -ie '/kcpclient start/d' /etc/rc.local"
sed -ie '/kcpclient start/d' /etc/rc.local
