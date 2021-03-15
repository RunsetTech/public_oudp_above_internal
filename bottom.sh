#!/bin/bash
curl -O https://raw.githubusercontent.com/RunsetTech/openvpn_instal_15sub/main/openvpn-install.sh
chmod +x openvpn-install.sh
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y nodejs
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install npm

# we make the script and its service here and start and enable it



mkdir roller

cd roller

sudo npm -init -y

sudo npm i express

sudo npm i express-rate-limit

cat > index.js <<EOF
const express = require('express')
const rateLimit = require("express-rate-limit");
const app = express()



app.get('/', function (req, res) {
  res.send('Error: 404')
})

app.listen(4444)

const limiter = rateLimit({
    windowMs: 8, // 15 minutes
    max: 3 // limit each IP to 3 requests per 8Ms
  });
app.use(limiter);
EOF

cd ..

cat > ghost.sh <<EOF
sudo node /home/ubuntu/roller/index.js
EOF

sudo cp ghost.sh /usr/bin/ghost.sh
sudo chmod +x /usr/bin/ghost.sh

cat > ghost.service <<EOF
[Unit]
Description=Ghost Service
[Service]
Type=simple
ExecStart=/bin/bash /usr/bin/ghost.sh
[Install]
WantedBy=multi-user.target
EOF

sudo cp ghost.service /etc/systemd/system/ghost.service
sudo chmod 644 /etc/systemd/system/ghost.service

sudo systemctl start ghost
sudo systemctl enable ghost

#export AUTO_INSTALL=y
export APPROVE_IP=n
export IPV6_SUPPORT=n
export PORT_CHOICE=1
export PROTOCOL_CHOICE=1
export DNS=1
export COMPRESSION_ENABLED=n
export CUSTOMIZE_ENC=n
export CLIENT=nima
export IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
export PASS=1
sudo AUTO_INSTALL=y ./openvpn-install.sh
# sudo DEBIAN_FRONTEND=noninteractive AUTO_INSTALL=y ./openvpn-install.sh
# sudo systemctl start openvpn
cat client.ovpn
echo nimaaaa
sudo reboot
