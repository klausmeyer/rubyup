FROM ubuntu:19.04

RUN apt-get update \
 && apt-get install -y autoconf automake bison build-essential curl gawk git libffi-dev libgdbm-dev liblzma-dev \
      libmysqlclient-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev libtool libyaml-dev mysql-client \
      patch pkg-config ruby-dev sqlite3 sudo zlib1g-dev \
 && useradd -m rubyup -s /bin/bash \
 && echo 'rubyup    ALL= NOPASSWD: ALL' > /etc/sudoers.d/rubyup \
 && rm -rf /var/lib/apt/lists/*

USER rubyup

RUN gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys \
      409B6B1796C275462A1703113804BB82D39DC0E3 \
      7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 && curl -sSL https://get.rvm.io | bash -s stable
