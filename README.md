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
├── qcom-6.6.00-QLI.1.0-Ver.1.1
│   └── config.sh
├── qcom-6.6.13-QLI.1.0-Ver.1.2
│   └── config.sh
├── qcom-6.6.13-QLI.1.0-Ver.1.3
│   └── config.sh
├── qcom-6.6.17-QLI.1.0-Ver.1.3
│   └── config.sh
├── qcom-6.6.17-QLI.1.0-Ver.1.3_qim-product-sdk-1.1
│   └── config.sh
├── qcom-6.6.17-QLI.1.0-Ver.1.3_realtime-linux-1.0
│   └── config.sh
├── qcom-6.6.17-QLI.1.0-Ver.1.4
│   └── config.sh
├── qcom-6.6.17-QLI.1.0-Ver.1.4_qim-product-sdk-1.1
│   └── config.sh
├── qcom-6.6.17-QLI.1.0-Ver.1.4_realtime-linux-1.0
│   └── config.sh
├── qcom-6.6.28-QLI.1.1-Ver.1.0
│   └── config.sh
├── qcom-6.6.28-QLI.1.1-Ver.1.0_qim-product-sdk-1.1.1
│   └── config.sh
├── qcom-6.6.28-QLI.1.1-Ver.1.1 (This folder will repeat per release)
│   └── config.sh
├── qcom-6.6.28-QLI.1.1-Ver.1.1_qim-product-sdk-1.1.3
│   └── config.sh
├── qcom-6.6.28-QLI.1.1-Ver.1.1_realtime-linux-1.0
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

Run `docker_build.sh` to create the image with Dockerfile (Dockerfile_22.04) and
Dockertag (qcom-6.6.28-qli.1.1-ver.1.1_22.04), Dockertag taken based on the release
folder in small letters(Docker will not allow Capital letters in Docker tag and appending
with Dockerfile OS version for easy to identify the release build with dockerfile.

```{.sh}
  $ bash docker/docker_build.sh -f ./docker/dockerfiles/Dockerfile_22.04 -t qcom-6.6.28-qli.1.1-ver.1.1_22.04
```

If you are facing issue with above docker build command try using `--no-cache` option This option will force rebuilding of layers already available

```{.sh}
  $ bash docker/docker_build.sh -n --no-cache -f ./docker/dockerfiles/Dockerfile_22.04 -t qcom-6.6.28-qli.1.1-ver.1.1_22.04
```

Build the yocto image in a docker container
-----------------------------------------------

Run `docker_run.sh` with release parameter to sync build the release

```{.sh}
  $ bash docker/docker_run.sh -t qcom-6.6.28-qli.1.1-ver.1.1_22.04 -r qcom-6.6.28-QLI.1.1-Ver.1.1
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
