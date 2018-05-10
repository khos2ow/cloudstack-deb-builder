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

# Flag to show help text
show_help=false

# Using remote git repository variables
use_remote=false
git_remote=""
git_ref=""
remove_first=false

# packaging flags to be sent to script
PKG_ARGS=""
HELP_ARG=""

while [ -n "$1" ]; do
    case "$1" in
        --git-remote)
            if [ -n "$git_remote" ]; then
                echo "Error: you have already entered value for --git-remote"
                exit 1
            else
                git_remote=$2
                use_remote=true
                shift 2
            fi
            ;;

        --git-ref)
            if [ -n "$git_ref" ]; then
                echo "Error: you have already entered value for --git-ref"
                exit 1
            else
                git_ref=$2
                use_remote=true
                shift 2
            fi
            ;;

        --remove-first)
            if [ $remove_first = true ]; then
                echo "Error: you have already entered --remove_first"
                exit 1
            else
                remove_first=true
                shift 1
            fi
            ;;

        -h | --help)
            if [ $show_help = true ]; then
                echo "Error: you have already entered -h, --help"
                exit 1
            else
                show_help=true
                HELP_ARG="$1"
                shift 1
            fi
            ;;

        -* | --* | *)
            PKG_ARGS="$PKG_ARGS $1"
            shift 1
            ;;
    esac
done

set -- $PKG_ARGS

# Both of --git-remote AND --git-ref must be specified at the same time
if [ $use_remote = true ]; then
    if [ -z "$git_remote" -o -z "$git_ref" ]; then
        echo "Error: you must specify --git-remote and --git-ref at the same time"
        exit 1
    fi
fi

# Check if cloudstack directory exists or not. Options are either:
#
#   1) cloudstack directory is provided through the host's volume
#   2) cloudstack directory is NOT provided and git remote and ref are provided
#
# Any combination of the above situations is invalid.
if [ -d "/mnt/build/cloudstack" ]; then
    if [ $use_remote = true ]; then
        if [ $remove_first = false ]; then
            echo "Error: Could not clone remote git repository, '/mnt/build/cloudstack' exists"
            exit 1
        else
            echo "Removing /mnt/build/cloudstack ..."
            rm -rf /mnt/build/cloudstack
        fi
    fi
else
    if [ $use_remote = false ]; then
        echo "Could not find '/mnt/build/cloudstack'"
        exit 1
    fi
fi

# Clone the remote provided git repo and ref
if [ $use_remote = true ]; then
    echo "Cloning $git_remote ..."
    git clone --quiet --depth=50 $git_remote /mnt/build/cloudstack

    cd /mnt/build/cloudstack

    echo "Fetching $git_ref ..."
    git fetch --quiet origin +$git_ref:

    echo "Checking out $git_ref ..."
    git checkout --quiet --force FETCH_HEAD

    echo -e "\n--------\n"
fi

# Make sure build-deb.sh script exists before going any further
if [ ! -f "/mnt/build/cloudstack/packaging/build-deb.sh" ]; then
    echo "Could not find '/mnt/build/cloudstack/packaging/build-deb.sh'"
    exit 1
fi

# convert LONG flags to SHORT flags for anything prior 4.12.x.x
echo "Detecting CloudStack version ..."
pom_version=$(cd /mnt/build/cloudstack; mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive org.codehaus.mojo:exec-maven-plugin:1.3.1:exec)
major_version=$(echo ${pom_version} | cut -d. -f1)
minor_version=$(echo ${pom_version} | cut -d. -f2)
echo -e "\n--------\n"

if [ $major_version -lt 4 ] || [ $major_version -eq 4 -a $minor_version -lt 12 ]; then
    if [ $show_help = true ]; then
        HELP_ARG=""
    fi
fi

# Show help, both from docker-entrypoint.sh and /mnt/build/cloudstack/packaging/build-deb.sh
if [ $show_help = true ]; then
    if [ -n "$HELP_ARG" ]; then
        help=$(cd /mnt/build/cloudstack/packaging; bash -x ./build-deb.sh $HELP_ARG)
    else
        help=""
    fi
    cat << USAGE
Usage: docker run ... khos2ow/cloudstack-deb-builder [DOCKER_OPTIONS] ... [PACKAGING_OPTIONS]...
CloudStack DEB builder which acts as a wrapper for CloudStack package script. Optionally
you can  specify remote git repository and ref to  be cloned and checked out and run the
packaging script on in.

Optional arguments:
   --git-remote string                     Set the git remote repository to clone (must be set together with \`--git-ref\`) (default: none)
   --git-ref string                        Set the ref from remote repository to check out (must be set together with \`--git-remote\`) (default: none)
   --remove-first                          Remove existing \`/mnt/build/cloudstack\` directory before cloning (default: false)

Other arguments:
   -h, --help                              Display this help message and exit

Examples:
   docker run ... khos2ow/cloudstack-deb-builder [PACKAGING_OPTIONS] ...
   docker run ... khos2ow/cloudstack-deb-builder --git-remote https://path.to.repo/cloudstack.git --git-ref foo-branch [PACKAGING_OPTIONS] ...

--------

$help

USAGE
    exit 0
fi

# Adjust user and group provided by host
function adjust_owner() {
    # if both set then change the owner
    if [ -n "${USER_ID}" -a -z "${USER_GID}" ]; then
        chown -R ${USER_ID} /mnt/build/cloudstack
    elif [ -n "${USER_ID}" -a -n "${USER_GID}" ]; then
        chown -R ${USER_ID}:${USER_GID} /mnt/build/cloudstack
    fi
}

{
    cd /mnt/build/cloudstack/packaging

    # do the packaging
    bash -x ./build-deb.sh $@ && {
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
