---
title: Ubuntu下安装PHP的一系列笔记
date: 2021-10-15 21:27:36
tags:
---

## 查看配置

可以通过命令查看
```
php -i | grep configure
```

```
php --ini
php -m
```


安装PHP

### 源码

下载源码包解压

```

apt -y install make
apt -y install build-essential
apt -y install libxml2-dev
apt -y install libssl-dev
apt -y install libpng-dev
apt -y install libsqlite3-dev
apt -y install zlib1g-dev  // apt-get install libbz2-dev 
apt -y install libcurl4-openssl-dev
apt -y install libtidy-dev
apt -y install autoconf
apt -y install libtool
apt -y install pkg-config
git clone https://github.com/kkos/oniguruma.git oniguruma
cd oniguruma
./autogen.sh
./configure
make
make install

```

```
sudo apt install gcc -y &&
sudo apt install make -y &&
sudo apt install openssl -y &&
sudo apt install curl -y &&
sudo apt install libbz2-dev -y &&
sudo apt install libxml2-dev -y &&
sudo apt install libjpeg-dev -y &&
sudo apt install libpng-dev -y &&
sudo apt install libfreetype6-dev -y &&
sudo apt install libzip-dev -y &&
sudo apt install libssl-dev -y &&
sudo apt install libsqlite3-dev -y &&
sudo apt install libcurl4-openssl-dev -y &&
sudo apt install libgmp3-dev -y &&
sudo apt install libonig-dev -y &&
sudo apt install libreadline-dev -y &&
sudo apt install libxslt1-dev -y &&
sudo apt install libffi-dev -y

```
模块对应的依赖（可选择性的安装）

```
xml
sudo apt-get install -y libxml2-dev
pcre
sudo apt-get install -y libpcre3-dev
jpeg
sudo apt-get install -y libjpeg62-dev
freetype
sudo apt-get install -y libfreetype6-dev
png
sudo apt-get install -y libpng12-dev libpng3 libpnglite-dev
iconv
sudo apt-get install -y libiconv-hook-dev libiconv-hook1
mycrypt
sudo apt-get install -y libmcrypt-dev libmcrypt4
mhash
sudo apt-get install -y libmhash-dev libmhash2
openssl
sudo apt-get install -y libltdl-dev libssl-dev
curl
sudo apt-get install -y libcurl4-openssl-dev
mysql
sudo apt-get install -y libmysqlclient-dev
imagick
sudo apt-get install -y libmagickcore-dev libmagickwand-dev
readline
sudo apt-get install -y libedit-dev
ubuntu 无法找到 iconv
sudo ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so
sudo ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so.1
安装PHP扩展
sudo apt-get install -y autoconf automake m4

```

去掉单引号后如下

```
./configure --prefix=/usr/local/php/81 --with-config-file-path=/usr/local/php/81/etc --enable-pcntl --enable-fpm --enable-inline-optimization --disable-debug --disable-rpath --enable-shared  --with-xmlrpc --with-mhash --with-sqlite3 --with-zlib --enable-bcmath --with-iconv --with-bz2 --with-openssl --enable-calendar --with-curl --with-cdb --enable-dom --enable-exif --enable-fileinfo --enable-filter --with-openssl-dir --with-zlib-dir --enable-gd-jis-conv --with-gettext --with-gmp --with-mhash --enable-json --enable-mbstring --enable-mbregex --enable-pdo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pdo-sqlite --with-readline --enable-session --enable-shmop --enable-simplexml --enable-sockets  --enable-sysvmsg --enable-sysvsem --enable-sysvshm --with-xsl --enable-mysqlnd-compression-support --with-pear --enable-opcache --with-zip --enable-gd --with-ffi
```

```
make -j && make install
```

配置文件

```
cp php.ini-development /usr/local/php/8.1/etc/php.ini 
cd /opt/php/74/etc && cp php-fpm.conf.default php-fpm.conf
cd /opt/php/74/etc/php-fpm.d && cp www.conf.default www.conf
```
vim /opt/php/74/etc/php-fpm.conf，pid = run/php-fpm.pid  #去掉；
```
pid = run/php-fpm.pid
```
vim /opt/php/74/etc/php-fpm.d/www.conf

