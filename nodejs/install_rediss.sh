#!/bin/bash

if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this tool!\n"
    exit 1
fi
clear

wget -c http://download.redis.io/releases/redis-2.8.11.tar.gz

tar xzf redis-2.8.11.tar.gz
cd redis-2.8.11
make

# In order to install Redis binaries into /usr/local/bin just use:
make install

rm -rf /etc/redis /var/lib/redis
mkdir /etc/redis /var/lib/redis

cp src/redis-server src/redis-cli /usr/local/bin
cp redis.conf /etc/redis

sed -e "s/^daemonize no$/daemonize yes/" -e "s/^# bind 127.0.0.1$/bind 127.0.0.1/" -e "s/^dir \.\//dir \/var\/lib\/redis\//" -e "s/^loglevel verbose$/loglevel notice/" -e "s/^logfile \"\"/logfile \/var\/log\/redis.log/" redis.conf > /etc/redis/redis.conf

cat >/etc/init.d/redis<<EOF
#!/bin/sh
# From - http://www.codingsteps.com/install-redis-2-6-on-amazon-ec2-linux-ami-or-centos/
# 
# redis - this script starts and stops the redis-server daemon
# Originally from - https://raw.github.com/gist/257849/9f1e627e0b7dbe68882fa2b7bdb1b2b263522004/redis-server
#
# chkconfig:   - 85 15 
# description:  Redis is a persistent key-value database
# processname: redis-server
# config:      /etc/redis/redis.conf
# config:      /etc/sysconfig/redis
# pidfile:     /var/run/redis.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "\$NETWORKING" = "no" ] && exit 0

redis="/usr/local/bin/redis-server"
prog=\$(basename \$redis)

REDIS_CONF_FILE="/etc/redis/redis.conf"

[ -f /etc/sysconfig/redis ] && . /etc/sysconfig/redis

lockfile=/var/lock/subsys/redis

start() {
    [ -x \$redis ] || exit 5
    [ -f \$REDIS_CONF_FILE ] || exit 6
    echo -n \$"Starting \$prog: "
    daemon \$redis \$REDIS_CONF_FILE
    retval=\$?
    echo
    [ \$retval -eq 0 ] && touch \$lockfile
    return \$retval
}

stop() {
    echo -n \$"Stopping \$prog: "
    killproc \$prog -QUIT
    retval=\$?
    echo
    [ \$retval -eq 0 ] && rm -f \$lockfile
    return \$retval
}

restart() {
    stop
    start
}

reload() {
    echo -n \$"Reloading \$prog: "
    killproc \$redis -HUP
    RETVAL=\$?
    echo
}

force_reload() {
    restart
}

rh_status() {
    status \$prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}

case "\$1" in
    start)
        rh_status_q && exit 0
        \$1
        ;;
    stop)
        rh_status_q || exit 0
        \$1
        ;;
    restart|configtest)
        \$1
        ;;
    reload)
        rh_status_q || exit 7
        \$1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
            ;;
    *)
        echo \$"Usage: \$0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac


EOF

chmod 755 /etc/init.d/redis

chkconfig --add redis
chkconfig --level 345 redis on


####
# To start Redis just uncomment this line
####
service redis start
