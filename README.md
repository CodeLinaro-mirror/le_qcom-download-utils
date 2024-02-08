Prerequisites
=============

Docker needs to be installed on the machine

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
│   └── docker_run.sh
├── LICENSE.md
├── qcom-6.6.00-QLI.1.0-Ver.1.1
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

Run `docker_build.sh` to create the image.
```{.sh}
  $ bash docker/docker_build.sh 2>&1 | tee docker_build.log
```
Optional parameter for docker/docker_build.sh

-f, --dockerfile

dockerfile path (Eg. ./docker/dockerfiles/Dockerfile_20.04)

-t, --dockertag

docker tag name

-r, --release

release (Eg. qcom-6.6.00-QLI.1.0-Ver.1.1)

By Default it will use the latest Release config.sh

Build the yocto image in a docker container
-----------------------------------------------

```{.sh}
  $ bash docker/docker_run.sh 2>&1 | tee sync_build.log
```

Optional parameter for docker/docker_run.sh

-m, --manifest

manifest url

-w, --workdir

Working directory (Eg: /local/mnt/worksapce/test)

-b, --branch

branch name (Eg: LE.QCLINUX.1.0)

-r, --release

release (Eg. qcom-6.6.00-QLI.1.0-Ver.1.1)

-M, --machine

machine (Eg: qcm6490)

-d, --distro

Distro (Eg: qcom-wayland)

-i, --image

Image (Eg: qcom-console-image)

-t, --dockertag

Dockertag

-S, --script

Sync Build Script

-I --itr-session

Interactive docker session

By default it will use the latest Release config.sh

sync_build.sh script is called with docker_run.sh which is having sync and build commands
-----------------------------------------------------------------------------------------
