#!/bin/bash
#set env
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH
#install need root user.
if [ `whoami` != "root" ];then
        echo "Installtion this package needs root user."
        exit 1
fi
#ver
mysql_ver="5.6.13"
wget http://www.mysql.com/get/Downloads/MySQL-5.6/mysql-${mysql_ver}.tar.gz

#
#which dialog >/dev/null 2>&1
#if [[ $? -ne 0 ]]
#then
#echo "Please install dialog  yum install -y dialog"
#exit
#fi
#download software
#mkdir -p ./packages
#if [ -s packages/mysql-${mysql_ver}.tar.gz ]; then
#  echo "$i [found]"
#else
#  echo "Error: $i not found!!!download now......"
#  wget  http://s001.aojian.niua.com:8181/aojianinstall/mysql-${mysql_ver}.tar.gz -P packages/
#fi

#complier mysql
cd /tmp/

tar zxvf mysql-${mysql_ver}.tar.gz
cd mysql-${mysql_ver}

/usr/sbin/groupadd mysql -g 27
/usr/sbin/useradd -u 27 -g mysql -c "MySQL Server" mysql -s /sbin/nologin

#autoreconf --force --install
#libtoolize --automake --force
#automake --force --add-missing
#CHOST="x86_64-pc-linux-gnu"
#CFLAGS="-march=nocona -O3 -pipe"
#CXXFLAGS="${CFLAGS}"
CXX=gcc \
CHOST="x86_64-pc-linux-gnu" \
CFLAGS=" -O3 \
-fomit-frame-pointer \
-pipe \
-march=nocona \
-mfpmath=sse \
-m128bit-long-double \
-mmmx \
-msse \
-msse2 \
-maccumulate-outgoing-args \
-m64 \
-ftree-loop-linear \
-fprefetch-loop-arrays \
-freg-struct-return \
-fgcse-sm \
-fgcse-las \
-frename-registers \
-fforce-addr \
-fivopts \
-ftree-vectorize \
-ftracer \
-frename-registers \
-minline-all-stringops \
-fbranch-target-load-optimize2" \
CXXFLAGS="${CFLAGS}" \

cmake . \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql-${mysql_ver} \
-DEFAULT_CHARASET=UTF8 \
-DEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii \
-DWITH_ZLIB=system \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_DEBUG=0 \
-DWITH_EMBEDDED_SERVER=1
#--prefix=/usr/local/mysql-${mysql_ver} 
#--with-server-suffix=-LTOPS \
#--with-plugins=partition,blackhole,csv,heap,innobase,myisam,myisammrg \
#--with-charset=utf8 --with-collation=utf8_general_ci \
#--with-extra-charsets=gbk,gb2312,utf8,ascii --with-big-tables \
#--with-fast-mutexes --with-zlib-dir=bundled --enable-assembler \
#--enable-profiling --enable-local-infile --enable-thread-safe-client \
#--with-readline --with-pthread --with-embedded-server \
#--with-client-ldflags=-all-static --with-mysqld-ldflags=-all-static \
#--without-geometry --without-debug 
#--without-ndb-debug

make -j8 && make install

chmod +w /usr/local/mysql-${mysql_ver}/
chown -R mysql:mysql /usr/local/mysql-${mysql_ver}/
cd ../../

mkdir -p /data/mysql/3306/{data,logs/{binlog,relaylog}}
chown -R mysql:mysql /data/mysql/
chmod -R 755 /usr/local/mysql-${mysql_ver}/data

#copy cnf and scripts.
rm /etc/my.cnf -rf
\cp /tmp/mysql-${mysql_ver}/support-files/my-default.cnf /data/mysql/3306/my.cnf
echo "datadir = /data/mysql/3306/data/"  | cat >> /data/mysql/3306/my.cnf
\cp /tmp/mysql-${mysql_ver}/support-files/mysql.server.sh /data/mysql/3306/mysql

chown -R mysql:mysql /data/mysql/
ln -s /data/mysql/3306/my.cnf /etc/

/usr/local/mysql-${mysql_ver}/scripts/mysql_install_db --basedir=/usr/local/mysql-${mysql_ver}/ --datadir=/data/mysql/3306/data --user=mysql --defaults-file=/data/mysql/3306/my.cnf

#setting start scripts

if [ -d "/etc/init.d/mysqld" ]; then
	echo "没有原有 \"/etc/init.d/mysqld\" 文件"
else 
	echo "删除原有 \"/etc/init.d/mysqld\" 文件"
	rm /etc/init.d/mysqld -rf
fi
\cp /tmp/mysql-${mysql_ver}/support-files/mysql.server /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
chkconfig --add mysqld
/etc/init.d/mysqld start > /dev/null 2>&1 

#for ln

rm -rf /usr/bin/mysql* 2>&1
cd /usr/local/mysql-${mysql_ver}/bin/
for i in *; do rm /usr/bin/$i -rf;ln -s /usr/local/mysql-${mysql_ver}/bin/$i /usr/bin/$i; done
echo "---------------------------------------------------------"
pwd
cd -
echo "--------------------------------------------------------"
pwd

#ask password
mysqlrootpwd="admin"
#if [ "$mysqladminpwd" = "" ]; then
#     mysqladminpwd=""
#fi
printf "\n"
#setting password
exec 4>&1 ;mysqladminpwd='admin'

mysql -S /tmp/mysql.sock -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${mysqladminpwd}'";
mysql -S /tmp/mysql.sock -uroot -p${mysqladminpwd} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '${mysqladminpwd}'";
#mysqladmin create account
#mysqladmin create `character`
#mysqladmin create gamedata
#mysqladmin create gamelog
echo
echo "project db is create ok!"

#sed -i "/mysql_password=/ {s/.*/mysql_password=\"${mysqladminpwd}\"/}" /etc/init.d/mysql
echo -en "\033[39;49;0m"
echo "All is done!"
echo "Your password root : ${mysqladminpwd}"
echo "You Can input : mysql -uroot -p${mysqladminpwd}"
