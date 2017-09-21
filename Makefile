-include env_make

VERSION ?= 3

REPO = docksal/backstopjs
NAME = docksal-backstopjs-$(VERSION)

.PHONY: build test push shell run start stop logs clean release

build:
	fin docker build -t $(REPO):$(VERSION) .

test:
	IMAGE=$(REPO):$(VERSION) NAME=$(NAME) tests/test.bats

shell:
	fin docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) --entrypoint=bash $(REPO):$(VERSION)

clean:
	fin docker rm -f $(NAME) || true

default: build