增加
```
user = www
group = www
```
增加php环境变量(我使用的zsh 如果是bash 请编辑 .bashrc 文件 )
```
vim ~/.zshrc
```
加入
```
export PHP_HOME=/opt/php/74
export PATH=$PHP_HOME/bin:$PATH
```

增加www用户用户组
```
sudo groupadd www
sudo useradd -g www www
```

php-fpm服务化（Systemd）
```
sudo touch /lib/systemd/system/php-fpm.service
sudo vim /lib/systemd/system/php-fpm.service
```

```
[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=forking
PIDFile=/opt/php/74/var/run/php-fpm.pid
ExecStart=/opt/php/74/sbin/php-fpm
ExecReload=/bin/kill -USR2 $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

服务开机启动
```
sudo systemctl enable php-fpm.service
```
启动、停止、重启、状态

```
sudo systemctl start php-fpm.service
sudo systemctl stop php-fpm.service
sudo systemctl restart php-fpm.service
sudo systemctl status php-fpm.service
```

参考：https://blog.csdn.net/hiqiming/article/details/105245227

### apt安装

首先，请确保您的系统中具有**add-apt-repository**命令实用程序。

```markup
sudo apt-get install software-properties-common
```

现在，您可以添加存储库并更新系统中的程序包缓存。

```markup
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
```

最后，要在Linux系统中安装PHP 8，请使用安装命令。

```markup
sudo apt install php8.1
```

## 安装pecl

```
wget http://pear.php.net/go-pear.phar
php go-pear.phar
```

或者

```
apt install php-pear
```

## 安装扩展

### amqp

#### 准备

怼最新版
https://github.com/alanxz/rabbitmq-c/releases

下载后解压

#### 安装

没有安装cmake的需要先安装
```shell
apt install cmake
```

解压后进入解压目录执行

```shell
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/rabbitmq-c ..
make && make install 
```

> pecl

```php
pecl install amqp
```
指定下librabbmitmq的位置，回车再按照添加配置

> 源码

pecl下载源码包，

```php
phpize
./configure --with-php-config=/path-to/php-config --with-amqp --with-librabbitmq-dir=/usr/local/rabbitmq-c
```

源码安装如果报错
```
/usr/local/rabbitmq-c-0.11.0/lib -lrabbitmq
...
/usr/bin/ld: cannot find -lrabbitmq
```

那就找到rabbitmq-c的链接库做下软连接

```
ln -s /usr/local/rabbitmq-c-0.11.0/lib/x86_64-linux-gnu/librabbitmq.so /usr/local/rabbitmq-c-0.11.0/lib/
ln -s /usr/local/rabbitmq-c-0.11.0/lib/x86_64-linux-gnu/librabbitmq.so.4 /usr/local/rabbitmq-c-0.11.0/lib/
```

## pecl卸载扩展

```
pecl uninstall swoole
```

### fpm配置

添加到服务项

```
cp php-fpm.service /etc/systemd/system/

```

```
service php-fpm start
service php-fpm stop
service php-fpm restart
service php-fpm reload
```

## 报错解决方案

- php拓展安装报错：Warning: PHP Startup: Invalid library (maybe not a PHP library) '*.so' in Unknown on lin

解决方法：make clean    然后重新phpize,configure --with-php-config=,make,make install走安装流

## 编译参数

```
`configure' configures PHP 7.4.0-dev to adapt to many kinds of systems.
 
Usage: ./configure [OPTION]... [VAR=VALUE]...
 
To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.
 
Defaults for the options are specified in brackets.
 
Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or `..']
 
Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]
 
By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.
 
For better control, use the options below.
 
Fine tuning of the installation directories:
  --bindir=DIR            user executables [EPREFIX/bin]
  --sbindir=DIR           system admin executables [EPREFIX/sbin]
  --libexecdir=DIR        program executables [EPREFIX/libexec]
  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
  --libdir=DIR            object code libraries [EPREFIX/lib]
  --includedir=DIR        C header files [PREFIX/include]
  --oldincludedir=DIR     C header files for non-gcc [/usr/include]
  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
  --infodir=DIR           info documentation [DATAROOTDIR/info]
  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
  --mandir=DIR            man documentation [DATAROOTDIR/man]
  --docdir=DIR            documentation root [DATAROOTDIR/doc/php]
  --htmldir=DIR           html documentation [DOCDIR]
  --dvidir=DIR            dvi documentation [DOCDIR]
  --pdfdir=DIR            pdf documentation [DOCDIR]
  --psdir=DIR             ps documentation [DOCDIR]
 
