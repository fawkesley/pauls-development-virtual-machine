#!/bin/bash -eux

install_extra_ppas() {
    # add heroku repository to apt
    echo "deb http://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list

    # install heroku's release key for package verification
    wget -q -O- https://toolbelt.heroku.com/apt/release.key | apt-key add -

    # Elixir / Erlang from erlang-solutions.com
    echo 'deb https://packages.erlang-solutions.com/ubuntu trusty contrib' > /etc/apt/sources.list.d/erlang_solutions.list
    wget -q -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
}

update_package_index() {
    sudo apt-get update
}

install_required_packages() {
    sudo apt-get install -y \
	git \
	g++ \
	tree \
	zip \
	unzip \
	firejail \
	htop \
	whois \
	ack-grep \
        dos2unix \
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
	make \
	nfs-common \
	postgresql \
	heroku-toolbelt \
	xclip \
	markdown \
	python-flake8 \
	python-virtualenv \
	virtualenvwrapper \
	imagemagick \
	clang \
	libicu-dev \
	yui-compressor \
        libreadline-dev
}

configure_ack() {
    sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
}

install_symlinks() {
    ln -sf /vagrant/config/bashrc /home/vagrant/.bashrc
    ln -sf /vagrant/config/ssh /home/vagrant/.ssh
}

atomic_download() {
    URL=$1
    DEST=$2

    TMP="$(tempfile)"

    wget -qO "${TMP}" "${URL}" && mv "${TMP}" "${DEST}"
}


install_golang_1_10_4() {
    GO_TARBALL=/tmp/download/go1.10.4.linux-amd64.tar.gz
    GO_URL=https://dl.google.com/go/go1.10.4.linux-amd64.tar.gz

    if [ ! -f "${GO_TARBALL}" ]; then
	atomic_download "${GO_URL}" "${GO_TARBALL}"
    fi

    mkdir -p /opt/go
    # tarball paths start go/...
    tar --directory /opt --extract -f "${GO_TARBALL}"

    cp /vagrant/config/etc/profile.d/golang.sh /etc/profile.d/golang.sh
}

install_hugo() {
  sudo snap install hugo --channel=extended
}

install_latest_node_v7() {
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

install_gulp_globally() {
    npm install --global gulp
}

install_ruby_rbenv() {
    RBENV_DIR=/home/vagrant/.rbenv

    if [ -d "${RBENV_DIR}" ]; then
	cd "${RBENV_DIR}"
	git pull
	cd -
    else
	git clone https://github.com/rbenv/rbenv.git "${RBENV_DIR}"
    fi

    chown -R vagrant "${RBENV_DIR}"
}

install_ruby_build() {
    RUBY_BUILD_DIR=/home/vagrant/.rbenv/plugins/ruby-build

    if [ -d "${RUBY_BUILD_DIR}" ]; then
	cd "${RUBY_BUILD_DIR}"
	git pull
	cd -
    else
	git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}"
    fi

    chown -R vagrant "${RUBY_BUILD_DIR}"
}

install_ruby_2_4_2() {
    run_as_vagrant "rbenv install 2.4.2 || true"
}

set_ruby_2_4_2_as_global() {
    run_as_vagrant "rbenv global 2.4.2"
}

install_bundler() {
  run_as_vagrant "gem install bundle"
}

run_as_vagrant() {
  su vagrant bash -l -c "$1"
}


install_symlinks
install_extra_ppas
update_package_index
install_required_packages
# configure_ack
# install_latest_node_v7
# install_gulp_globally
install_golang_1_10_4
install_hugo
install_ruby_rbenv
install_ruby_build
install_ruby_2_4_2
set_ruby_2_4_2_as_global
install_bundler

echo "Done."
