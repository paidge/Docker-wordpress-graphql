# Wordpress with preinstalled plugins

The docker image uses the original wordpress one without installing Wordpress and installs wp-cli to launch the installation.
Then it installs some plugins for develloping front with WP GRAPHQL.

## Built & run

```
git clone ^this_repo^
cd ^repo_folder^
```

Then edit the .env file and fix your language in Dockerfile ARG.

```
docker-compose build
docker-compose up -d
```

You can visit the _WORDPRESS_URL_/wp-login.php and connect.

## For production

For production you can install the following plugins to protect your site :

- WPS Hide Login and WPS Limit Login.

It seems there is an infinite redirection to /wp-login.php when they are pre-installed.

Please have a look on: https://github.com/ellakcy/wordpress-with-plugins-deployment-recipe

### Enviromentall variables & configuration

Supports these enviromental variables:

| Variable Name            | Defalt Value        | Description                                                              |
| ------------------------ | ------------------- | ------------------------------------------------------------------------ |
| WORDPRESS_ADMIN_USERNAME | _admin_             | The username of the admin user                                           |
| WORDPRESS_ADMIN_PASSWORD | _admin123_          | The password of the admin user. **PLEASE DO CHANGE WHEN ON PRODUCTION**. |
| WORDPRESS_ADMIN_EMAIL    | *admin@example.com* | The administrator email. (Recomended to change.)                         |
| WORDPRESS_URL            | _localhost_         | Your site's url. **PLEASE SET AS CONTAINERS IP. TESTED WITH THAT**       |
| WORDPRESS_TITLE          | _My localhost site_ | The title to be displayed when generating the site.                      |

**NOTE:**
`WORDPRESS_ADMIN_USERNAME` must have a **DIFFERENT** value from **WORDPRESS_ADMIN_PASSWORD** in order to be able to login to wordpress dashboard.

## Recomended Running Testing & Reverse proxy settting for deployment

### Testing via browser **WITHOUT** proxy:

On you terminal type:

```
docker inspect ^container name or hash^
```

And on the json that has been output look for `"IPAddress"` visit this ip addresss to your borwser and it will work (with broken urls for assets)

### Using apache2 as reverse proxy:

The best way to test it is to use apache2 (or another web server or web proxy) in order to achieve a multi purpose testing and deployment bedrock.

The minimal configutation for apache2 is to enaable:

And create the following virtualhost.

```
<VirtualHost *:80>

ProxyPass /  ^container's ip^/
ProxyPassReverse  ^container's ip^/ /

</Virtualhost>
```

Or Alternatively (for development & testing purpose):

```
<VirtualHost *:80>

ProxyPass /somename  ^container's ip^/
ProxyPassReverse  ^container's ip^/ /somename

</Virtualhost>
```

Note that the value that replaces ^sites' url^ or ^container's ip^ must be a valid url starting with http or https and ending with / (in order for assets to work)

### Using Nginx as reverse proxy

For production use the following settings (with ssl redirection)

```
server {
	listen 80;
	server_name ^site_url^;

	rewrite ^ https://$server_name$request_uri? permanent;
}

server {

	listen 443 ssl;
  ssl_certificate  ^certificate_path^; # managed by Certbot
  ssl_certificate_key ^certificate_key^; # managed by Certbot
  ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers         HIGH:!aNULL:!MD5;

  server_name ^site_url^;


	location / {
		error_page 502 /502.html;

		proxy_http_version 1.1;
       		proxy_set_header Upgrade $http_upgrade;
       		proxy_set_header Connection 'upgrade';
       		proxy_set_header Host $host;
       		proxy_set_header X-Real-IP $remote_addr;
       		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       		proxy_set_header X-Forwarded-Proto $scheme;
       		proxy_cache_bypass $http_upgrade;

        	proxy_pass ^container's ip^;
	}

	location = /502.html{
		root /var/www/ellak.org;
	}
}

```

Note that the value that replaces ^sites' url^ or ^container's ip^ must be a valid url starting with http or https and ending with / (in order for assets to work)

### Further Deployment notes

- When deploying always use a valid url in order to word.
- Even on testing and development please use a webserver as reverse proxy.
