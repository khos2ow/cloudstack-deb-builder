#!/usr/bin/bash
apt install -y wget libmysqlclient-dev python2-minimal

# Setup Python2.7 pip
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O /tmp/get-pip.py
python2 /tmp/get-pip.py

pip install MySQL-python
pip install mysql-connector-python

# Alternative Mysql Connector Setup for Python 2.7 
# Taken from: https://stackoverflow.com/questions/63457213/how-to-install-python-mysqldb-for-python-2-7-in-ubuntu-20-04-focal-fossa
# wget https://raw.githubusercontent.com/paulfitz/mysql-connector-c/master/include/my_config.h -O /usr/include/mysql/my_config.h