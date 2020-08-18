# Copyright (c) Dirk Chang <dirk@kooiot.com>
# SPDX-License-Identifier: Apache-2.0

MF_DOCKER_IMAGE_NAME_PREFIX ?= kooiot
BUILD_BRANCH ?= master
PROJECT_NAME ?= thingsroot
SERVICES = thingsroot-node-api \
		   thingsroot-web \
		   thingsroot-services \
		   thingsroot-worker \
		   thingsroot-nginx
DOCKERS = $(addprefix docker_,$(SERVICES))

define make_docker
	$(eval svc=$(subst docker_,,$(1)))

	docker build \
		--no-cache \
		--build-arg GIT_BRANCH=$(BUILD_BRANCH) \
		--tag=$(MF_DOCKER_IMAGE_NAME_PREFIX)/$(svc) \
		-f build/$(svc)/Dockerfile .
endef

all: $(DOCKERS)

.PHONY: all $(SERVICES) dockers latest release

clean: cleandocker

clean_images:
	docker rmi -f `docker images | grep '<none>' | awk '{print $3}'`

clean_volumns:
	docker volume ls -f dangling=true -q | xargs -r docker volume rm -f

clean_all_volumns: clean_all_containers
	docker volume ls -q | xargs -r docker volume rm -f

clean_all_containers:
	docker container ls -a -q | xargs -r docker container rm -f

cleandocker:
	# Stop all containers (if running)
	docker-compose --project-name $(PROJECT_NAME) -f docker-compose-thingsroot.yml stop
	# Remove thingsroot containers
	docker ps -f name=$(MF_DOCKER_IMAGE_NAME_PREFIX) -aq | xargs -r docker rm

	# Remove exited containers
	docker ps -f name=$(MF_DOCKER_IMAGE_NAME_PREFIX) -f status=dead -f status=exited -aq | xargs -r docker rm -v

	# Remove unused images
	docker images "$(MF_DOCKER_IMAGE_NAME_PREFIX)\/*" -f dangling=true -q | xargs -r docker rmi

	# Remove old thingsroot images
	docker images -q "$(MF_DOCKER_IMAGE_NAME_PREFIX)\/*" | xargs -r docker rmi

ifdef pv
	# Remove unused volumes
	docker volume ls -f name=$(MF_DOCKER_IMAGE_NAME_PREFIX) -f dangling=true -q | xargs -r docker volume rm
endif

test:
	go test -mod=vendor -v -race -count 1 -tags test $(shell go list ./... | grep -v 'vendor\|cmd')

$(DOCKERS):
	$(call make_docker,$(@))

dockers: $(DOCKERS)

define docker_push
	for svc in $(SERVICES); do \
		docker push $(MF_DOCKER_IMAGE_NAME_PREFIX)/$$svc:$(1); \
	done
endef

changelog:
	git log $(shell git describe --tags --abbrev=0)..HEAD --pretty=format:"- %s"

latest: dockers
	$(call docker_push,latest)

release:
	$(eval version = $(shell git describe --abbrev=0 --tags))
	git checkout $(version)
	$(MAKE) dockers
	for svc in $(SERVICES); do \
		docker tag $(MF_DOCKER_IMAGE_NAME_PREFIX)/$$svc $(MF_DOCKER_IMAGE_NAME_PREFIX)/$$svc:$(version); \
	done
	$(call docker_push,$(version))

run:
	docker-compose --project-name $(PROJECT_NAME) -f docker-compose-thingsroot.yml up

run_daemon:
	docker-compose --project-name $(PROJECT_NAME) -f docker-compose-thingsroot.yml up -d

start:
	docker-compose --project-name $(PROJECT_NAME) -f docker-compose-thingsroot.yml start

stop:
	docker-compose --project-name $(PROJECT_NAME) -f docker-compose-thingsroot.yml stop

down:
	docker-compose --project-name $(PROJECT_NAME) -f docker-compose-thingsroot.yml down

