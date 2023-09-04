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
sudo apt install -y mysql-server
# password test@123


# Secure MySQL installation (set a root password and remove anonymous users)
sudo mysql_secure_installation

# Install PHP 8.1 and necessary extensions
sudo curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x  ;  sudo apt update
sudo apt install -y php8.1-fpm php8.1-common php8.1-mysql php8.1-gmp php8.1-curl php8.1-intl php8.1-mbstring php8.1-xmlrpc php8.1-gd php8.1-xml php8.1-cli php8.1-zip php8.1-soap php8.1-imap

# Self-signed certificate:
sudo mkdir /etc/nginx/ssl
chown -R 777 /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/selfsigned.key -out /etc/nginx/ssl/selfsigned.crt


# Configure PHP-FPM for Nginx
sudo systemctl enable php8.1-fpm
sudo systemctl start php8.1-fpm

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
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Test Nginx configuration
sudo nginx -t

# Reload Nginx to apply changes
sudo systemctl reload nginx

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
