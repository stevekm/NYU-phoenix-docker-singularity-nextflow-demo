# Makefile for building containers
none:

.PHONY: base demo1

base:
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
