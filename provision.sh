#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Update Package List

apt-get update

# Update System Packages
apt-get -y upgrade

# Force Locale

echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8 ms_MY.UTF-8

apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https \
ca-certificates

# Install Some PPAs
apt-add-repository ppa:ondrej/php -y

# Update Package Lists
apt-get update

# Install Some Basic Packages

apt-get install -y dos2unix git libmcrypt4 libpcre3-dev libpng-dev ntp unzip \
supervisor unattended-upgrades whois vim libnotify-bin \
mcrypt bash-completion zsh

# Set My Timezone

ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# Install Generic PHP packages
apt-get install -y --allow-change-held-packages \
php-imagick php-redis php-xdebug php-dev imagemagick mcrypt

# Install PHP Stuffs
apt-get install -y --allow-change-held-packages \
php8.1 php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-cli php8.1-common php8.1-curl php8.1-dba php8.1-dev \
php8.1-enchant php8.1-fpm php8.1-gd php8.1-gmp php8.1-imap php8.1-interbase php8.1-intl php8.1-ldap \
php8.1-mbstring php8.1-mysql php8.1-odbc php8.1-opcache php8.1-pgsql php8.1-phpdbg php8.1-pspell php8.1-readline \
php8.1-snmp php8.1-soap php8.1-sqlite3 php8.1-sybase php8.1-tidy php8.1-xdebug php8.1-xml php8.1-xmlrpc php8.1-xsl \
php8.1-zip php8.1-imagick php8.1-memcached php8.1-redis

# Configure php.ini for CLI
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/cli/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/cli/php.ini

# Configure Xdebug
echo "xdebug.mode = debug" >> /etc/php/8.1/mods-available/xdebug.ini
echo "xdebug.discover_client_host = true" >> /etc/php/8.1/mods-available/xdebug.ini
echo "xdebug.client_port = 9003" >> /etc/php/8.1/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/8.1/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/8.1/mods-available/opcache.ini

# Configure php.ini for FPM
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.1/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.1/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.1/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/8.1/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.1/fpm/php.ini
printf "[curl]\n" | tee -a /etc/php/8.1/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/8.1/fpm/php.ini

# Configure FPM
sed -i "s/user = www-data/user = sag/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = sag/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/listen\.owner.*/listen.owner = sag/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = sag/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.1/fpm/pool.d/www.conf

 # Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chown -R sag:sag /home/sag/.config

# Install Nginx & PHP-FPM

# Install Nginx
  apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages nginx

rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

# Create a configuration file for Nginx overrides.
sudo mkdir -p /home/hariadi/.config/nginx
sudo chown -R hariadi:hariadi /home/hariadi
touch /home/hariadi/.config/nginx/nginx.conf
sudo ln -sf /home/hariadi/.config/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

# Disable XDebug On The CLI

sudo phpdismod -s cli xdebug

service nginx restart
service php7.2-fpm restart
service php7.3-fpm restart
service php5.6-fpm restart

# Add sag User To WWW-Data
usermod -a -G www-data sag
id sag
groups sag

# Install SQLite

apt-get install -y sqlite3 libsqlite3-dev

# Install MySQL
echo "mysql-server mysql-server/root_password password secret" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password secret" | debconf-set-selections
apt-get install -y mysql-server

# Configure MySQL Password Lifetime

echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Configure MySQL Remote Access

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
service mysql restart

mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="secret" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"

sudo tee /home/sag/.my.cnf <<EOL
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_bin
EOL

# Add Timezone Support To MySQL

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql

service mysql restart


# Configure Supervisor

systemctl enable supervisor.service
service supervisor start

apt-get -y upgrade

# Clean Up

apt-get -y autoremove
apt-get -y clean
chown -R sag:sag /home/sag

# Add Composer Global Bin To Path

printf "\nPATH=\"$(sudo su - sag -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/sag/.profile

# Enable Swap Memory

/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1
