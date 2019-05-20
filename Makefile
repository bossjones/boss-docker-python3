# encoding utf-8

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
