wget https://download.jetbrains.com/python/pycharm-professional-2020.3.5.tar.gz

tar xzf pycharm-professional-2020.3.5.tar.gz

rm pycharm-professional-2020.3.5.tar.gz

sudo mv pycharm-2020.3.5/ /opt/

cd /opt/

sudo chown $USER:$USER pycharm-2020.3.5/
sudo chmod 775 pycharm-2020.3.5/

# Add to menu



wget https://www.jetbrains.com/pycharm/download/download-thanks.html?type=eap,rc&platform=linux

tar xzf pycharm-professional-*.tar.gz

rm pycharm-professional-*.tar.gz

sudo mv pycharm-*/ /opt/

cd /opt/

sudo chown $USER:$USER pycharm-*/
sudo chmod 775 pycharm-*/

# Add to menu
