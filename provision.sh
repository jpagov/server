#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Update Package List

apt-get update

# Update System Packages
apt-get -y upgrade

# Force Locale

echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8 ms_MY.UTF-8

# Install Some PPAs

apt-get install -y software-properties-common curl

apt-add-repository ppa:nginx/development -y
#apt-add-repository ppa:chris-lea/redis-server -y
apt-add-repository ppa:ondrej/php -y-

# Update Package Lists
apt-get update

# Install Some Basic Packages

apt-get install -y dos2unix git libmcrypt4 libpcre3-dev libpng-dev ntp unzip \
supervisor unattended-upgrades whois vim libnotify-bin \
mcrypt bash-completion zsh

# Set My Timezone

ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# Install PHP Stuffs
# Current PHP
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.2-cli php7.2-dev \
php7.2-pgsql php7.2-sqlite3 php7.2-gd \
php7.2-curl php7.2-memcached \
php7.2-imap php7.2-mysql php7.2-mbstring \
php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
php7.2-intl php7.2-readline php7.2-ldap \
php-xdebug php-pear

# PHP 7.3
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.3-cli php7.3-dev \
php7.3-pgsql php7.3-sqlite3 php7.3-gd \
php7.3-curl \
php7.3-imap php7.3-mysql php7.3-mbstring \
php7.3-xml php7.3-zip php7.3-bcmath php7.3-soap \
php7.3-intl php7.3-readline

# PHP 5.6
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php5.6-cli php5.6-dev \
php5.6-pgsql php5.6-sqlite3 php5.6-gd \
php5.6-curl php5.6-memcached \
php5.6-imap php5.6-mysql php5.6-mbstring \
php5.6-xml php5.6-zip php5.6-bcmath php5.6-soap \
php5.6-intl php5.6-readline php5.6-mcrypt

update-alternatives --set php /usr/bin/php7.2
update-alternatives --set php-config /usr/bin/php-config7.2
update-alternatives --set phpize /usr/bin/phpize7.2

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Set Some PHP CLI Settings
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/cli/php.ini

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.3/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.3/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.3/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.3/cli/php.ini

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/5.6/cli/php.ini

# Install Nginx & PHP-FPM

apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
nginx php7.3-fpm php7.2-fpm php5.6-fpm

rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

# Create a configuration file for Nginx overrides.
sudo mkdir -p /home/hariadi/.config/nginx
sudo chown -R hariadi:hariadi /home/hariadi
touch /home/hariadi/.config/nginx/nginx.conf
sudo ln -sf /home/hariadi/.config/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

# Setup Some PHP-FPM Options
echo "xdebug.remote_enable = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.2/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.2/mods-available/opcache.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.3/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.3/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.3/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.3/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.3/mods-available/opcache.ini

echo "xdebug.remote_enable = 1" >> /etc/php/5.6/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/5.6/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/5.6/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/5.6/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/5.6/mods-available/opcache.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/7.2/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.2/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/7.2/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.2/fpm/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.3/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.3/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.3/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.3/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.3/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.3/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.3/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/7.3/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.3/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/7.3/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.3/fpm/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/5.6/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/5.6/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/5.6/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/5.6/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/5.6/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/5.6/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/5.6/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/5.6/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/5.6/fpm/php.ini

# Disable XDebug On The CLI

sudo phpdismod -s cli xdebug

# Copy fastcgi_params to Nginx because they broke it on the PPA