Program names:
  --program-prefix=PREFIX            prepend PREFIX to installed program names
  --program-suffix=SUFFIX            append SUFFIX to installed program names
  --program-transform-name=PROGRAM   run sed PROGRAM on installed program names
 
System types:
  --build=BUILD     configure for building on BUILD [guessed]
  --host=HOST       cross-compile to build programs to run on HOST [BUILD]
  --target=TARGET   configure for building compilers for TARGET [HOST]
 
Optional Features and Packages:
  --disable-option-checking  ignore unrecognized --enable/--with options
  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --with-libdir=NAME      Look for libraries in .../NAME rather than .../lib
  --disable-rpath         Disable passing additional runtime library search
                          paths
  --enable-re2c-cgoto     Enable -g flag to re2c to use computed goto gcc
                          extension
  --disable-gcc-global-regs
                          whether to enable GCC global register variables
 
SAPI modules:
 
  --with-apxs2[=FILE]     Build shared Apache 2.0 Handler module. FILE is the
                          optional pathname to the Apache apxs tool [apxs]
  --disable-cli           Disable building CLI version of PHP (this forces
                          --without-pear)
  --enable-embed[=TYPE]   EXPERIMENTAL: Enable building of embedded SAPI
                          library TYPE is either 'shared' or 'static'.
                          [TYPE=shared]
  --enable-fpm            Enable building of the fpm SAPI executable
  --with-fpm-user[=USER]  Set the user for php-fpm to run as. (default:
                          nobody)
  --with-fpm-group[=GRP]  Set the group for php-fpm to run as. For a system
                          user, this should usually be set to match the fpm
                          username (default: nobody)
  --with-fpm-systemd      Activate systemd integration
  --with-fpm-acl          Use POSIX Access Control Lists
  --with-litespeed        Build PHP as litespeed module
  --enable-phpdbg         Build phpdbg
  --enable-phpdbg-webhelper
                          Build phpdbg web SAPI support
  --enable-phpdbg-debug   Build phpdbg in debug mode
  --enable-phpdbg-readline
                          Enable readline support in phpdbg (depends on static
                          ext/readline)
  --disable-cgi           Disable building CGI version of PHP
  --with-valgrind=DIR     Enable valgrind support
 
General settings:
 
  --enable-gcov           Enable GCOV code coverage (requires LTP) - FOR
                          DEVELOPERS ONLY!!
  --enable-debug          Compile with debugging symbols
  --enable-rtld-now       Use dlopen with RTLD_NOW instead of RTLD_LAZY
  --with-layout=TYPE      Set how installed files will be laid out. Type can
                          be either PHP or GNU [PHP]
  --with-config-file-path=PATH
                          Set the path in which to look for php.ini
                          [PREFIX/lib]
  --with-config-file-scan-dir=PATH
                          Set the path where to scan for configuration files
  --enable-sigchild       Enable PHP's own SIGCHLD handler
  --enable-libgcc         Enable explicitly linking against libgcc
  --disable-short-tags    Disable the short-form <? start tag by default
  --enable-dmalloc        Enable dmalloc
  --disable-ipv6          Disable IPv6 support
  --enable-dtrace         Enable DTrace support
  --enable-fd-setsize     Set size of descriptor sets
 
