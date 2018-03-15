# NYU phoenix HPC Docker/Singularity Nextflow Demo

Demo on how to run a Nextflow pipeline on the HPC using Singularity containers built from Docker.

# Installation

Clone this repository

```
git clone https://github.com/stevekm/NYU-phoenix-docker-singularity-nextflow-demo.git
cd NYU-phoenix-docker-singularity-nextflow-demo
```

# Usage

## Remote HPC (phoenix)

To run this workflow on the NYU phoenix HPC system, use the following command:

```
make run-p
```

This will:

- install Nextflow to the current directory

- extract a pre-built demo Singularity image from this repository

- run the Nextflow pipeline using the Singularity image

## Local

To run this workflow on your local computer (Docker required), use the following command:

```
make run-l
```

This will:

- install Nextflow to the current directory

- build the Docker containers included in this repository

- run the Nextflow pipeline using the Docker containers

# Contents

- `Makefile`: shortcuts to common actions used in the demo

- `main.nf`: main Nextflow pipeline file

- `nextflow.config`: Nextflow configuration file

- `bin`: directory for scripts to use inside the Nextflow pipeline; its contents will be prepended to your `PATH` when pipeline tasks are executed

- `containers`: directory containing Docker and Singularity container files, along with documentation on their setup & usage

# Software Requirements

## local & remote HPC server

- Java 8 (for Nextflow)

- GraphViz Dot (to compile flowchart)

## local only

- Docker version 17.12.0-ce, build c97c6d6

- Vagrant version 2.0.1 (for tesing Singularity containers)

## remote HPC server only

- Singularity version 2.4.2
