
BUILDAH     	= sudo buildah
PODMAN		= sudo podman

REGISTRY				= docker.io/andrelucas
NAME					= dumpcore
TAG						= latest
FULLNAME				= $(REGISTRY)/$(NAME):$(TAG)
BUILDAH_MANIFEST		= build-$(NAME)

BIN		= dumpcore
CFLAGS		= -O0
LDFLAGS		= -static

##
## Targets inside the image.
##

all: dumpcore install

install:
	install -t / -o root -g root -m 0755 dumpcore

clean:
	rm -f $(BIN)

##
## Targets outside the image.
##

buildx: prep amd64 arm64 push

prep:
	echo $(FULLNAME)
	$(PODMAN) manifest rm $(BUILDAH_MANIFEST) || true
	$(PODMAN) manifest create $(BUILDAH_MANIFEST)

amd64:
	$(PODMAN) build -v $(PWD):/src --tag $(FULLNAME) --manifest $(BUILDAH_MANIFEST) --arch amd64 .

arm64:
	$(PODMAN) build -v $(PWD):/src --tag $(FULLNAME) --manifest $(BUILDAH_MANIFEST) --arch arm64 .

push:
	$(PODMAN) manifest push --all $(BUILDAH_MANIFEST) $(FULLNAME)

##
## Platform utilities.
##

rhel:
	sudo yum -y install qemu-system-x86 qemu-system-aarch64