Extensions:
 
  --with-EXTENSION=shared[,PATH]
 
    NOTE: Not all extensions can be build as 'shared'.
 
    Example: --with-foobar=shared,/usr/local/foobar/
 
      o Builds the foobar extension as shared extension.
      o foobar package install prefix is /usr/local/foobar/
 
 
  --disable-all           Disable all extensions which are enabled by default
  --disable-libxml        Disable LIBXML support
  --with-libxml-dir[=DIR] LIBXML: libxml2 install prefix
  --with-openssl          Include OpenSSL support (requires OpenSSL >= 1.0.1)
  --with-kerberos[=DIR]   OPENSSL: Include Kerberos support
  --with-system-ciphers   OPENSSL: Use system default cipher list instead of
                          hardcoded value
  --with-external-pcre    Use external library for PCRE support
  --with-pcre-jit         Enable PCRE JIT functionality
  --with-pcre-valgrind=DIR
                          Enable PCRE valgrind support. Developers only!
  --without-sqlite3[=DIR] Do not include SQLite3 support. DIR is the prefix to
                          SQLite3 installation directory.
  --with-zlib             Include ZLIB support (requires zlib >= 1.2.0.4)
  --enable-bcmath         Enable bc style precision math functions
  --with-bz2[=DIR]        Include BZip2 support
  --enable-calendar       Enable support for calendar conversion
  --disable-ctype         Disable ctype functions
  --with-curl             Include cURL support
  --enable-dba            Build DBA with bundled modules. To build shared DBA
                          extension use --enable-dba=shared
  --with-qdbm[=DIR]       DBA: QDBM support
  --with-gdbm[=DIR]       DBA: GDBM support
  --with-ndbm[=DIR]       DBA: NDBM support
  --with-db4[=DIR]        DBA: Oracle Berkeley DB 4.x or 5.x support
  --with-db3[=DIR]        DBA: Oracle Berkeley DB 3.x support
  --with-db2[=DIR]        DBA: Oracle Berkeley DB 2.x support
  --with-db1[=DIR]        DBA: Oracle Berkeley DB 1.x support/emulation
  --with-dbm[=DIR]        DBA: DBM support
  --with-tcadb[=DIR]      DBA: Tokyo Cabinet abstract DB support
  --with-lmdb[=DIR]       DBA: Lightning memory-mapped database support
  --without-cdb[=DIR]     DBA: CDB support (bundled)
  --disable-inifile       DBA: INI support (bundled)
  --disable-flatfile      DBA: FlatFile support (bundled)
  --disable-dom           Disable DOM support
  --with-libxml-dir[=DIR] DOM: libxml2 install prefix
  --with-enchant[=DIR]    Include enchant support. GNU Aspell version 1.1.3 or
                          higher required.
  --enable-exif           Enable EXIF (metadata from images) support
  --with-ffi              Include FFI support
  --disable-fileinfo      Disable fileinfo support
  --disable-filter        Disable input filter support
  --enable-ftp            Enable FTP support
  --with-openssl-dir[=DIR]
                          FTP: openssl install prefix
  --enable-gd             Include GD support
  --with-external-gd      Use external libgd
  --with-webp             GD: Enable WEBP support
  --with-jpeg             GD: Enable JPEG support
  --with-xpm              GD: Enable XPM support
  --with-freetype         GD: Enable FreeType 2 support
  --enable-gd-jis-conv    GD: Enable JIS-mapped Japanese font support
  --with-gettext[=DIR]    Include GNU gettext support
  --with-gmp[=DIR]        Include GNU MP support
  --with-mhash[=DIR]      Include mhash support
  --without-iconv[=DIR]   Exclude iconv support
  --with-imap[=DIR]       Include IMAP support. DIR is the c-client install
                          prefix
  --with-kerberos[=DIR]   IMAP: Include Kerberos support. DIR is the Kerberos
                          install prefix
  --with-imap-ssl[=DIR]   IMAP: Include SSL support. DIR is the OpenSSL
                          install prefix
  --with-interbase[=DIR]  Include Firebird support. DIR is the Firebird base
                          install directory [/opt/firebird]
  --enable-intl           Enable internationalization support
  --disable-json          Disable JavaScript Object Serialization support
  --with-ldap[=DIR]       Include LDAP support
  --with-ldap-sasl[=DIR]  LDAP: Include Cyrus SASL support
  --enable-mbstring       Enable multibyte string support
  --disable-mbregex       MBSTRING: Disable multibyte regex support
  --with-mysqli[=FILE]    Include MySQLi support. FILE is the path to
                          mysql_config. If no value or mysqlnd is passed as
                          FILE, the MySQL native driver will be used
  --with-mysql-sock[=SOCKPATH]
                          MySQLi/PDO_MYSQL: Location of the MySQL unix socket
                          pointer. If unspecified, the default locations are
                          searched
  --with-oci8[=DIR]       Include Oracle Database OCI8 support. DIR defaults
                          to $ORACLE_HOME. Use
                          --with-oci8=instantclient,/path/to/instant/client/lib
                          to use an Oracle Instant Client installation
  --with-odbcver[=HEX]    Force support for the passed ODBC version. A hex
                          number is expected, default 0x0350. Use the special
                          value of 0 to prevent an explicit ODBCVER to be
                          defined.
  --with-adabas[=DIR]     Include Adabas D support [/usr/local]
  --with-sapdb[=DIR]      Include SAP DB support [/usr/local]
  --with-solid[=DIR]      Include Solid support [/usr/local/solid]
  --with-ibm-db2[=DIR]    Include IBM DB2 support [/home/db2inst1/sqllib]
  --with-empress[=DIR]    Include Empress support $EMPRESSPATH (Empress
                          Version >= 8.60 required)
  --with-empress-bcs[=DIR]
                          Include Empress Local Access support $EMPRESSPATH
                          (Empress Version >= 8.60 required)
  --with-custom-odbc[=DIR]
                          Include user defined ODBC support. DIR is ODBC
                          install base directory [/usr/local]. Make sure to
                          define CUSTOM_ODBC_LIBS and have some odbc.h in your
                          include dirs. f.e. you should define following for
                          Sybase SQL Anywhere 5.5.00 on QNX, prior to running
                          this configure script: CPPFLAGS="-DODBC_QNX
                          -DSQLANY_BUG" LDFLAGS=-lunix
                          CUSTOM_ODBC_LIBS="-ldblib -lodbc"
  --with-iodbc[=DIR]      Include iODBC support [/usr/local]
  --with-esoob[=DIR]      Include Easysoft OOB support
                          [/usr/local/easysoft/oob/client]
  --with-unixODBC[=DIR]   Include unixODBC support [/usr/local]
  --with-dbmaker[=DIR]    Include DBMaker support
  --disable-opcache       Disable Zend OPcache support
  --disable-huge-code-pages
                          Disable copying PHP CODE pages into HUGE PAGES
  --enable-pcntl          Enable pcntl support (CLI/CGI only)
  --disable-pdo           Disable PHP Data Objects support
  --with-pdo-dblib[=DIR]  PDO: DBLIB-DB support. DIR is the FreeTDS home
                          directory
  --with-pdo-firebird[=DIR]
                          PDO: Firebird support. DIR is the Firebird base
                          install directory [/opt/firebird]
  --with-pdo-mysql[=DIR]  PDO: MySQL support. DIR is the MySQL base directory.
                          If no value or mysqlnd is passed as DIR, the MySQL
                          native driver will be used
  --with-zlib-dir[=DIR]   PDO_MySQL: Set the path to libz install prefix
  --with-pdo-oci[=DIR]    PDO: Oracle OCI support. DIR defaults to
                          $ORACLE_HOME. Use
                          --with-pdo-oci=instantclient,/path/to/instant/client/lib
                          for an Oracle Instant Client installation.
  --with-pdo-odbc=flavour,dir
                          PDO: Support for 'flavour' ODBC driver. The include
                          and lib dirs are looked for under 'dir'. The
                          'flavour' can be one of: ibm-db2, iODBC, unixODBC,
                          generic. If ',dir' part is omitted, default for the
                          flavour you have selected will be used. e.g.:
                          --with-pdo-odbc=unixODBC will check for unixODBC
                          under /usr/local. You may attempt to use an
                          otherwise unsupported driver using the 'generic'
                          flavour. The syntax for generic ODBC support is:
                          --with-pdo-odbc=generic,dir,libname,ldflags,cflags.
                          When built as 'shared' the extension filename is
                          always pdo_odbc.so
  --with-pdo-pgsql[=DIR]  PDO: PostgreSQL support. DIR is the PostgreSQL base
                          install directory or the path to pg_config
  --without-pdo-sqlite[=DIR]
                          PDO: sqlite 3 support. DIR is the sqlite base
                          install directory [BUNDLED]
  --with-pgsql[=DIR]      Include PostgreSQL support. DIR is the PostgreSQL
                          base install directory or the path to pg_config
  --disable-phar          Disable phar support
  --disable-posix         Disable POSIX-like functions
  --with-pspell[=DIR]     Include PSPELL support. GNU Aspell version 0.50.0 or
                          higher required
  --with-libedit          Include libedit readline replacement (CLI/CGI only)
  --with-readline[=DIR]   Include readline support (CLI/CGI only)
  --with-recode[=DIR]     Include recode support
  --disable-session       Disable session support
  --with-mm[=DIR]         SESSION: Include mm support for session storage
  --enable-shmop          Enable shmop support
  --disable-simplexml     Disable SimpleXML support
  --with-libxml-dir=DIR   SimpleXML: libxml2 install prefix
  --with-snmp[=DIR]       Include SNMP support
  --with-openssl-dir[=DIR]
                          SNMP: openssl install prefix
  --enable-soap           Enable SOAP support
  --with-libxml-dir=DIR   SOAP: libxml2 install prefix
  --enable-sockets        Enable sockets support
  --with-sodium[=DIR]     Include sodium support
  --with-password-argon2[=DIR]
                          Include Argon2 support in password_*. DIR is the
                          Argon2 shared library path
  --enable-sysvmsg        Enable sysvmsg support
  --enable-sysvsem        Enable System V semaphore support
  --enable-sysvshm        Enable the System V shared memory support
  --with-tidy[=DIR]       Include TIDY support
  --disable-tokenizer     Disable tokenizer support
  --disable-xml           Disable XML support
  --with-libxml-dir=DIR   XML: libxml2 install prefix
  --with-libexpat-dir=DIR XML: libexpat install prefix (deprecated)
  --disable-xmlreader     Disable XMLReader support
  --with-libxml-dir=DIR   XMLReader: libxml2 install prefix
  --with-xmlrpc[=DIR]     Include XMLRPC-EPI support
  --with-libxml-dir=DIR   XMLRPC-EPI: libxml2 install prefix
  --with-libexpat-dir=DIR XMLRPC-EPI: libexpat dir for XMLRPC-EPI (deprecated)
  --with-iconv-dir=DIR    XMLRPC-EPI: iconv dir for XMLRPC-EPI
  --disable-xmlwriter     Disable XMLWriter support
  --with-libxml-dir=DIR   XMLWriter: libxml2 install prefix
  --with-xsl[=DIR]        Include XSL support. DIR is the libxslt base install
                          directory (libxslt >= 1.1.0 required)
  --enable-zend-test      Enable zend-test extension
  --enable-zip            Include Zip read/write support
  --with-libzip[=DIR]     ZIP: use libzip
  --enable-mysqlnd        Enable mysqlnd explicitly, will be done implicitly
                          when required by other extensions
  --disable-mysqlnd-compression-support
                          Disable support for the MySQL compressed protocol in
                          mysqlnd
  --with-zlib-dir[=DIR]   mysqlnd: Set the path to libz install prefix
 
