#!/usr/bin/bash

# Setup Python2.7 pip
wget -q --no-check-certificate https://bootstrap.pypa.io/pip/2.7/get-pip.py -O /tmp/get-pip.py
python2 /tmp/get-pip.py
ln -s $(which python2) /usr/bin/python

# Fix for Mysql Connector Setup for Python 2.7 
# Taken from: https://stackoverflow.com/questions/63457213/how-to-install-python-mysqldb-for-python-2-7-in-ubuntu-20-04-focal-fossa
wget -q --no-check-certificate https://raw.githubusercontent.com/paulfitz/mysql-connector-c/master/include/my_config.h -O /usr/include/mysql/my_config.h

pip2 install MySQL-python
pip2 install mysql-connector-python