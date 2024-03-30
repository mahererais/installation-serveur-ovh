# ! /bin/bash

# installation composer

# https://mehulgohil.com/blog/install-composer


 curl -sS https://getcomposer.org/installer -o composer-setup.php
 HASH=`curl -sS https://composer.github.io/installer.sig`
 php -r "if (hash_file('sha384', 'composer-setup.php') === $HASH) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

 mkdir $HOME/local
 mkdir $HOME/local/bin

 php composer-setup.php --install-dir=$HOME/local/bin --filename=composer
 echo "export PATH=$PATH:$HOME/local/bin" >> ~/.bashrc

 # installtion node npm
 
 # Wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.39.0/install.sh | bash
 # source ~/.bash_profile
 # nvm ls-remote
 # nvm install 20.12.0

 # installer Docker

