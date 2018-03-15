# Containers

This directory contains demo containers for example usage with NYU phoenix HPC system, which runs CentOS 6.8 with Singularity but without OverlayFS.

They can be configured to auto-build in the cloud on [Docker Hub](https://hub.docker.com) and [Singularity Hub](https://www.singularity-hub.org). They can also be built locally with the included `Makefile` (configured for usage on Mac).

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

To use the Singularity container on the phoenix HPC, you can

# Software

Software used for this demo

- (local) Docker version 17.12.0-ce, build c97c6d6

- (local) Vagrant version 2.0.1

- (on HPC/Vagrant) Singularity version 2.4.2
