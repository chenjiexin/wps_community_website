#!/bin/bash
# setup.sh will load config/setup.conf to get setup info

if [ "x$USER" != "xroot" ]; then
    exec sudo ./$0 "$@"
fi

unset LC_ADDRESS LC_IDENTIFICATION LC_MEASUREMENT LC_MONETARY LC_NAME 
unset LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME
unset LANGUAGE
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

set -e

function die()
{
    echo "Error: $@" > /dev/stderr
    exit 1
}

function config_file()
{
    sed "s/@USER@/${x_user}/g; s/@GROUP@/${x_group}/g; s#@ROOT@#${x_root}#g;" < "$1" > "$2"
    chmod --reference="$1" "$2"
}

x_user="www-data"
x_group="www-data"
x_root="/var/www"
[ -f "config/setup.conf" ] && source config/setup.conf

# check root directory
[ "x$(pwd)" == "x${x_root}" ] || die "website must be installed to ${x_root}"

# check required software
which nginx || die "can not found nginx"
which fcgiwrap || die "can not found fcgiwrap"
which php5-fpm || die "can not found php5-fpm"
which ruby || die "can not found ruby"
which php5-cgi || die "can not found php5-cgi"
echo "<?php curl_init() ?>" | php5-cgi || die "can not found php5-curl"
echo "<?php mysql_connect() ?>" | php5-cgi || die "can not found php5-mysql"

# stop system's http serve
/etc/init.d/lighttpd-wps-community stop
/etc/init.d/lighttpd stop
update-rc.d lighttpd disable
/etc/init.d/nginx stop

# create own serve
update-rc.d -f lighttpd-wps-community remove
config_file "setup/nginx.conf" "/etc/nginx/sites-available/wps_community"
if [ ! -d "/etc/nginx/sites-enabled/wps_community" ]; then
    rm -rf "/etc/nginx/sites-enabled/wps_community"
    ln -s "/etc/nginx/sites-available/wps_community" "/etc/nginx/sites-enabled/wps_community"
fi
rm -rf "/etc/nginx/sites-enabled/default"
#config_file "setup/lighttpd.init" "/etc/init.d/lighttpd-wps-community"
#config_file "setup/lighttpd.conf" "config/lighttpd.conf"
#update-rc.d lighttpd-wps-community start 09 2 3 4 5 . stop 09 0 1 6 .
#update-rc.d lighttpd-wps-community enable

# change own of /var/www
chown -R ${x_user}:${x_group} "${x_root}"

# start server
if ! /etc/init.d/fcgiwrap status; then
	/etc/init.d/fcgiwrap start
fi
if ! /etc/init.d/php5-fpm status; then
	/etc/init.d/php5-fpm start
fi
if ! /etc/init.d/nginx status; then
	/etc/init.d/nginx start
else
	/etc/init.d/nginx reload
fi

echo "Setup completed!"
echo "Hint: Read setup/forum/README.md to configure forum"

