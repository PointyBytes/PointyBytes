#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Variables for database username and password.
DB_USER="wordpressuser"
DB_PASSWORD="password"

# Update package list and upgrade existing packages
sudo apt update
sudo apt full-upgrade -y

# Install Apache2
sudo apt install apache2 -y

# Restart Apache2 after installation
sudo systemctl restart apache2

# Install MariaDB and set up basic security
sudo apt install mariadb-server -y
sudo mysql_secure_installation

# Install PHP and necessary extensions for WordPress
sudo apt install php libapache2-mod-php php-mysql -y

# Restart Apache2 after installing PHP
sudo systemctl restart apache2

# Download and set up WordPress
wget http://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz

# Ask the user if they want to install WordPress in a subdirectory
read -p "Do you want to install WordPress in a subdirectory? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    read -p "Enter the name of the subdirectory (e.g., blog): " subdir
    sudo mv wordpress /var/www/html/$subdir
else
    sudo rm -rf /var/www/html/*
    sudo mv wordpress/* /var/www/html/
fi

sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Restart Apache2 after moving WordPress
sudo systemctl restart apache2

# Create a WordPress database and user
sudo mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -e "GRANT ALL ON wordpress.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Provide a message indicating that the script has completed
echo "WordPress installation completed! Please navigate to your Raspberry Pi's IP address in a browser to finish the WordPress setup."
