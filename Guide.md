# Guideline

- AWS has no debian 11 but debian 12, to do so, subscribe to debian 11 and get its ami: https://aws.amazon.com/marketplace/server/procurement?productId=a264997c-d509-4a51-8e85-c2644a3f8ba2

    ami-0efa0960891755965

- Create and keypair or import to existing keypair with private key in this repo. Keypair is not managed by cloudformation stack
- To create cloudformation stack, create a stack in Singapore region and upload ec2.yml template
- To ssh to server run : ssh -i ec2-keypair.pem admin@publicIP: ssh -i ec2-keypair.pem admin@54.179.16.42
- Run script.sh to install nginx, php8, mysql, while install save your mysql db password, here is: test@123,then create DB: CREATE DATABASE magento2;
- Register dev account at: https://commercedeveloper.adobe.com/account/profile, key:
    Public: 5bf32812596252798795d52d9944f7ac
    Private: d2043f2df9daa47c93697891069d225f
- Run script-magento.sh using test-ssh user to install magento using composer, update script to use correct db setting: sudo su; su test-ssh; ./script-magento.sh

- Config nginx magento config: (already in script.sh): Check nginx-magento.conf

    `vim /etc/nginx/sites-available/magento`
    `ln -s /etc/nginx/sites-available/magento /etc/nginx/sites-enabled`
    `systemctl restart nginx`

- Config magent to use redis: (using test-ssh user)
    ```
    cd /var/www/html/my-magento-project
    bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=127.0.0.1 --page-cache-redis-db=1
    ```
- Create php pool: /etc/php/8.2/fpm/pool.d/phpmyadmin-pool.conf
    ```
[phpmyadmin-pool]
user = test-ssh
group = clp
listen = /var/run/phpmyadmin/phpmyadmin.sock
listen.owner = test-ssh
listen.group = clp
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off
; Choose how the process manager will control the number of child processes.
pm = dynamic
pm.max_children = 75
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
pm.process_idle_timeout = 10s
```


phpmyadmin pass: jbTS22.7@9$ // not complete yet


[SUCCESS]: Magento Admin URI: /admin_10a5cj
Nothing to import.