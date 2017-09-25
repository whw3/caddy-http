NS = whw3
VERSION ?= latest
REPO = caddy-http
NAME = $(NS)/$(REPO)

.PHONY: purge clean start stop plugins.go

all:: build

plugins.go:
	./configure.sh

build: plugins.go
	docker build --rm -t $(NAME) .

push:
	docker push $(NAME)

shell:
	docker run --interactive --rm --tty $(REPO) /bin/bash

purge:
	./purge.sh

release: build
	make push -e VERSION=$(VERSION)

clean:
	./clean.sh

start:
	docker-compose up -d

stop:
	docker-compose down
