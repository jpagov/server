# Ubuntu Server for PSD

The scripts that build the PHP production environment.

# Usage

1. Clone this repo

```bash
sudo bash provision.sh
```

2. Create symlink:
	a. `sudo ln -sf /etc/nginx/conf ~/server/conf`
	b. `sudo ln -sf ~/scripts ~/server/scripts`
3. `cp ~/server/etc/profile.d/aliases.sh /etc/profile.d/`
4. Copy `nginx.conf` and `mime.types` to `/etc/nginx`

# Create virtual host

1. `serve domain path httpport httpsport phpver hsts`

Example: `serve subdomain.jpa.gov.my /home/hariadi/www/sistem.jpa.gov.my/public`

This will create `/etc/nginx/site-available/subdomain.jpa.gov.my`

# Create schedule cron (Laravel)

`schedule domain path`

This will create `/etc/cron.d/subdomain.jpa.gov.my`

Example: `schedule subdomain.jpa.gov.my /home/hariadi/www/sistem.jpa.gov.my`

Credit:
	1. (H5BP Nginx Server Config)[https://github.com/h5bp/server-configs-nginx]
	2. (Homestead Laravel)[https://github.com/laravel/homestead]
	3. (Laravel Settler)[https://github.com/laravel/settler]




