#!/bin/bash -eux

install_extra_ppas() {
    # add heroku repository to apt
    echo "deb http://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list

    # install heroku's release key for package verification
    wget -q -O- https://toolbelt.heroku.com/apt/release.key | apt-key add -
}

update_package_index() {
    sudo apt-get update
}

install_required_packages() {
    sudo apt-get install -y \
	git \
	tree \
	zip \
	unzip \
	htop \
	whois \
	ack-grep \
	sqlite3 \
	run-one \
	libpq-dev \
	python-dev \
	python3-dev \
	libxml2-dev \
	libyaml-dev \
	libxslt1-dev \
	libffi-dev \
	libfreetype6-dev \
	libimage-exiftool-perl \
	libjpeg-dev \
	postgresql \
	heroku-toolbelt \
	xclip \
	markdown \
	nodejs-legacy \
	npm \
	gnupg-curl \
	python-flake8 \
	python-virtualenv \
	virtualenvwrapper \
	imagemagick
}

configure_ack() {
    sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
}

install_symlinks() {
    ln -sf /vagrant/config/bashrc /home/vagrant/.bashrc
    ln -sf /vagrant/config/pip.conf /home/vagrant/.pip/pip.conf
}


install_symlinks
install_extra_ppas
update_package_index
install_required_packages
configure_ack
