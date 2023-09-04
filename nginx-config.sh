#!/bin/bash
# Create user test-ssh and group clp and update nginx to use these user/group


# Define the desired username and groupname
USER_NAME="test-ssh"
GROUP_NAME="clp"

# Check if the user already exists
if id "$USER_NAME" &>/dev/null; then
    echo "User $USER_NAME already exists. Skipping user creation."
else
    # Create the user with a home directory (-m) and no password (-p)
    sudo useradd -m -s /bin/bash "$USER_NAME"
    echo "User $USER_NAME created."
fi

# Check if the group already exists
if grep -q "^$GROUP_NAME:" /etc/group; then
    echo "Group $GROUP_NAME already exists. Skipping group creation."
else
    # Create the group
    sudo groupadd "$GROUP_NAME"
    echo "Group $GROUP_NAME created."
fi

# Modify NGINX configuration to run under the specified user and group
if grep -q "^user $USER_NAME;" /etc/nginx/nginx.conf; then
    echo "NGINX is already configured to run under user $USER_NAME. No changes needed."
else
    # Backup the original NGINX configuration
    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

    # Modify the NGINX configuration file to use the specified user and group
    sudo sed -i "s/^user .*;$/user $USER_NAME $GROUP_NAME;/" /etc/nginx/nginx.conf

    # Check the NGINX configuration
    if sudo nginx -t; then
        # Restart NGINX to apply the changes
        sudo systemctl restart nginx
        echo "NGINX configured to run under user $USER_NAME and group $GROUP_NAME."
    else
        # Restore the original NGINX configuration on failure
        sudo cp /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
        echo "Error: NGINX configuration test failed. Reverting changes."
    fi
fi

# Clean up by removing the backup configuration file
sudo rm -f /etc/nginx/nginx.conf.bak
sudo chown -R test-ssh:clp /var/www/html/*
# Print a message indicating the script has completed
echo "Script execution completed."
