# interview

- AWS has no debian 11 but debian 12, to do so, subscribe to debian 11 and get its ami: https://aws.amazon.com/marketplace/server/procurement?productId=a264997c-d509-4a51-8e85-c2644a3f8ba2

    ami-0efa0960891755965


- Create and keypair or import to existing keypair with private key in this repo. Keypair is not managed by cloudformation stack
- To create cloudformation stack, create a stack in Singapore region and upload ec2.yml template
- To ssh to server run : ssh -i ec2-keypair.pem admin@publicIP: ssh -i ec2-keypair.pem admin@54.179.16.42
- Run script.sh to install nginx, php8, mysql, while install save your mysql db password, here is: test@123,then create DB: CREATE DATABASE magento2;
- Register dev account at: https://commercedeveloper.adobe.com/account/profile, key:
    Public: 5bf32812596252798795d52d9944f7ac
    Private: d2043f2df9daa47c93697891069d225f
- Run script-magento.sh using root user to install magento using composer, update script to use correct db setting: sudo su; ./script-magento.sh
