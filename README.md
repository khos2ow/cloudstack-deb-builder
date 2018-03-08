# CloudStack DEB Package builder using Docker
Docker images for building Apache CloudStack DEB packages.

This will give portable, immutable and reproducable mechanism to build packages for releases. A very good candidate to be used by the Jenkins slaves of the project.

# Table of Contents

- [Supported tags and respective Dockerfile links](https://github.com/khos2ow/cloudstack-deb-builder#supported-tags-and-respective-dockerfile-links)
- [Packges installed in Conatiner](https://github.com/khos2ow/cloudstack-deb-builder#packges-installed-in-conatiner)
- [Building packages](https://github.com/khos2ow/cloudstack-deb-builder#building-packages)
  - [Clone Apache CloudStack source code](https://github.com/khos2ow/cloudstack-deb-builder#clone-apache-cloudstack-source-code)
  - [Pull Docker Images](https://github.com/khos2ow/cloudstack-deb-builder#pull-docker-images)
  - [Build Packages](https://github.com/khos2ow/cloudstack-deb-builder#build-packages)
  - [Maven Cache](https://github.com/khos2ow/cloudstack-deb-builder#maven-cache)
- [Build Help](https://github.com/khos2ow/cloudstack-deb-builder#build-help)

# Supported tags and respective Dockerfile links
- [`latest`, `ubuntu1604` (ubuntu1604/Dockerfile)](https://github.com/khos2ow/cloudstack-deb-builder/blob/master/ubuntu1604/Dockerfile)
- [`ubuntu1404` (ubuntu1404/Dockerfile)](https://github.com/khos2ow/cloudstack-deb-builder/blob/master/ubuntu1404/Dockerfile)

# Packges installed in Conatiner
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

# Building packages
Building DEB packages with the Docker container is rather easy, a few steps are required:

## Clone Apache CloudStack source code
The first step required is to clone the CloudStack source code somewhere on the filesystem, in `/tmp` for example:

    cd /tmp
    git clone https://github.com/apache/cloudstack.git cloudstack

Now that you have done so we can continue.

## Pull Docker Images
Let's assume we want to build packages for Ubuntu 16.04 (Xenial). We pull that image first:

    docker pull khos2ow/cloudstack-deb-builder:ubuntu1604

You can replace `ubuntu1604` tag by `ubuntu1404` or `latest` if you want.

## Build Packages
Now that we have the Docker images we can build packages by mapping `/tmp` into `/mnt/build` in the container. (Note that the container always expects the `cloudstack` code exists in `/mnt/build` path.)

    docker run \
        -v /tmp:/mnt/build \
        khos2ow/cloudstack-deb-builder:ubuntu1604 [ARGS...]

Or if your local cloudstack folder has other name, you need to map it to `/mnt/build/cloudstack`.

    docker run \
        -v /tmp/cloudstack-custom-name:/mnt/build/cloudstack \
        khos2ow/cloudstack-deb-builder:ubuntu1604 [ARGS...]

After the build has finished the *.deb* packages are available in */tmp/cloudstack/dist/debbuild/DEBS* on the host system.

## Maven Cache
You can provide Maven cache folder (`~/.m2`) as a volume to the container to make it run faster.

    docker run \
        -v /tmp:/mnt/build \
        -v ~/.m2:/root/.m2 \
        khos2ow/cloudstack-deb-builder:ubuntu1604 [ARGS...]

# Build Help
To see all the available options you can pass to `docker run ...` command:

    docker run \
        -v /tmp:/mnt/build \
        khos2ow/cloudstack-deb-builder:ubuntu1604 --help

