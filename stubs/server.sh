#!/bin/bin

#────────────────────────────────────────────────────────────────┐
# ─ copiar todo y pegar en la terminal de linux de tu servidor ─ │
#────────────────────────────────────────────────────────────────┘

DIRECTORY="$(pwd)/www"
mkdir $DIRECTORY && cd $DIRECTORY

echo "
┌────────────────────────────────────────────────────────────────┐
│                      desarrollado por:                         │
│             (Byancode S.A.C) cesar@byancode.com                │
└────────────────────────────────────────────────────────────────┘
"
ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

ENDPOINT="https://raw.githubusercontent.com/byancode/doravel/main"
DISTRO=$(cat /etc/os-release | grep "^ID=" | cut -d= -f2)
DISTRO=${DISTRO//\"/}

curl $ENDPOINT/deps/$DISTRO | bash
curl https://get.docker.com | bash

git config --global user.name  "__GIT_NAME__"
git config --global user.email "__GIT_EMAIL__"

echo "__RSA_KEY__" | base64 -d > $HOME/.ssh/id_rsa
echo "__RSA_PUB__" | base64 -d > $HOME/.ssh/id_rsa.pub

chmod 600 $HOME/.ssh/id_rsa

LANG=en_US

expect <<END
    set timeout -1
    spawn git clone --branch=__GIT_BRANCH__ git@github.com:__GIT_REPOSITORY__.git .

    expect "continue connecting\r"
    send "yes\r"

    expect eof
END

./doravel global
./doravel up --env production -d

echo "espera unos segundos para que se carguen los servicios"
echo "🙂: ./doravel up --env production -d"