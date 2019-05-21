# encoding utf-8
SHELL = /bin/bash

# export PATH := $(PATH)
export PATH := ./bin:$(PATH)

# Workspace
CURRENT_DIR := $(shell pwd)

DETECTED_OS := $(shell uname -s)
WHOAMI := $(shell whoami)

ifeq (${DETECTED_OS}, Darwin)
	HOME_DIR    ?= /Users/$(WHOAMI)
else
	HOME_DIR    ?= /home/jenkins
endif

render:
	docker run --rm -it \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $(CURRENT_DIR):/mnt \
	docker.elastic.co/tedi/tedi:0.13 build

# build: move
build:
	tedi build

clean:
	tedi clean --clean-assets

move:
	create-dist

docker-create-dist:
	docker-create-dist /mnt/bin/create-dist

build-ci:
	docker build -t bossjones/docker-pylint:latest .ci/

ci-cli:
	docker run --rm -it \
	-w /mnt \
	-v $(CURRENT_DIR):/mnt \
	bossjones/docker-pylint:latest bash
