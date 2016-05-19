# !!!!! DO NOT USE THIS IN PRODUCTION !!!!!
# 
# Dockerfile with ViSH, an open source e-Learning platform http://vishub.org
# 
# Steps to install:
# https://github.com/ging/vish/wiki/ViSH-Installation-Linux#search_engine
 
FROM ubuntu:14.04

MAINTAINER Karine Pires <karine.pires@alterway.fr>

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		software-properties-common \
		python-software-properties && \
	apt-add-repository ppa:brightbox/ruby-ng && \
	apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
		make \
		git-core \
		ruby2.2 \
		ruby2.2-dev \
		libxml2-dev \
		libxslt-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmysqlclient-dev \
		libsqlite3-dev \
		imagemagick \
		libpq-dev \
		nodejs

RUN git clone https://github.com/ging/vish.git

WORKDIR vish

RUN gem install bundler
RUN bundle install
RUN cp config/application_config.yml.example config/application_config.yml

# Database MySQL

RUN echo mysql-server mysql-server/root_password password| debconf-set-selections && \
	echo mysql-server mysql-server/root_password_again password| debconf-set-selections && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server libdbd-mysql-ruby && \
	service mysql start && \
	mysql -u root -e "create database vish_development;" && \
	cp config/database.yml.example config/database.yml  && \
	bundle exec rake db:schema:load && \
	bundle exec rake db:migrate

# Sphinx
 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y sphinxsearch && \
	service mysql start && \
	service sphinxsearch start && \
	bundle exec rake ts:index && \
	bundle exec rake ts:config && \
	bundle exec rake ts:rebuild

# Install db
# And populate with data
RUN service mysql start && \
	bundle exec rake db:install && \
	bundle exec rake db:populate

RUN gem install rails

EXPOSE 3000

CMD service mysql start && \
	bundle exec rake ts:rebuild && \
	rails s
