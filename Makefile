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

.PHONY: all ubuntu1404 ubuntu1604 ubuntu1804 ubuntu1804-jdk11 latest

# Build docker tag based on provided info
#
# $1: tag_name
# $2: directory_name
define build_tag
	docker build -t khos2ow/cloudstack-deb-builder:$(1) $(2)
endef

all: ubuntu1404 ubuntu1604 ubuntu1804 latest

ubuntu1404:
	$(call build_tag,ubuntu1404,ubuntu1404)

ubuntu1604:
	$(call build_tag,ubuntu1604,ubuntu1604)

ubuntu1804:
	$(call build_tag,ubuntu1804,ubuntu1804)

ubuntu1804-jdk11:
	$(call build_tag,ubuntu1804-jdk11,ubuntu1804-jdk11)

latest:
	$(call build_tag,latest,ubuntu1804)
