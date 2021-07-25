
.EXPORT_ALL_VARIABLES:
VERSION := $(shell git describe --tags)
BUILD := $(shell git rev-parse --short HEAD)
# PROJECTNAME := $(shell basename "$(PWD)")
PROJECTNAME := squid

# If the first argument is "run"...
ifeq (cert,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif
.PHONY: docker
docker: 
	docker build -t nuxion/${PROJECTNAME} .

.PHONY: run
run:
	docker run --rm -p 127.0.0.1:3128:3128 nuxion/${PROJECTNAME} 

.PHONY: test
test:
	curl http://v6.algorinfo.com/v1/get --proxy localhost:3128

.PHONY: release
release: docker
	docker tag nuxion/${PROJECTNAME} registry.int.deskcrash.com/nuxion/${PROJECTNAME}:$(VERSION)
	docker push registry.int.deskcrash.com/nuxion/$(PROJECTNAME):$(VERSION)

