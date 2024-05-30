#!/bin/bash

install_if_not_present() {
    if ! dpkg -l | grep -q $1; then
        sudo apt update
        sudo apt install -y $1
    else
        echo "$1 is already installed."
    fi
}

install_if_not_present git
install_if_not_present python3
install_if_not_present python3-flask
install_if_not_present docker.io

if ! systemctl is-active --quiet docker; then
    sudo systemctl start docker
    sudo systemctl enable docker
fi

cd
git clone https://github.com/Gabko890/appPY

cd ~/appPY

sudo docker build -t post-microservice .


echo 'alias microservice-post-run="sudo docker run -p 4000:5000 post-microservice"' >> ~/.bashrc
echo pre spustenie restartujete terminal a pouzite microservice-post-run