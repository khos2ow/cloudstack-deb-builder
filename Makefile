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

# Project variables
PROJECT_NAME  := cloudstack-deb-builder
PROJECT_OWNER := khos2ow
DESCRIPTION   := Docker images for building Apache CloudStack DEB packages
PROJECT_URL   := https://github.com/$(PROJECT_OWNER)/$(PROJECT_NAME)
LICENSE       := Apache-2.0

# Build docker tag based on provided info
#
# $1: tag_name
# $2: directory_name
define build_tag
	docker build --pull --tag $(PROJECT_OWNER)/$(PROJECT_NAME):$(1) $(2)
endef

.PHONY: all
all: ubuntu1404 ubuntu1604 ubuntu1804 ubuntu1804-jdk11 latest

.PHONY: ubuntu1404
ubuntu1404: ## Build ubuntu1404 image
	@ $(MAKE) --no-print-directory log-$@
	$(call build_tag,ubuntu1404,ubuntu1404)

.PHONY: ubuntu1604
ubuntu1604: ## Build ubuntu1604 image
	@ $(MAKE) --no-print-directory log-$@
	$(call build_tag,ubuntu1604,ubuntu1604)

.PHONY: ubuntu1804
ubuntu1804: ## Build ubuntu1804 image
	@ $(MAKE) --no-print-directory log-$@
	$(call build_tag,ubuntu1804,ubuntu1804)

.PHONY: ubuntu1804-jdk11
ubuntu1804-jdk11: ## Build ubuntu1804-jdk11 image
	@ $(MAKE) --no-print-directory log-$@
	$(call build_tag,ubuntu1804-jdk11,ubuntu1804-jdk11)

.PHONY: latest
latest: ## Build latest image
	@ $(MAKE) --no-print-directory log-$@
	$(call build_tag,latest,ubuntu1804)

.PHONY: push
push: DOCKER_TAG ?=
push: ## Push image
	@ $(MAKE) --no-print-directory log-$@
	docker push $(PROJECT_OWNER)/$(PROJECT_NAME):$(DOCKER_TAG)

########################################################################
## Self-Documenting Makefile Help                                     ##
## https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html ##
########################################################################
.PHONY: help
help:
	@ grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

log-%:
	@ grep -h -E '^$*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m==> %s\033[0m\n", $$2}'
