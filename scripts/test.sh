#!/usr/bin/env bash
#
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

DOCKER_TAG=$1
GIT_REF=$2
DOCKER_PARAM=$3

docker run \
    --volume /tmp/apache-cloudstack:/mnt/build \
    --volume /tmp/.m2:/root/.m2 \
    --rm \
    khos2ow/cloudstack-deb-builder:"${DOCKER_TAG}" \
        --git-remote https://github.com/apache/cloudstack.git \
        --git-ref "${GIT_REF}" \
        --remove-first \
        "${DOCKER_PARAM}"
