#!/bin/bash

# usefull debugging tools pavucontrol htop x11vnc

sudo mkdir -p /var/run/dbus /etc/neko
sudo /etc/init.d/dbus start

sudo cp supervisord.conf /etc/neko/supervisord.conf
sudo cp openbox.xml /etc/neko/openbox.xml

sudo cp default.pa /etc/pulse/default.pa
sudo cp policies.json /usr/lib/firefox-esr/distribution/policies.json

if [ ! -f /usr/lib/firefox-esr/distribution/extensions/uBlock0@raymondhill.net.xpi ]; then
  sudo mkdir -p /usr/lib/firefox-esr/distribution/extensions
  sudo curl -o /usr/lib/firefox-esr/distribution/extensions/uBlock0@raymondhill.net.xpi https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi
fi

if [ ! -f ../server/bin/neko ]; then
  echo "build server before testing"
  exit 1
fi

if [ ! -d ../client/dist/ ]; then
  echo "build client before testing"
  exit 1
fi

sudo cp ../server/bin/neko /usr/bin/neko
sudo cp -R ../client/dist /var/www/

sudo rm -rf $HOME/.mozilla
sudo rm -rf /var/run/supervisord.pid

mkdir -p $HOME/.config/pulse
echo "default-server=unix:/tmp/pulseaudio.socket" > $HOME/.config/pulse/client.conf

export NEKO_DISPLAY=0
export NEKO_WIDTH=1280
export NEKO_HEIGHT=720
export NEKO_URL=https://www.youtube.com/embed/QH2-TGUlwu4
export NEKO_PASSWORD=neko
export NEKO_BIND=0.0.0.0:80
export NEKO_KEY=
export NEKO_CERT=

supervisord --configuration ./supervisord.dev.conf