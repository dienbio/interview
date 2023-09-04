Technical assessment


- [x] Magento 2 Installation and Configuration
Create a new free account in AWS to use AWS services 
Alternatively, you can create a new free account at Digital Ocean

- [x] Launch an instance Debian 11 and install the following components:
PHP 8.1
Mysql 8
NGINX
Elasticsearch

- [x] Install latest Magento 2 via composer with Sample Data and Elasticsearch
- [x] Please use the domain "test.mgt.com" (localhost ==> 127.0.0.1 test.mgt.com)
Install Redis-Server and configure Magento to store the cache files and the sessions into Redis instead of the file system
- [x] Change the ownership of all files to user "test-ssh" and group "clp"
- [x] Configure NGINX to run as user "test-ssh"
Create a PHP-FPM pool that runs as user "test-ssh" and group "clp" and use this pool in your NGINX vhost -Configure PHPMyAdmin
- [x] Redirect in nginx HTTP to HTTPS and set up all store urls to HTTPS with a self-signed certificate.

- [] Install varnish and configure varnish with Magento.

