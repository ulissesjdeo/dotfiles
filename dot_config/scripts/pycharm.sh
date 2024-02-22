wget https://download.jetbrains.com/python/pycharm-professional-2020.3.5.tar.gz

tar xzf pycharm-professional-2020.3.5.tar.gz

rm pycharm-professional-2020.3.5.tar.gz

sudo mv pycharm-2020.3.5/ /opt/

cd /opt/

sudo chown $USER:$USER pycharm-2020.3.5/
sudo chmod 775 pycharm-2020.3.5/

# Add to menu
