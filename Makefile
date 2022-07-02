DOCKER		= docker
DOCKERFILE	= Dockerfile
PORT		= 8080
TAG		= debian-vnc
LINT_IGNORE	= "DL3007"
BUILDER_CNF	= ./builder/builder.toml
BUILDER_IMG	= my-builder:bionic
CONTAINER	= k3d-on-docker_dind_1
DEBIAN_VERSION	= 3.10

all: build

hadolint:
	$(DOCKER) run --rm -i hadolint/hadolint hadolint - --ignore ${LINT_IGNORE} < $(DOCKERFILE)

build:
	$(DOCKER) buildx build --platform linux/amd64 -t $(TAG) --load .

run:
	$(DOCKER) run -d --name $(TAG) -p 5900:5900 $(TAG)

clean:
	$(DOCKER) rm -f $(TAG)
	$(DOCKER) container prune -f

