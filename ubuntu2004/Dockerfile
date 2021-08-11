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

FROM ubuntu:focal AS base
RUN apt update && apt dist-upgrade -y && apt autoremove --purge -y

FROM base AS stage0
RUN  apt install -y --no-install-recommends \
        wget \
        locate 
        # make \
        # tar \
        # lsb-release \
        # build-essential \
        # dpkg-dev \
        # devscripts \
        # debhelper \
        # genisoimage \
        # git \
        # maven \
        # dh-systemd 

FROM stage0 AS stage1
RUN  apt install -y \   
        libmysqlclient-dev \
        python2-minimal
COPY ./python-deps.sh /
RUN  ./python-deps.sh

FROM stage1 AS stage2

ARG NODE_VERSION=14.17.5
ARG NODE_PACKAGE=node-v$NODE_VERSION-linux-x64
ARG NODE_HOME=/opt/$NODE_PACKAGE

ENV NODE_PATH $NODE_HOME/lib/node_modules
ENV PATH $NODE_HOME/bin:$PATH

RUN wget -qO- --no-check-certificate https://nodejs.org/dist/v$NODE_VERSION/$NODE_PACKAGE.tar.gz | tar xzC - -C /opt/
RUN node --version

RUN echo 'DONE!'