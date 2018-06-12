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

EXTRA_LINE=""

print_title() {
    local version_label=""
    if [[ "$1" = *":" ]]; then
        version_label=""
    else
        version_label=" version:"
    fi
    echo -e "${EXTRA_LINE}\e[1;34m$1${version_label}\e[0m"
}

print_title "system information:"
cat /etc/*-release

EXTRA_LINE="\n"

print_title "git"
git --version

print_title "java"
java -version

print_title "maven"
mvn --version

print_title "python"
python --version

print_title "dpkg"
dpkg --version

print_title "devscripts"
dpkg -s devscripts | grep "Version:" | awk '{print $2}'

print_title "debhelper"
dpkg -s debhelper | grep "Version:" | awk '{print $2}'

print_title "genisoimage"
genisoimage --version

print_title "lsb-release"
dpkg -s lsb-release | grep "Version:" | awk '{print $2}'

print_title "build-essential"
dpkg -s build-essential | grep "Version:" | awk '{print $2}'

echo ""
