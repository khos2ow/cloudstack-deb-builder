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

# Adjust user and group provided by host
adjust_owner() {
    # if both set then change the owner
    if [ -n "${USER_ID}" -a -z "${USER_GID}" ]; then
        chown -R ${USER_ID} /mnt/build/cloudstack
    elif [ -n "${USER_ID}" -a -n "${USER_GID}" ]; then
        chown -R ${USER_ID}:${USER_GID} /mnt/build/cloudstack
    fi
}

if [ ! -d "/mnt/build/cloudstack" ]; then
    echo "Could not find directory 'cloudstack'"
    exit 1
fi

if [ ! -f "/mnt/build/cloudstack/packaging/build-deb.sh" ]; then
    echo "Could not find file 'cloudstack/packaging/build-deb.sh'"
    exit 1
fi

{
    # do the packaging
    bash -x /mnt/build/cloudstack/packaging/build-deb.sh $@ && {
        mkdir -p /mnt/build/cloudstack/dist/debbuild/DEBS

        cp /mnt/build/cloudstack-*.deb /mnt/build/cloudstack/dist/debbuild/DEBS
        cp /mnt/build/cloudstack_*.changes /mnt/build/cloudstack/dist/debbuild/DEBS

        adjust_owner
    }
} || {
    status=$?

    adjust_owner
    echo "Packaging DEB failed"
    exit $status
}
