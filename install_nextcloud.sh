#!/bin/bash

# Uppdatera systemet
sudo apt update
sudo apt upgrade -y

# Installera nödvändiga beroenden
sudo apt install apache2 libapache2-mod-php mariadb-server php-xml php-cli php-cgi php-mysql php-mbstring php-gd php-curl php-zip -y

# Skapa en databas för Nextcloud
sudo mysql -u root <<-EOF
CREATE DATABASE nextcloud;
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'your_password_here';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Hämta Nextcloud
wget https://download.nextcloud.com/server/releases/latest.zip
unzip latest.zip
sudo mv nextcloud /var/www/

# Ändra ägare och rättigheter
sudo chown -R www-data:www-data /var/www/nextcloud/

# Konfigurera Apache för Nextcloud
echo '<VirtualHost *:80>
    DocumentRoot "/var/www/nextcloud"
    ServerName your_domain_or_IP

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    <Directory /var/www/nextcloud/>
        Require all granted
        Options FollowSymlinks MultiViews
        AllowOverride All

       <IfModule mod_dav.c>
         Dav off
       </IfModule>

    SetEnv HOME /var/www/nextcloud
    SetEnv HTTP_HOME /var/www/nextcloud
    </Directory>

</VirtualHost>' | sudo tee /etc/apache2/sites-available/nextcloud.conf

# Aktivera webbplatsen och mod_rewrite
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "Nextcloud installation complete! Visit your domain or IP in a web browser to complete the setup."
