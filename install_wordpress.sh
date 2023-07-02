#!/bin/bash

# Step 1: Install Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Step 2: Install MariaDB
sudo apt-get install -y mariadb-server

# Step 3: Download and extract WordPress
wget http://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz

# Step 4: Configure Nginx
sudo mv wordpress /var/www/html
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/wordpress
sudo sed -i 's|root /var/www/html;|root /var/www/html/wordpress;|' /etc/nginx/sites-available/wordpress
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

# Step 5: Restart Nginx
sudo service nginx restart

# Step 6: Create a MySQL database and user for WordPress
# In this step, replace 'wordpressuser' and 'password' with your desired username and password for the WordPress database.
# For example, if you want the username to be 'myuser' and the password to be 'mypassword', you would replace 'wordpressuser' with 'myuser' and 'password' with 'mypassword'.
mysql -u root -e "CREATE DATABASE wordpress;"
mysql -u root -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Step 7: Configure WordPress
# In this step, if you want to use a different name for the database, replace 'wordpress' with your desired name.
# For example, if you want the database name to be 'mywordpress', you would replace 'wordpress' with 'mywordpress'.
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i 's|database_name_here|wordpress|' /var/www/html/wordpress/wp-config.php
sed -i 's|username_here|wordpressuser|' /var/www/html/wordpress/wp-config.php
sed -i 's|password_here|password|' /var/www/html/wordpress/wp-config.php

# Step 8: Set permissions
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Script completed
echo "WordPress installation is complete."
