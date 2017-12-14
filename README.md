## CryptoNoter v1.2
In-Browser Javascript XMR miner for websites / Payout towards personal XMR wallet<br />
Built for in-browser javascript mining on any Monero pools. 0% Commission. 100% Payout

## Installation
```bash
Install Nginx
sudo apt-get update
sudo apt-get install nginx
```

Install NodeJs & NPM
```bash
sudo apt-get update
sudo apt-get install nodejs
sudo apt-get install npm
```

Install CryptoNoter
```bash
curl https://raw.githubusercontent.com/cryptonoter/CryptoNoter/master/install.sh > install.sh
sudo sh install.sh
```

## Troubleshooting
Check if server.js execute successfully by using this command
```bash
node /srv/CryptoNoter/server.js
```
If script executes successfully, it should show:
```bash
In-Browser Javascript XMR miner for websites / Payout towards personal XMR wallet
Built for in-browser javascript mining on any Monero pools. 0% Commission. 100% Payout

 Listen on : 127.0.0.1:7777
 Pool Host : monero.us.to:1111
 Ur Wallet : YOUR_WALLET_ADDRESS
```
If script executes unsucessfully, it should show the error logs

