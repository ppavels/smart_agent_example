#!/bin/sh

DRUSH="../vendor/bin/drush"

# Installing composer
composer install

cd web

# Install Drupal
$DRUSH site-install --verbose --yes --db-url=sqlite://tmp/site.sqlite

# Change settings.php file permissions.
chmod 777 sites/default/settings.php

# Add migration database settings.
echo "\$databases['migrate']['default'] = \$databases['default']['default'];" >> sites/default/settings.php

# Change settings.php file permissions back.
chmod 644 sites/default/settings.php