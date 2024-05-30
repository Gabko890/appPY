#!/bin/bash

# Funkcia na kontrolu a inštaláciu balíčkov pomocou pacman
install_if_not_present() {
    if ! pacman -Qi $1 &>/dev/null; then
        sudo pacman -Sy --noconfirm $1
    else
        echo "$1 alredy installed"
    fi
}

# Kontrola a inštalácia git, python, python-flask a docker
install_if_not_present git
install_if_not_present python
install_if_not_present python-flask
install_if_not_present docker

# Spustenie docker služby, ak nie je spustená
if ! systemctl is-active --quiet docker; then
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Klonovanie repozitára
cd
git clone https://github.com/Gabko890/appPY

# Zmena adresára na klonovaný repozitár
cd ~/appPY

# Vytvorenie Docker obrazu
sudo docker build -t post-microservice .


echo 'alias microservice-post-run="sudo docker run -p 4000:5000 post-microservice"' >> ~/.bashrc

echo pre spustenie restartujete terminal a pouzite microservice-post-run
