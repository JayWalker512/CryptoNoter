read -p "[1] Listen Port (7777) > " lport
read -p "[2] Your Domain (localhost) > " domain
read -p "[3] Pool Host&Port (pool.cryptonoter.com:1111) > " pool
read -p "[4] Your XMR or ETN wallet (Important) > " addr
if [ ! -n "$lport" ];then
    lport="7777"
fi
if [ ! -n "$domain" ];then
    domain="localhost"
fi
if [ ! -n "$pool" ];then
    pool="pool.cryptonoter.com:1111"
fi
while  [ ! -n "$addr" ];do
    read -p "Plesae set XMR wallet address!!! > " addr
done
read -p "[5] The Pool passwd (null) > " pass
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt install --yes nodejs git curl nginx
mkdir /srv
cd /srv
rm -rf CryptoNoter
git clone https://github.com/cryptonoter/CryptoNoter.git -o CryptoNoter
cd CryptoNoter
sed -i "s/7777/$lport/g" config.EXAMPLE.json
sed -i "s/miner.cryptonoter.com/$domain/g" config.EXAMPLE.json
sed -i "s/pool.cryptonoter.com:1111/$pool/g" config.EXAMPLE.json
sed -i "s/INPUT_YOUR_WALLET_ADDRESS/$addr/g" config.EXAMPLE.json
sed -i "s/\"pass\": \"\"/\"pass\": \"$pass\"/g" config.EXAMPLE.json
npm update
npm install -g forever
forever start /srv/CryptoNoter/server.js
sed -i '/forever start \/srv\/CryptoNoter\/server.js/d' /etc/rc.local
sed -i '/exit 0/d' /etc/rc.local
echo "forever start /srv/CryptoNoter/server.js" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
rm -rf /etc/nginx/sites-available/CryptoNoter.conf
rm -rf /etc/nginx/sites-enabled/CryptoNoter.conf
echo 'server {' >> /etc/nginx/sites-available/CryptoNoter.conf
echo 'listen 80;' >> /etc/nginx/sites-available/CryptoNoter.conf
echo "server_name $domain;" >> /etc/nginx/sites-available/CryptoNoter.conf
echo 'location / {' >> /etc/nginx/sites-available/CryptoNoter.conf
echo 'proxy_http_version 1.1;' >> /etc/nginx/sites-available/CryptoNoter.conf
echo 'proxy_set_header   Host	$http_host;' >> /etc/nginx/sites-available/CryptoNoter.conf
echo 'proxy_set_header   X-Real-IP $remote_addr;' >> /etc/nginx/sites-available/CryptoNoter.conf
echo 'proxy_set_header   Upgrade $http_upgrade;' >> /etc/nginx/sites-available/CryptoNoter.conf
echo 'proxy_set_header   Connection "upgrade";' >> /etc/nginx/sites-available/CryptoNoter.conf
echo 'proxy_cache_bypass $http_upgrade;' >> /etc/nginx/sites-available/CryptoNoter.conf
echo "proxy_pass         http://127.0.0.1:$lport;" >> /etc/nginx/sites-available/CryptoNoter.conf
echo '}' >> /etc/nginx/sites-available/CryptoNoter.conf
echo '}' >> /etc/nginx/sites-available/CryptoNoter.conf
ln -s /etc/nginx/sites-available/CryptoNoter.conf /etc/nginx/sites-enabled/CryptoNoter.conf
clear
echo " >>> Serv : $domain (backend > 127.0.0.1:$lport)"
echo " >>> Pool : $pool"
echo " >>> Addr : $addr"
echo ""
echo " Installation Completed ! Start Mining Monero Using CryptoNoter !"
echo ""
service nginx restart
