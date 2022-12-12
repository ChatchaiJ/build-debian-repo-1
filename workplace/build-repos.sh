#!/bin/bash

REPODIR="/srv/repos/apt/debian"
CONF="$(mktemp /tmp/repos-XXXXXX.conf)"
APACHECONFDIR="/etc/apache2/conf-available"

cat <<EOT > $CONF
# /etc/apache2/conf-available/repos.conf
Alias /debian $REPODIR

<Directory /srv/repos/ >
        # We want the user to be able to browse the directory manually
        Options Indexes FollowSymLinks Multiviews
        Require all granted
</Directory>

<Directory "${REPODIR}/db/">
        Require all denied
</Directory>

<Directory "${REPODIR}/conf/">
        Require all denied
</Directory>

<Directory "${REPODIR}/incoming/">
        Require all denied
</Directory>
EOT

#### --- setup repository here --- ####

sudo apt-get install -y apache2

[ ! -d "${APACHECONFDIR}" ]							&& \
	echo "Apache2 conf directory is not available, is it installed?"	&& \
	exit

[ ! -d "${REPODIR}" ] && sudo mkdir -p ${REPODIR}

sudo mv -f $CONF /etc/apache2/conf-available/repos.conf

sudo a2enconf repos
sudo apachectl configtest		|| { echo "apache configtest failed"; exit; }
sudo service apache2 reload

#### --- allow hosts to access these ports --- ####

sudo ufw allow http
sudo ufw allow https
