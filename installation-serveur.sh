#!/bin/sh
echo "*********************************************"
echo "*  Bienvenue dans le script d'installation  *"
echo "*********************************************"
echo " "
read -p "appuyez sur entrée pour lancer l'installation"

USER_NAME=$USER

installUpdate()
{
  # mise à jour de la base logicielle
  sudo apt-get update

  # ajout du depot php7.4 https://computingforgeeks.com/how-to-install-latest-php-on-debian/
  sudo apt -y install lsb-release apt-transport-https ca-certificates
  sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
  sudo apt update

  # mise à jour des logiciels préinstallés
  sudo apt-get -y upgrade
}

installEssentials()
{
  #installation de nano
  sudo apt-get install -y nano

  # installation zip
  sudo apt-get install -y unzip
}

reinitMySQL()
{
  sudo mysql_install_db --user=mysql
}

installApache()
{
  # installation apache
  sudo apt-get install -y apache2

  # activation du mod rewrite
  sudo a2enmod rewrite
  sudo service apache2 restart
}

configureApache()
{
  # modification du AllowOverride
  sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf

  # configuration des droits
  sudo chown -R $USER_NAME:www-data /var/www/html
  sudo chmod -R 775 /var/www/html
  sudo chmod g+s /var/www/html

  # suppression du fichier index.html par défaut pour avoir le listing des répertoires
  sudo rm -rf /var/www/html/index.html

  # redémarrage d'Apache
  sudo service apache2 restart
}

installPHP()
{
  # installation php 7.4
  sudo apt-get install -y php7.4
  sudo apt-get install -y php7.4-common
  sudo apt-get install -y php7.4-cli
  sudo apt-get install -y php7.4-mysql
  sudo apt-get install -y libapache2-mod-php7.4
  sudo apt-get install -y php7.4-mbstring
  sudo apt-get install -y php7.4-json
  sudo apt-get install -y php7.4-xml
  sudo apt-get install -y php7.4-xdebug
  sudo service apache2 restart
}

configurePHP()
{
  sudo php -r "\$ini=glob('/etc/php/*/apache2/php.ini')[0]; \$buffer=file_get_contents(\$ini); \$buffer=str_replace('display_errors = Off', 'display_errors = On',\$buffer); file_put_contents(\$ini, \$buffer);";
  sudo service apache2 restart
}

installComposer()
{
  # composer
  cd /tmp
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php --quiet
  php -r "unlink('composer-setup.php');"
  sudo mv composer.phar /usr/local/bin/composer
}

installMySQL()
{
  # installation mariadb-server
  sudo apt-get install -y mariadb-server
  sudo service mysql start
}

configureMysql()
{
  # configuration mysql
  read -p "BDD User name ? " BDD_USER_NAME
  echo $BDD_USER_NAME;
  read -p "BDD password ? " BDD_USER_PASSWORD
  echo $BDD_USER_PASSWORD
  
  sudo  mysql  <<EOF 
CREATE USER ${BDD_USER_NAME}@localhost IDENTIFIED BY '${BDD_USER_PASSWORD}'; 
GRANT ALL PRIVILEGES ON *.* TO \`${BDD_USER_NAME}\`@'localhost' WITH GRANT OPTION; 
EOF

  # modify bind-address
  sudo php -r "\$cnf=glob('/etc/mysql/mariadb.conf.d/50-server.cnf')[0]; \$buffer=file_get_contents(\$cnf); \$buffer=str_replace('127.0.0.1', '0.0.0.0',\$buffer); file_put_contents(\$cnf, \$buffer);";
  sudo service mysql restart
}


installGit()
{
  # installation de git
  sudo apt-get install -y git
}

installDockerCompose()
{
  sudo apt install docker-compose
}

#==========================================================================================
#==========================================================================================
installUpdate
installEssentials

installApache
configureApache

installPHP
configurePHP

installMySQL
configureMysql

installComposer

installGit

installDockerCompose

exit 0
