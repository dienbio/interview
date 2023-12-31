#!/bin/bash
# ref: https://www.cloudways.com/blog/install-magento-2-composer/
if ! command -v composer &>/dev/null; then
  curl -sS https://getcomposer.org/installer -o composer-setup.php
  sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
else
  echo "Composer installed"our desired version

# Verify that Composer is installed
if ! [ -x "$(command -v composer)" ]; then
fi

# Define your Magento 2 project directory and desired Magento version
sudo chmod -R 777 /var/www/html/
MAGENTO_DIR="/var/www/html/my-magento-project"
MAGENTO_VERSION="2.4.6"  # Replace with y
  echo "Composer is not installed. Please install Composer first."
  exit 1
fi

# composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .
# Create the Magento project using Composer
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition:$MAGENTO_VERSION $MAGENTO_DIR


# Navigate to the Magento project directory
cd $MAGENTO_DIR
# Set file permissions
sudo chmod -R 755 .
sudo find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \;
sudo find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} \;
sudo chown -R test-ssh:clp .
sudo chmod u+x bin/magento

# Install Magento using the setup wizard
bin/magento setup:install \
  --base-url=http://test.mgt.com \
  --db-host=localhost \
  --db-name=magento2 \
  --db-user=root \
  --db-password=test@123 \
  --admin-firstname=Dien \
  --admin-lastname=Doan \
  --admin-email=diendoanq@gmail.com \
  --admin-user=admin \
  --admin-password=admin123 \
  --language=en_US \
  --currency=USD \
  --timezone=Asia/Vientiane \
  --use-rewrites=1 \
  --search-engine=elasticsearch7 \
  --elasticsearch-host=localhost \
  --elasticsearch-port=9200

bin/magento setup:install --base-url=http://test.mgt.com \
        --base-url-secure=https://test.mgt.com

# Deploy static content
# sudo php bin/magento setup:static-content:deploy -f
php bin/magento sampledata:deploy
php bin/magento module:enable --all
php bin/magento setup:upgrade

# Clean cache
sudo php bin/magento cache:flush

# Enable and configure necessary modules (e.g., Elasticsearch, Redis, etc.)

# Optionally, perform additional setup and customization steps as needed
# Setup domain
sudo echo "127.0.0.1 test.mgt.com" >> /etc/hosts

# Config Redis : running under test-ssh user
sudo su
su test-ssh
cd /var/www/html/my-magento-project
bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=127.0.0.1 --page-cache-redis-db=1



#Complete
echo "Magento 2 installation is complete."

