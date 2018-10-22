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
3. `sudo ln -sf ~/server/etc/profile.d/aliases.sh /etc/profile.d/00-aliases.sh`
4. Backup your `/etc/nginx/nginx.conf` and `/etc/nginx/mime.types` (`cp` to somewhere)
5 `sudo ln -sf ~/server/nginx/nginx.conf /etc/nginx/nginx.conf`
6 `sudo ln -sf ~/server/nginx/mime.types /etc/nginx/mime.types`
7. Test with `sudo nginx -t`

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




