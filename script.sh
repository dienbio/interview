#!/bin/bash
set -e

#------------------------
# Nginx, PHP, MySQL
#------------------------
# Update the package list
sudo apt update
sudo apt upgrade -y

# Install Nginx
sudo apt install -y nginx

# Install MySQL 8
wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
sudo apt install ./mysql-apt-config_0.8.22-1_all.deb
sudo apt update
sudo apt install -y mysql-server
# password test@123sudo apt install -y mysql-server



# Secure MySQL installation (set a root password and remove anonymous users)
sudo mysql_secure_installation

# Install PHP 8.1 and necessary extensions
sudo curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x  ;  sudo apt update
sudo apt install -y php-zip php-xml php-mbstring php-bcmath php-fpm php-common php-mysql php-gmp php-curl php-intl php-mbstring php-xmlrpc php-gd php-xml php-cli php-zip php-soap php-imap

# Install phpmyadmin
sudo apt install -y phpmyadmin

# Self-signed certificate:
sudo mkdir /etc/nginx/ssl
chown -R 777 /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt


# Configure PHP-FPM for Nginx
sudo systemctl enable php8.2-fpm
sudo systemctl start php8.2-fpm

# Configure Nginx to use PHP-FPM
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm;

    server_name _;

    # Redirect HTTP to HTTPS
    return 301 https://$host$request_uri;
}
server {
    listen 443 ssl;
    server_name _;

    ssl_certificate /etc/nginx/ssl/selfsigned.crt;
    ssl_certificate_key /etc/nginx/ssl/selfsigned.key;

    # Add SSL configuration settings here (e.g., SSL protocols, ciphers, etc.)
    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/phpmyadmin-pool.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
# Create php pool /var/run/phpmyadmin-pool.sock then update nginx config
# Magento Nginx Config
sudo tee /etc/nginx/sites-available/magento <<EOF
upstream fastcgi_backend {
server   unix:/var/run/phpmyadmin/phpmyadmin.sock;
}

server {

listen 80;
server_name test.mgt.com;
set $MAGE_ROOT /var/www/html/my-magento-project;
include /var/www/html/my-magento-project/nginx.conf.sample;
}
EOF
sudo ln -s /etc/nginx/sites-available/magento /etc/nginx/sites-enabled

# Test Nginx configuration
sudo nginx -t

# Reload Nginx to apply changes
sudo systemctl reload nginx
sudo systemctl restart nginx
# Create a test PHP file to verify installation
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php


#-------------
# Elasticsearch
#--------------
# Add Elasticsearch APT GPG key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Add Elasticsearch APT repository
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

# Update APT package index
sudo apt update

# Install Elasticsearch
sudo apt install elasticsearch

# Start Elasticsearch service
sudo service elasticsearch start

# Enable Elasticsearch to start on boot
sudo systemctl enable elasticsearch


# Install Redis
sudo apt install -y redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server
