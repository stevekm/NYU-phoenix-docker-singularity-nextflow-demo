# Containers

This directory contains demo containers for example usage with NYU phoenix HPC system, which runs CentOS 6.8 with Singularity, but lacks OverlayFS, and does not allow users to have admin rights including `root` or `sudo` access, and does not allow the usage of Docker. This sections show how to use Singularity to create containers and use them in this environment despite these restrictions.

Containers can be configured to auto-build in the cloud on [Docker Hub](https://hub.docker.com) and [Singularity Hub](https://www.singularity-hub.org). They can also be built locally with the included `Makefile` (configured for usage on Mac).

This guide will focus on first building Docker containers, then converting them to Singularity containers.

## Included Containers

- `base`: a custom baselayer that sets mount points for `/ifs` on the NYU phoenix HPC system, along with setting up other directories, environment, and example script (`base_test.sh`)

    - `base/Dockerfile`: Docker container file for the base layer

    - `base/Singularity.base`: Singularity container file set to build from the pre-existing `base` Docker container

- `demo1`: a custom container built upon `base` which includes another demo script (`demo1_test.sh`)

    - `demo1/Dockerfile`: Docker container file for the demo1 layer

    - `demo1/Singularity.demo1`: Singularity container file set to build from the pre-existing `demo1` Docker container

# Building Containers

## Local Docker Build

You can build the containers locally with Docker by running the following command inside this directory:

```
$ make build
```

Alternatively, you can pull the pre-built containers from Docker Hub:

```
$ make pull
```

## Local Singularity Build

You can convert the Docker container to a Singularity container locally using Vagrant (see notes in `install_vagrant.md`).

## Cloud

Docker and Singularity containers can be configured to auto-build in the cloud on [Docker Hub](https://hub.docker.com) and [Singularity Hub](https://www.singularity-hub.org)

# Using Containers

## Local Docker Usage

You can test the Docker containers by running the following commands from this directory:

```
$ make test-base
# base_test.sh
# this is the NYU-phoenix-docker-singularity-nextflow-demo base container test script
```

```
$ make test-demo1
# demo1_test.sh
# this is the NYU-phoenix-docker-singularity-nextflow-demo demo1 container test script
```

This will build the containers locally with Docker and start an interactive shell session inside them.

## Local Docker -> Singularity Conversion & Usage

You can convert the Docker container to a Singularity container locally with the following command:

```
$ make docker2singularity
```

This will create a new file in the `demo1` directory with a name such as `stevekm_phoenix-demo_demo1-2018-03-15-016ce17caf05.img`.

As of the time of this writing, running Singularity on Mac requires the usage of Vagrant (see installation notes in `install_vagrant.md`). To test out the Singularity container locally, you can run the following command:

```
$ make test-docker2singularity
```

This command will:

- delete any pre-existing Vagrant files in the current directory

- delete any pre-existing Singularity images in the `demo1` directory

- re-build the Singularity image file from the Docker container

- load the Singularity image file in Vagrant

- execute a test command inside the Singularity container, which should give the following output:

```
this is the NYU-phoenix-docker-singularity-nextflow-demo demo1 container test script
```

When you are done, you can clean up the Vagrant intermediary files with the command:

```
$ make clean
```

## HPC Singularity Container Usage

To use the Singularity container on the phoenix HPC, you can either manually transfer over the converted image file created in the previous sections, or pull the container from Singularity Hub.

### Manual Transfer

After manually copying the image file from your local computer to the remote server on NYU's phoenix HPC system, you can run the container with the following commands:

```bash
module load singularity/2.4.2
new_home="$(mktemp -d)"
singularity shell --home "$new_home" --bind /ifs:/ifs  stevekm_phoenix-demo_demo1-2018-03-15-98ab3fa47f3d.img
```
__NOTES:__

- the environment module `singularity/2.4.2` must be loaded on the host system

- a new temporary home directory must be provided, and its root path must exist both inside the container and on the host file system. The user must also have read & write access to this location. In this case we are using the command `mktemp -d` to create a temporary directory on the host system under `/tmp`, and then binding that to the home directory inside the container using the shell variable `new_home` and the parameter `--home "$new_home"`.

- on the NYU phoenix HPC system, `/ifs` is the network storage location where all user data and directories (including home directories) are stored. In order to access this location inside the container, an empty directory `/ifs` must also exist inside the container. Since our system lacks OverlayFS, we cannot create this location at container run time, so it has already been included in the `base` image and propagated to the `demo1` container. The parameter `--bind /ifs:/ifs` configures the binding of this path. Also note that successful binding of this path is required to preserve the user's current working directory (`$PWD`) inside the container, which is required by Nextflow; otherwise, the `$PWD` inside the container reverts to the container's `$HOME`.

If everything works correctly, the output should look like this:

```
kellys04@phoenix2:~/projects/NYU-phoenix-docker-singularity-nextflow-demo/containers/demo1$ singularity shell --home "$new_home" --bind /ifs:/ifs  stevekm_phoenix-demo_demo1-2018-03-15-98ab3fa47f3d.img
Singularity: Invoking an interactive shell within container...

kellys04@phoenix2:/ifs/home/kellys04/projects/NYU-phoenix-docker-singularity-nextflow-demo/containers/demo1$ demo1_test.sh
this is the NYU-phoenix-docker-singularity-nextflow-demo demo1 container test script
```

### Singularity Hub

Usage of containers built on Singularity Hub is identical, you just specify the hub path instead:

```bash
module load singularity/2.4.2
new_home="$(mktemp -d)"
singularity shell --home "$new_home" --bind /ifs:/ifs  shub://stevekm/phoenix-demo:demo1
```

### Docker Hub

Even though Docker is not installed on phoenix, it is possible to run Docker containers hosted on Docker Hub, assuming they meet the same criteria for bind points as described above.

```bash
singularity shell --home "$new_home" --bind /ifs:/ifs  docker://stevekm/phoenix-demo:demo1
```

__NOTES:__ Some aspects of a Docker container may not transfer over cleanly to Singularity in this way; this can be dealt with by using the Docker -> Singularity conversion steps instead.

# Conclusion

This write-up presents a variety of ways to create and run Singularity containers on a CentOS 6 system despite various system restrictions.

# Software

Software used for this demo

- (local) Docker version 17.12.0-ce, build c97c6d6

- (local) Vagrant version 2.0.1

- (on HPC/Vagrant) Singularity version 2.4.2

# Resources

- http://singularity.lbl.gov/user-guide

- http://singularity.lbl.gov/docs-docker

- http://singularity.lbl.gov/faq
