#!/bin/bash

# Use the environmental variables passed to the Docker container and use them to:

# Configure path to webapp
sed -i -e "s%APP_DIR%$APP_DIR%g" $WEBROOT/config.php

# Set correct permissions on database directory
chown www-data $APP_DIR/app/db 

# Add root user
echo "$auth_config['root'] = '$P$BUqxGuzR2VfbSvOtjxlwsHTLIMTmuw0';" >> $WEBROOT/config.php


# Fire up PHP and then start Nginx in non daemon mode so docker has something to keep running
echo ""
echo "*** Configuration of the Munki Report php file complete ***"
echo ""
echo "*** Starting php5-fpm ***"
service php5-fpm restart
echo ""
echo "*** Starting NginX ***"
nginx
