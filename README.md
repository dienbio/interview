## SSH to server
Using privatekey: ssh -i ec2-keypair.pem admin@13.215.137.240

## Task done
Check task.md

## Magento Location
/var/www/html/my-magento-project
php pool: /etc/php/8.2/fpm/pool.d/phpmyadmin-pool.conf
config: /etc/nginx/sites-available/
## Explaination
- ec2-cloudformation.yaml: cloudformation stack to import into your aws account singapore region will create: ec2, vpc, subnet public, routable, security group, internet gateway,etc
- script.sh: install prequisites: nginx, elasticserch, redis, mysql, php, composer
- nginx-config.sh: create test-ssh user, clp group, grant permission
- script-magento.sh: install magento and sample data
