Prerequisites
=============

Install Docker
--------------
```{.sh}
$ bash docker/docker_setup.sh
```
         OR

Please follow this link to install docker - https://docs.docker.com/engine/install/ubuntu/

Check machine configuration
--------------
```{.sh}
$ bash utils/check_config.sh
```

Build with Qcom docker
======================

```{.sh}
.
├── docker
│   ├── docker_build.sh
│   ├── dockerfiles
│   │   ├── Dockerfile_20.04
│   │   └── Dockerfile_22.04
│   ├── docker_run.sh
│   └── docker_setup.sh
├── LICENSE
├── qcom-6.6.13-QLI.1.0-Ver.1.2 (This folder will repeat per release)
│   └── config.sh
├── README.md
└── utils
    ├── check_config.sh
    └── sync_build.sh
```

Set release configuration
-------------

Use `config.sh` to set Dockerfile, Working directory, Release Tag, Sync variables & Build variables for your build setup.

Create a yocto docker image
---------------------------------

Run `docker_build.sh` to create the image with Dockerfile (Dockerfile_20.04) and
Dockertag (qcom-6.6.13-qli.1.0-ver.1.2_20.04), Dockertag taken based on the release
folder in small letters(Docker will not allow Capital letters in Docker tag and appending
with Dockerfile OS version for easy to identify the release build with dockerfile.

```{.sh}
  $ bash docker/docker_build.sh -f ./docker/dockerfiles/Dockerfile_20.04 -t qcom-6.6.13-qli.1.0-ver.1.2_20.04
```

Build the yocto image in a docker container
-----------------------------------------------

Run `docker_run.sh` with release parameter to sync build the release

```{.sh}
  $ bash docker/docker_run.sh -t qcom-6.6.13-qli.1.0-ver.1.2_20.04 -r qcom-6.6.13-QLI.1.0-Ver.1.2
```

Optional parameter for docker/docker_run.sh

-m, --manifest

manifest url

-w, --workdir

Working directory (Eg: /local/mnt/worksapce/test)

-b, --branch

branch name (Eg: LE.QCLINUX.1.0)

-M, --machine

machine (Eg: qcm6490)

-d, --distro

Distro (Eg: qcom-wayland)

-i, --image

Image (Eg: qcom-console-image)

-S, --script

Sync Build Script

-I --itr-session

Interactive docker session

sync_build.sh script is called with docker_run.sh which is having sync and build commands
-----------------------------------------------------------------------------------------
