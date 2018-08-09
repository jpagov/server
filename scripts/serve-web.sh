#!/usr/bin/env bash

declare -A params=$6     # Create an associative array
paramsTXT=""
if [ -n "$6" ]; then
   for element in "${!params[@]}"
   do
	  paramsTXT="${paramsTXT}
	  fastcgi_param ${element} ${params[$element]};"
   done
fi

if [ "$7" = "true" ] && [ "$5" = "7.2" ]
then configureHsts="server {
	listen [::]:${3:-80};
	listen ${3:-80};

	# listen on both hosts
	server_name $1 www.$1;

	# and redirect to the https host (declared below)
	# avoiding http://www -> https://www -> https:// chain.
	return 301 https://$1\$request_uri;
}

server {
	listen [::]:${4:-443} ssl http2;
	listen ${4:-443} ssl http2;

	# listen on the wrong host
	server_name www.$1;

	include conf/directive-only/ssl.conf;

	# and redirect to the non-www host (declared below)
	return 301 https://$1\$request_uri;
}
"
else configureHsts=""
fi

block="$configureHsts
server {
	listen [::]:${4:-443} ssl http2;
 	listen ${4:-443} ssl http2;

	server_name .$1;

	include conf/directive-only/ssl.conf;

	root \"$2\";

	index index.html index.htm index.php;

	charset utf-8;

	location / {
		try_files \$uri \$uri/ /index.php?\$query_string;
	}

	location = /favicon.ico { access_log off; log_not_found off; }
	location = /robots.txt  { access_log off; log_not_found off; }

	access_log /var/log/nginx/$1.log main;
	error_log  /var/log/nginx/$1-error.log error;

	sendfile off;

	client_max_body_size 100m;

	include conf/basic.conf;

	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php/php$5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
		fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
		$paramsTXT

		fastcgi_intercept_errors off;
		fastcgi_buffer_size 16k;
		fastcgi_buffers 4 16k;
		fastcgi_connect_timeout 300;
		fastcgi_send_timeout 300;
		fastcgi_read_timeout 300;
	}

	location ~ /\.ht {
		deny all;
	}
}
"

echo "$block" > "/etc/nginx/sites-available/$1"
ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
