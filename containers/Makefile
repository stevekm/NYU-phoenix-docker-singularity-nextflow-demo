# Makefile for building containers
none:

.PHONY: base demo1 docker vagrant docker2singularity

# ~~~~~ BUILD & TEST DOCKER CONTAINERS LOCALLY ~~~~~ #
# make sure Docker is running
docker:
	docker >/dev/null 2>&1

base: docker
	cd base && docker build -t stevekm/phoenix-demo:base .

demo1: base
	cd demo1 && docker build -t stevekm/phoenix-demo:demo1 .

build: base demo1

pull:
	docker pull stevekm/phoenix-demo:base
	docker pull stevekm/phoenix-demo:demo1

test-base: base
	docker run --rm -ti stevekm/phoenix-demo:base bash

test-demo1: demo1
	docker run --rm -ti stevekm/phoenix-demo:demo1 bash


# ~~~~~ CONVERT DOCKER CONTAINER TO SINGULARITY CONTAINER LOCALLY ~~~~~ #
# setup the docker2singularity Docker container and convert the demo Docker to Singularity
docker2singularity: demo1 docker
	docker run -v /var/run/docker.sock:/var/run/docker.sock -v ${PWD}/demo1:/output --privileged -t --rm singularityware/docker2singularity stevekm/phoenix-demo:demo1



# ~~~~~ TEST THE CONVERTED CONTAINER WITH VAGRANT ~~~~~ #
# make sure vagrant is running
vagrant:
	vagrant -v >/dev/null 2>&1

# remove the Vagrant files and Singularity image
clean:
	[ -f Vagrantfile ] && rm -f Vagrantfile
	[ -d .vagrant ] && rm -rf .vagrant
	rm -f demo1/stevekm_phoenix-demo_demo1*.img

# test the new Singularity container inside Vagrant
# NOTE: macOS sed -i syntax
# NOTE: make sure there's only 1 .img file in the image dir!
# clean first to remove remnants from previous runnings of this step!
test-docker2singularity: clean docker2singularity vagrant
	vagrant init singularityware/singularity-2.4 && \
	sed -i '' 's|  # config.vm.synced_folder "../data", "/vagrant_data"|  config.vm.synced_folder "demo1", "/demo1"|' Vagrantfile && \
	vagrant up && \
	vagrant ssh -c 'singularity exec /demo1/stevekm_phoenix-demo_demo1*.img demo1_test.sh'
