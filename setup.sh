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

function stop_service()
{
	if [ -x /etc/init.d/$1 ]; then
		/etc/init.d/$1 stop
	fi
}

function remove_service()
{
	stop_service "$@"
	if [ -f /etc/init.d/$1 ]; then
		update-rc.d $1 disable
	fi
}

function start_service()
{
	if /etc/init.d/$1 status; then
		/etc/init.d/$1 reload
	else
		/etc/init.d/$1 start
	fi
}

x_root="$PWD"
if [ "$x_root" == "/var/www" ]; then
	x_user="www-data"
	x_group="www-data"
else
	x_user="$SUDO_USER"
	x_group="$SUDO_USER"
fi
[ -f "config/setup.conf" ] && source config/setup.conf

# check root directory
[ "x$(pwd)" == "x${x_root}" ] || die "website must be installed to ${x_root}"

# check required software
which lighttpd || die "can not found nginx"
which ruby || die "can not found ruby"
which php5-cgi || die "can not found php5-cgi"
which markdown || die "can not found markdown"
echo "<?php curl_init() ?>" | php5-cgi || die "can not found php5-curl"
echo "<?php mysql_connect() ?>" | php5-cgi || die "can not found php5-mysql"

# stop system's http serve
remove_service lighttpd-wps-community
remove_service nginx

# create own serve
config_file "setup/lighttpd.conf" "/etc/lighttpd/lighttpd.conf"
config_file "setup/lighttpd-mimetype.conf" "/etc/lighttpd/lighttpd-mimetype.conf"
update-rc.d lighttpd start 09 2 3 4 5 . stop 09 0 1 6 .

# make 404.log if not
if [ ! -f "./log/404.log" ]; then
	touch "./log/404.log"
fi
chmod 666 "./log/404.log"

# change own of /var/www
chown -R ${x_user}:${x_group} "${x_root}"

# start service
start_service lighttpd

echo "Setup completed!"
echo "Hint: Read setup/forum/README.md to configure forum"

