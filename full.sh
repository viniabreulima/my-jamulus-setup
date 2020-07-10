#!/bin/bash
sudo apt update
sudo apt install build-essential qt5-qmake qtdeclarative5-dev qt5-default qttools5-dev-tools libjack-jackd2-dev git less nano wget --yes
wget https://github.com/corrados/jamulus/archive/r3_5_8.tar.gz
tar xvf r3_5_8.tar.gz
cd jamulus-r3_5_8
qmake "CONFIG+=nosound headless" Jamulus.pro
make clean
sudo make install
sudo adduser --system --no-create-home jamulus

cat > jamulus.service<<- EOM
[Unit]
Description=Jamulus-Server
After=network.target

[Service]
Type=simple
User=jamulus
Group=nogroup
NoNewPrivileges=true
ProtectSystem=true
ProtectHome=true
Nice=-20
IOSchedulingClass=realtime
IOSchedulingPriority=0

#### Change this to set genre, location and other parameters.
#### See https://github.com/corrados/jamulus/wiki/Command-Line-Options ####
ExecStart=/usr/local/bin/Jamulus -s -n -e jamulusallgenres.fischvolk.de -o "Jangadinha Pro;Sao Paulo;30"
     
Restart=on-failure
RestartSec=30
StandardOutput=journal
StandardError=inherit
SyslogIdentifier=jamulus

[Install]
WantedBy=multi-user.target
EOM
sudo mv jamulus.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/jamulus.service
sudo chmod 644 /etc/systemd/system/jamulus.service
sudo systemctl daemon-reload
sudo systemctl start jamulus
sudo systemctl enable jamulus
