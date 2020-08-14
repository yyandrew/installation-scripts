#!/bin/bash

if
  [[ "${USER:-}" == "root" ]]
then
  echo "This script works only with normal user, it wont work with root, please log in as normal user and try again." >&2
  exit 1
fi

set -e

echo "Updates packages. Asks for your password."
sudo apt-get update -y

echo "Installs Node 10"
sudo apt-get install -y snapd
sudo snap install node --classic --channel=10

echo "Installs packages. Give your password when asked."
sudo apt-get --ignore-missing install build-essential git-core curl openssl libssl-dev libcurl4-openssl-dev zlib1g zlib1g-dev libreadline6-dev libyaml-dev libsqlite3-dev libsqlite3-0 sqlite3 libxml2-dev libxslt1-dev libffi-dev software-properties-common libgdm-dev libncurses5-dev automake autoconf libtool bison postgresql postgresql-contrib libpq-dev pgadmin3 libc6-dev -y
sudo apt-get install neovim tmux -y

echo "Installs ImageMagick for image processing"
sudo apt-get install imagemagick --fix-missing -y

echo "Installs rbenv for handling Ruby installation"
git clone https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
rbenv init
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
echo "Installs Ruby"
$HOME/.rbenv/bin/rbenv install 2.7.1
$HOME/.rbenv/bin/rbenv global 2.7.1
$HOME/.rbenv/bin/rbenv rehash

echo "gem: --no-ri --no-rdoc" > ~/.gemrc
gem install rails

echo -e "\n- - - - - -\n"
echo -e "Now we are going to print some information to check that everything is done:\n"


echo -n "Should be sqlite 3.22.0 or higher: sqlite "
sqlite3 --version
echo -n "Should be rbenv 2.7.1 or higher:         "
rbenv --version | sed '/^.*$/N;s/\n//g' | cut -c 1-11
echo -n "Should be ruby 2.7.1:                "
ruby -v | cut -d " " -f 2
echo -n "Should be Rails 5.2.3 or higher:         "
rails -v
echo -e "\n- - - - - -\n"
