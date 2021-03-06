#!/usr/bin/env bash

# Modify the MySQL settings below so they will match your own.
MYSQL_USERNAME="root"
MYSQL_PASSWORD="root"
MYSQL_HOST="localhost"
MYSQL_DB_NAME="smart_agent_example"

# Get the base url for automatic login.
BASE_DOMAIN_URL="http://localhost/smart_agent_example/web"

# Admin username details
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="admin"

DRUSH="../vendor/bin/drush"

# Installing composer
composer install

cd web

# Install Drupal
$DRUSH si smart_agent_example --db-url=mysql://${MYSQL_USERNAME}:${MYSQL_PASSWORD}@${MYSQL_HOST}/${MYSQL_DB_NAME} --account-name=${ADMIN_USERNAME} --account-pass=${ADMIN_PASSWORD} -y

# CSV2SQL.
# $DRUSH csv2sql modules/custom/sma_migrate/csv/news.csv

# Change settings.php file permissions.
# sudo chmod 777 sites/default/settings.php

# Add migration database settings.
echo "\$databases['migrate']['default'] = \$databases['default']['default'];" >> sites/default/settings.php

# Change settings.php file permissions back.
# sudo chmod 644 sites/default/settings.php

#$DRUSH mi --all

echo "Build assets"
cd static
npm install
bundler install

gulp build

cd ..

cp -R ./static/serve/assets ./web/themes/sma_theme/vendors



# Login
$DRUSH uli --uri=${BASE_DOMAIN_URL}
