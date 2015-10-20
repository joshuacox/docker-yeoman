PROJECT 	?= joshuacox/yeoman
TAG     	?= latest

ifdef REGISTRY
  IMAGE=$(REGISTRY)/$(PROJECT):$(TAG)
else
  IMAGE=$(PROJECT):$(TAG)
endif

build: Dockerfile
	docker build -t $(IMAGE) .

