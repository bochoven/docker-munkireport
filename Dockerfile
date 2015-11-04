# Dockerfile for MunkiReport-PHP
# This docker image will take environmental variables
# in order to send data to an external MySQL database
# simply provide the db name, username, password and server address

# Version 0.6 - 10-06-2015
# MR-PHP Version 2.4.3 (June 2, 2015)

FROM ubuntu:latest
MAINTAINER Calum Hunter <calum.h@gmail.com>

# Set Environmental variables
ENV DEBIAN_FRONTEND noninteractive

# Set Env variables for Munki Report Config
ENV VERSION v2.6.0
ENV APP_DIR /home/munkireport
ENV WEBROOT /www/munkireport
ENV DB_NAME munkireport
ENV DB_USER admin
ENV DB_PASS password
ENV DB_SERVER sql.test.internal
ENV MR_SITENAME MunkiReport
ENV MR_TIMEZONE America/Los_Angeles
ENV MR_TEMPERATURE_UNIT F
ENV MR_CLIENT_PASSPHRASES_REQUIRED NO
ENV MR_KEEP_PREVIOUS_DISPLAYS FALSE
ENV MR_MODULES "array('munkireport','diskinfo')"
ENV MR_AUTH_SECURE FALSE
# Define proxy setting variables for Munki report
# set this to mod1, mod2 or no depending upon your proxy server needs. See the Readme for more info.
ENV proxy_required no
ENV proxy_server proxy.example.com
ENV proxy_uname proxyuser
ENV proxy_pword proxypassword
ENV proxy_port 8080
ENV MR_LDAP no

# Install base packages for MR
RUN apt-get update && \
	apt-get -y install \
	nginx \
	nano \
	curl \
	git \
	php5-fpm \
	php5-mysql \
	php5-sqlite \
	php5-ldap && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Create a place to put MunkiReport and clone the repo into it.
# Make folder for enabled sites in nginx
# Add line to php config to prevent blank page
# Fix PHP CGI pathinfo
RUN mkdir -p $APP_DIR && \
	mkdir -p $WEBROOT && \
	git clone https://github.com/munkireport/munkireport-php $APP_DIR && \
	cd $APP_DIR && \
	git checkout tags/$VERSION && \
	mkdir -p /etc/nginx/sites-enabled/ && \
	rm -rf /etc/nginx/sites-enabled/* && \
	rm -rf /etc/nginx/nginx.conf && \
	sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini

# Symlink index.php
RUN ln -sf $APP_DIR/index.php $WEBROOT/index.php

# Symlink assets dir
RUN ln -sf $APP_DIR/assets $WEBROOT/assets

# Add our config.php file and nginx configs
ADD docker/config.php $APP_DIR/config.php
ADD docker/munki-report.conf /etc/nginx/sites-enabled/munki-report.conf
ADD docker/nginx.conf /etc/nginx/nginx.conf

# Set up logs to output to stout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

# Add our startup script
ADD docker/start.sh /start.sh
RUN chmod +x /start.sh

# Expose Ports
EXPOSE 80 443

# Run our startup script
CMD ["/start.sh"]
