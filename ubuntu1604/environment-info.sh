#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -e

echo -e "System information:"
cat /etc/*-release

echo -e "\nGit version:"
git --version

echo -e "\nJava version:"
java -version

echo -e "\nMaven version:"
mvn --version

echo -e "\nPython version:"
python --version

echo -e "\ndpkg version:"
dpkg --version

echo -e "\ndevscripts version:"
dpkg -s devscripts | grep "Version:" | awk '{print $2}'

echo -e "\ndebhelper version:"
dpkg -s debhelper | grep "Version:" | awk '{print $2}'

echo -e "\ngenisoimage version:"
genisoimage --version

echo -e "\nlsb-release version:"
dpkg -s lsb-release | grep "Version:" | awk '{print $2}'

echo -e "\nbuild-essential version:"
dpkg -s build-essential | grep "Version:" | awk '{print $2}'
