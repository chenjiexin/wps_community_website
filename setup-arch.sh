#!/bin/bash
# setup-arch.sh will load config/setup.conf to get setup info

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
	systemctl stop $1
}

function remove_service()
{
	stop_service "$@"
	systemctl disable $1
}

function start_service()
{
	systemctl reload-or-restart $1
}

function enable_service()
{
	systemctl enable $1
}

function disable_service()
{
	systemctl disable $1
}

function try_install()
{
	if ! pacman -S $1 ; then
		die "Cannot install $1"
	fi
}

function enable_php_options()
{
	for arg in "$@" ; do
		opt="extension=$arg.so"
		sed -i "s/;$opt/$opt/g" /etc/php/php.ini
	done

	if ! systemctl reload-or-restart lighttpd.service ; then
		systemctl enable lighttpd.service
	fi
}

x_root="$PWD"
if [ "$x_root" == "/var/www" ]; then
	x_user="www-data"
	x_group="www-data"
else
	x_user="$SUDO_USER"
	x_group="`id -G -n $SUDO_USER | awk '{print $1}'`"
fi
[ -f "config/setup.conf" ] && source config/setup.conf

# check root directory
[ "x$(pwd)" == "x${x_root}" ] || die "website must be installed to ${x_root}"

# check required software
which lighttpd || try_install lighttpd
which ruby || try_install ruby
which php5-cgi || try_install php-cgi
which markdown || try_install markdown
echo "<?php curl_init() ?>" | php5-cgi || enable_php_options curl
echo "<?php mysql_connect() ?>" | php5-cgi || enable_php_options mysql mysqli
echo "require 'mysql'" | ruby || gem install mysql

# stop system's http serve
# remove_service lighttpd-wps-community
# remove_service nginx

# create own serve
config_file "setup/lighttpd.conf" "/etc/lighttpd/lighttpd.conf"
config_file "setup/lighttpd-mimetype.conf" "/etc/lighttpd/lighttpd-mimetype.conf"
enable_service lighttpd
start_service lighttpd

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