PEAR:
 
  --with-pear[=DIR]       Install PEAR in DIR [PREFIX/lib/php]
 
Zend:
 
  --enable-maintainer-zts Enable thread safety - for code maintainers only!!(安全线程)
  --disable-inline-optimization
                          If building zend_execute.lo fails, try this switch
  --disable-zend-signals  whether to enable zend signal handling
 
TSRM:
 
  --with-tsrm-pth[=pth-config]
                          Use GNU Pth
  --with-tsrm-st          Use SGI's State Threads
  --with-tsrm-pthreads    Use POSIX threads (default)
 
Libtool:
 
  --enable-shared=PKGS    Build shared libraries default=yes
  --enable-static=PKGS    Build static libraries default=yes
  --enable-fast-install=PKGS
                          Optimize for fast installation default=yes
  --with-gnu-ld           Assume the C compiler uses GNU ld default=no
  --disable-libtool-lock  Avoid locking (might break parallel builds)
  --with-pic              Try to use only PIC/non-PIC objects default=use both
  --with-tags=TAGS        Include additional configurations automatic

```

[Ubuntu 18.04 安装 php7.4 --enable-maintainer-zts](http://https://blog.csdn.net/yuxiaomin886/article/details/103821731 "Ubuntu 18.04 安装 php7.4 --enable-maintainer-zts")
[PHP 编译安装 PHP各参数配置详解](https://www.jianshu.com/p/0a79847c8151 "PHP 编译安装 PHP各参数配置详解")