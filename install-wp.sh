#!/bin/bash
WORDPRESS_PATH="/var/www/html"
COMMAND="sudo -u www-data wp --path=${WORDPRESS_PATH}"

while ! mysqladmin ping -h"${WORDPRESS_DB_HOST}" --silent; do
  echo "Waiting for database" 
  sleep 1
done

echo "======================================="
echo "======= WORDPRESS INSTALLATION ========"
echo "======================================="

${COMMAND} core config --dbhost="${WORDPRESS_DB_HOST}" --dbname="${WORDPRESS_DB_NAME}" --dbuser="${WORDPRESS_DB_USER}" --dbpass="${WORDPRESS_DB_PASSWORD}"
${COMMAND} core install --admin_user="${WORDPRESS_ADMIN_USERNAME}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" --admin_email="${WORDPRESS_ADMIN_EMAIL}" --title="${WORDPRESS_TITLE}" --url="${WORDPRESS_URL}"
chmod 600 wp-config.php

echo "======================================="
echo "====== REDIRECT THEME ACTIVATION ======"
echo "======================================="

${COMMAND} theme activate redirect

echo "======================================="
echo "========= LANGUAGE ACTIVATION ========="
echo "======================================="

${COMMAND} language core install ${WP_LANGUAGE} --activate

echo "======================================="
echo "======= PLUGINS INSTALLATION ========"
echo "======================================="

if [ $(${COMMAND} plugin is-installed akismet) ]; then
  echo "Removing Useless Plugin Askimet"
  ${COMMAND} plugin delete akismet
fi

if [ $(${COMMAND} plugin is-installed hello) ]; then
  echo "Removing Useless Plugin hello"
  ${COMMAND} plugin delete hello
fi

if [ $(${COMMAND} plugin is-installed atlas-content-modeler) ]; then
  echo "Update Atlas Content Modeler plugin"
  ${COMMAND} plugin update atlas-content-modeler --activate
else
  echo "Install Atlas Content Modeler plugin"
  ${COMMAND} plugin install atlas-content-modeler --activate
fi

if [ $(${COMMAND} plugin is-installed block-data-attribute) ]; then
  echo "Update Block Data Attribute plugin"
  ${COMMAND} plugin update block-data-attribute --activate
else
  echo "Install Block Data Attribute plugin"
  ${COMMAND} plugin install block-data-attribute --activate
fi

if [ $(${COMMAND} plugin is-installed deploy-netlifypress) ]; then
  echo "Update Deploy with NetlifyPress plugin"
  ${COMMAND} plugin update deploy-netlifypress --activate
else
  echo "Install Deploy with NetlifyPress plugin"
  ${COMMAND} plugin install deploy-netlifypress --activate
fi

if [ $(${COMMAND} plugin is-installed pryc-wp-tinymce-more-buttons) ]; then
  echo "Update PRyC WP: TinyMCE more buttons plugin"
  ${COMMAND} plugin update pryc-wp-tinymce-more-buttons --activate
else
  echo "Install PRyC WP: TinyMCE more buttons plugin"
  ${COMMAND} plugin install pryc-wp-tinymce-more-buttons --activate
fi

if [ $(${COMMAND} plugin is-installed wp-graphql) ]; then
  echo "Update WPGraphQL plugin"
  ${COMMAND} plugin update wp-graphql --activate
else
  echo "Install WPGraphQL plugin"
  ${COMMAND} plugin install wp-graphql --activate
fi

echo "======================================="
echo "======== INSTALLATION COMPLETE ========"
echo "======================================="

exec "$@"