#!/usr/bin/env fish

curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer > 
gvm install 1.15 -B
gvm use 1.15 --default
