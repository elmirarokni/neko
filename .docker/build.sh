#!/bin/bash

cd ../server
go get && make build

cd ../client
npm install && npm run build

cd ../
sudo docker build -f Dockerfile -t neko .

# sudo docker run -p 8080:8080 --shm-size=2gb neko:latest 