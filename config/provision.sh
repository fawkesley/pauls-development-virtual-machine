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
	gnupg-curl \
	python-flake8 \
	python-virtualenv \
	virtualenvwrapper \
	imagemagick \
	clang \
	libicu-dev \
	yui-compressor
}

configure_ack() {
    sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
}

install_symlinks() {
    ln -sf /vagrant/config/bashrc /home/vagrant/.bashrc
}

atomic_download() {
    URL=$1
    DEST=$2

    TMP="$(tempfile)"

    wget -qO "${TMP}" "${URL}" && mv "${TMP}" "${DEST}"
}

install_swift() {
    SWIFT_TARBALL=/tmp/download/swift-2.2.1-RELEASE-ubuntu14.04.tar.gz
    SWIFT_URL=https://swift.org/builds/swift-2.2.1-release/ubuntu1404/swift-2.2.1-RELEASE/swift-2.2.1-RELEASE-ubuntu14.04.tar.gz

    if [ ! -f "${SWIFT_TARBALL}" ]; then
	atomic_download "${SWIFT_URL}" "${SWIFT_TARBALL}"
    fi

    mkdir -p /opt/swift
    tar --directory /opt/swift/ --extract --strip-components=2 -f "${SWIFT_TARBALL}"

    cp /vagrant/config/etc/profile.d/swift.sh /etc/profile.d/swift.sh
}

install_elixir_erlang() {
    apt-get install -y esl-erlang elixir
}

install_protobuf_3() {
    PROTOBUF_ZIP=/tmp/download/protoc-3.0.0-linux-x86_64.zip
    PROTOBUF_URL=https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip


    if [ ! -f "${PROTOBUF_ZIP}" ]; then
	atomic_download "${PROTOBUF_URL}" "${PROTOBUF_ZIP}"
    fi

    mkdir -p /opt/protobuf

    pushd /opt/protobuf
    unzip -o "${PROTOBUF_ZIP}"
    popd

    chown -R vagrant /opt/protobuf

    cp /vagrant/config/etc/profile.d/protobuf.sh /etc/profile.d/protobuf.sh
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

install_ruby_2_3_3() {
    apt install -y libreadline-dev
    run_as_vagrant "rbenv install 2.3.3"
}

run_as_vagrant() {
  su vagrant bash -l -c "$1"
}


install_symlinks
install_extra_ppas
update_package_index
install_required_packages
install_protobuf_3
configure_ack
install_swift
install_elixir_erlang
install_latest_node_v7
install_gulp_globally
install_ruby_rbenv
install_ruby_build
install_ruby_2_3_3
