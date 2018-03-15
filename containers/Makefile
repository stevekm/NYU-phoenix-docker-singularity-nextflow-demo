# Makefile for building containers
none:

.PHONY: base demo1

base:
	cd base && docker build -t stevekm/nyu-phoenix-docker-singularity-nextflow-demo:base .

demo1: base
	cd demo1 && docker build -t stevekm/nyu-phoenix-docker-singularity-nextflow-demo:demo1 .

build: base demo1

pull:
	docker pull stevekm/nyu-phoenix-docker-singularity-nextflow-demo:base
	docker pull stevekm/nyu-phoenix-docker-singularity-nextflow-demo:demo1

test-base: base
	docker run --rm -ti stevekm/nyu-phoenix-docker-singularity-nextflow-demo:base bash

test-demo1: demo1
	docker run --rm -ti stevekm/nyu-phoenix-docker-singularity-nextflow-demo:demo1 bash
