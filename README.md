# CloudStack DEB Package builder using Docker

Docker images for building Apache CloudStack DEB packages.

This will give portable, immutable and reproducable mechanism to build packages for releases. A very good candidate to be used by the Jenkins slaves of the project.

## Table of Contents

- [Supported tags and respective `Dockerfile` links](https://github.com/khos2ow/cloudstack-deb-builder#supported-tags-and-respective-dockerfile-links)
- [Packges installed in conatiner](https://github.com/khos2ow/cloudstack-deb-builder#packges-installed-in-conatiner)
- [Build DEB packages](https://github.com/khos2ow/cloudstack-deb-builder#build-deb-packages)
  - [Clone Apache CloudStack source code](https://github.com/khos2ow/cloudstack-deb-builder#clone-apache-cloudstack-source-code)
  - [Pull Docker images](https://github.com/khos2ow/cloudstack-deb-builder#pull-docker-images)
  - [Build packages](https://github.com/khos2ow/cloudstack-deb-builder#build-packages)
- [Building tips](https://github.com/khos2ow/cloudstack-deb-builder#building-tips)
  - [Maven cache](https://github.com/khos2ow/cloudstack-deb-builder#maven-cache)
  - [Adjust host owner permission](https://github.com/khos2ow/cloudstack-deb-builder#adjust-host-owner-permission)
- [Builder help](https://github.com/khos2ow/cloudstack-deb-builder#builder-help)
- [License](https://github.com/khos2ow/cloudstack-deb-builder#license)

## Supported tags and respective `Dockerfile` links

- [`latest`, `ubuntu1604` (ubuntu1604/Dockerfile)](https://github.com/khos2ow/cloudstack-deb-builder/blob/master/ubuntu1604/Dockerfile)
- [`ubuntu1404` (ubuntu1404/Dockerfile)](https://github.com/khos2ow/cloudstack-deb-builder/blob/master/ubuntu1404/Dockerfile)

## Packges installed in conatiner

List of available packages inside the container:

- dpkg-dev
- devscripts
- debhelper
- genisoimage
- lsb-release
- build-essential
- git
- java 1.8
- maven 3.5.2
- tomcat
- python
- locate
- which

## Build DEB packages

Building DEB packages with the Docker container is rather easy, a few steps are required:

### Clone Apache CloudStack source code

The first step required is to clone the CloudStack source code somewhere on the filesystem, in `/tmp` for example:

    cd /tmp
    git clone https://github.com/apache/cloudstack.git cloudstack

Now that you have done so we can continue.

### Pull Docker images

Let's assume we want to build packages for Ubuntu 16.04 (Xenial). We pull that image first:

    docker pull khos2ow/cloudstack-deb-builder:ubuntu1604

You can replace `ubuntu1604` tag by `ubuntu1404` or `latest` if you want.

### Build packages

Now that we have the Docker images we can build packages by mapping `/tmp` into `/mnt/build` in the container. (Note that the container always expects the `cloudstack` code exists in `/mnt/build` path.)

    docker run \
        -v /tmp:/mnt/build \
        khos2ow/cloudstack-deb-builder:ubuntu1604 [ARGS...]

Or if your local cloudstack folder has other name, you need to map it to `/mnt/build/cloudstack`.

    docker run \
        -v /tmp/cloudstack-custom-name:/mnt/build/cloudstack \
        khos2ow/cloudstack-deb-builder:ubuntu1604 [ARGS...]

After the build has finished the *.deb* packages are available in */tmp/cloudstack/dist/debbuild/DEBS* on the host system.

## Building tips

Check the following tips when using the builder:

### Maven cache

You can provide Maven cache folder (`~/.m2`) as a volume to the container to make it run faster.

    docker run \
        -v /tmp:/mnt/build \
        -v ~/.m2:/root/.m2 \
        khos2ow/cloudstack-deb-builder:ubuntu1604 [ARGS...]

### Adjust host owner permission

Builder container in some cases (e.g. using `--use-timestamp` flag) may change the file and directory owner shared from host to container (through volume) and it will create `dist` directory which holds the final artifacts. You can provide `USER_ID` (mandatory) and/or `USER_GID` (optional) from host to adjust the owner from whitin the container.

This is specially useful if you want to use this image in Jenkins job and want to clean up the workspace afterward. By adjusting the owner, you won't need to give your Jenkins' user `sudo` privilege to clean up.

    docker run \
        -v /tmp:/mnt/build \
        -e "USER_ID=$(id -u)" \
        -e "USER_GID=$(id -g)" \
        khos2ow/cloudstack-deb-builder:ubuntu1604 [ARGS...]

## Builder help

To see all the available options you can pass to `docker run ...` command:

    docker run \
        -v /tmp:/mnt/build \
        khos2ow/cloudstack-deb-builder:ubuntu1604 --help

## License

Licensed under [Apache License version 2.0](http://www.apache.org/licenses/LICENSE-2.0). Please see the [LICENSE](https://github.com/khos2ow/cloudstack-deb-builder/blob/master/LICENSE) file included in the root directory of the source tree for extended license details.