cat > /etc/nginx/fastcgi_params << EOF
fastcgi_param   QUERY_STRING        \$query_string;
fastcgi_param   REQUEST_METHOD      \$request_method;
fastcgi_param   CONTENT_TYPE        \$content_type;
fastcgi_param   CONTENT_LENGTH      \$content_length;
fastcgi_param   SCRIPT_FILENAME     \$request_filename;
fastcgi_param   SCRIPT_NAME     \$fastcgi_script_name;
fastcgi_param   REQUEST_URI     \$request_uri;
fastcgi_param   DOCUMENT_URI        \$document_uri;
fastcgi_param   DOCUMENT_ROOT       \$document_root;
fastcgi_param   SERVER_PROTOCOL     \$server_protocol;
fastcgi_param   GATEWAY_INTERFACE   CGI/1.1;
fastcgi_param   SERVER_SOFTWARE     nginx/\$nginx_version;
fastcgi_param   REMOTE_ADDR     \$remote_addr;
fastcgi_param   REMOTE_PORT     \$remote_port;
fastcgi_param   SERVER_ADDR     \$server_addr;
fastcgi_param   SERVER_PORT     \$server_port;
fastcgi_param   SERVER_NAME     \$server_name;
fastcgi_param   HTTPS           \$https if_not_empty;
fastcgi_param   REDIRECT_STATUS     200;
EOF

# Set The Nginx & PHP-FPM User

sed -i "s/user www-data;/user hariadi;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sed -i "s/user = www-data/user = hariadi/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = hariadi/" /etc/php/7.2/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = hariadi/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = hariadi/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.2/fpm/pool.d/www.conf

sed -i "s/user = www-data/user = hariadi/" /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = hariadi/" /etc/php/7.3/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = hariadi/" /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = hariadi/" /etc/php/7.3/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.3/fpm/pool.d/www.conf

sed -i "s/user = www-data/user = hariadi/" /etc/php/5.6/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = hariadi/" /etc/php/5.6/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = hariadi/" /etc/php/5.6/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = hariadi/" /etc/php/5.6/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/5.6/fpm/pool.d/www.conf

service nginx restart
service php7.2-fpm restart
service php7.3-fpm restart
service php5.6-fpm restart

# Add Vagrant User To WWW-Data

usermod -a -G www-data hariadi
id hariadi
groups hariadi

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

sudo tee /home/hariadi/.my.cnf <<EOL
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_bin
EOL

# Add Timezone Support To MySQL

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql

service mysql restart

# Install Memcached & Beanstalk

apt-get install -y redis-server memcached beanstalkd

# Configure Beanstalkd

sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
/etc/init.d/beanstalkd start


# Configure Supervisor

systemctl enable supervisor.service
service supervisor start

# Install Crystal Programming Language Support
apt-key adv --keyserver hkp://keys.gnupg.net:80 --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" | tee /etc/apt/sources.list.d/crystal.list
apt-get update
apt-get install -y crystal libssl1.0-dev

# Install Lucky Framework for Crystal

wget https://github.com/luckyframework/lucky_cli/archive/v0.11.0.tar.gz
tar -zxvf v0.11.0.tar.gz
cd lucky_cli-0.11.0
shards install
crystal build src/lucky.cr --release --no-debug
mv lucky /usr/local/bin/.
cd /home/hariadi
rm -rf lucky_cli-0.11.0
rm -rf v0.11.0.tar.gz

# Install Flyway

# wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.2.0/flyway-commandline-4.2.0-linux-x64.tar.gz
# tar -zxvf flyway-commandline-4.2.0-linux-x64.tar.gz -C /usr/local
# chmod +x /usr/local/flyway-4.2.0/flyway
# ln -s /usr/local/flyway-4.2.0/flyway /usr/local/bin/flyway
# rm -rf flyway-commandline-4.2.0-linux-x64.tar.gz


# Install oh-my-zsh

git clone git://github.com/robbyrussell/oh-my-zsh.git /home/hariadi/.oh-my-zsh
cp /home/hariadi/.oh-my-zsh/templates/zshrc.zsh-template /home/hariadi/.zshrc
printf "\nsource ~/.bash_aliases\n" | tee -a /home/hariadi/.zshrc
printf "\nsource ~/.profile\n" | tee -a /home/hariadi/.zshrc
chown -R hariadi:hariadi /home/hariadi/.oh-my-zsh
chown hariadi:hariadi /home/hariadi/.zshrc

apt-get -y upgrade

# Clean Up

apt-get -y autoremove
apt-get -y clean
chown -R hariadi:hariadi /home/hariadi

# Add Composer Global Bin To Path

printf "\nPATH=\"$(sudo su - hariadi -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/hariadi/.profile

# Enable Swap Memory

/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1
