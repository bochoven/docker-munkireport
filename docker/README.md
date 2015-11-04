Munki Report PHP in a Container (WIP Version)
=============

This Docker image runs [MunkiReport PHP](https://github.com/munkireport/munkireport-php).
The container is expects the details of a MySQL database to be passed to it via environmental arguments

The Docker image is built on Ubuntu 14
It uses Nginx and php5-fpm

* Branches / versions

There are multiple branches for each version, ensure you check out the tags for each branch.

MunkiReport PHP version 2.3.0 (March 11, 2015) - Tag 2.3.0

MunkiReport PHP version 2.4.3 (June 2, 2015) - Tag 2.4.3


# Settings

Several options, such as the timezone and admin password are customizable using environment variables.

* ``MR_SITENAME``: Customise the site name for Munki Report.
* ``MR_TIMEZONE``: Customise the timezone, default is America/Los_Angeles
* ``MR_CLIENT_PASSPHRASES_REQUIRED``: Enable client passphrases (YES OR NO) defaults to NO
* ``MR_CLIENT_PASSPHRASES``: Sets the client passphrases (needs testing, should be "array('phrase1','phrase2')")
* ``MR_TEMPERATURE_UNIT``: Sets temperature Unit (C OR F) defaults to F
* ``MR_KEEP_PREVIOUS_DISPLAYS``: Keep Previous Displays (TRUE OR FALSE) defaults to FALSE
* ``MR_MODULES``: Set active Modules (needs testing, should be "array('phrase1','phrase2')") defaults to munkireport & diskinfo
* ``MR_AUTH_SECURE`` Set to TRUE to enable HTTPS
* ``TZ`` Set Timezone
* ``MR_ADMIN_GROUPS`` Set Admin Groups
* ``MR_MANAGER_GROUPS`` Set Manager Groups
* ``MR_LDAP`` set to yes if using LDAP
* ``MR_LDAP_SERVER`` One or more servers separated by commas.
* ``MR_LDAP_USER_TREE`` Where to find the user accounts.
* ``MR_LDAP_GROUP_TREE`` Where to find the groups.
* ``MR_LDAP_GROUPS`` For group based access, fill in groups. (use array('group1','group2'))
* ``MR_LDAP_BINDDN`` Bind DN
* ``MD_LDAP_BINDPW`` Bind PW


#####MySQL Environment Variables
These are automatically retrieved from the  MySQL Container if available.  If not you must set these manually

* ``MYSQL_ENV_MYSQL_DATABASE``: The default database name is munkireport, if you have a different database name. Set it here as per your needs. (DEFAULT from MYSQL Container)
* ``MYSQL_ENV_MYSQL_USER``: The default user to access the database with is admin. Change here as per your needs. (DEFAULT from MYSQL Container)
* ``MYSQL_ENV_MYSQL_PASSWORD``: The default user password to access the database is admin. Change here as per your needs. (DEFAULT from MYSQL Container)
* ``MYSQL_PORT_3306_TCP_ADDR``: The FQDN or IP address of the database server. ie sql.test.internal (DEFAULT from MYSQL Container)

####Proxy Variable Settings

Munki Report is able to perform warranty lookups, however if your Munki Report server is behind a proxy this may fail.
To avoid this, we can provide proxy server information as variables when starting the container or providing defaults
in the Dockerfile when building the container.

There are two methods of setting the proxy server:

Mode 1
This sets just the proxy server address and port number

Mode 2
This sets the proxy server address, port number and a username and password to use if the proxy server is an authenticated proxy

* ``proxy_required``: Set this to mod1 or mod2 depending upon which type of proxy server config you need. If no proxy set to no
* ``proxy_server``: Set this to your proxy server address in the format proxy.example.com
* ``proxy_port``: Set this to your proxy server port number
* ``proxy_uname``: Set this to your proxy username if you need to use an authenticated proxy server
* ``proxy_pword``: Set this to your proxy password if you need to use an authenticated proxy server


# Munki Report Login

If not using LDAP, The default user and password to log in to Munki Report is:

Username: ``root`` Password: ``root``

If you wish to customize the default login you can do so by spinning up MunkiReport and then going to <your_url>/index.php?/auth/generate.  
Doing so will generate a string like this:
````bash
$auth_config['test'] = '$P$BoVNNY50sXKKazabm1a7XuGgyz8Y1/1';
````

Take the username (in this case test) and set the following Variable:
``$MR_ADMIN_LOGIN = 'test'``

Take the password hash and set the following Variable:
``$MR_ADMIN_PASSWORD = 'BoVNNY50sXKKazabm1a7XuGgyz8Y1'``

If you require more advanced settings with multiple users, modify the config.php inside the docker repo as per your needs for every additional user beyond your master admin user.

# Running the container

This container requires a MYSQL container to be running first! I'm using the core MYSQL container but any container that sets the MYSQL variables listed above can work.  If it doesn't you can always specifiy them manually during startup of the Munkireport Container.

````bash
docker run --name mr-mysql \
  -v /usr/local/docker/mr-mysql:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=ih4tjoih809ZYIOUHjk;h9 \
  -e MYSQL_DATABASE=munkireport \
  -e MYSQL_USER=munkireport \
  -e MYSQL_PASSWORD=IJSDFH_(*rhojkldfn9[8]) \
  -d mysql
````



```bash
docker run -d --name munkireport \
  -p 80:80 \
  --link mr-mysql:mysql \
  -e MR_SITENAME="My Company" \
  -e MR_MODULES="array('munkireport','diskinfo','timemachine')" \
  michaelholttech/docker-munkireport:wip
```

If you need proxy server support, either bake them into your Dockerfile, or provide them as environmentals when starting your container
by passing them with the -e flag, just like the variables shown above for the DB settings.

### Thanks to [Calum Hunter]: https://github.com/hunty1/munkireport-docker for his original work on which this is based
