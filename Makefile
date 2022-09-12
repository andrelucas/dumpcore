
BUILDAH     = sudo buildah

REGISTRY				= docker.io/andrelucas
NAME					= dumpcore
TAG						= latest
FULLNAME				= $(REGISTRY)/$(NAME):$(TAG)
BUILDAH_MANIFEST		= build-$(NAME)

BIN			= dumpcore
CFLAGS		= -O0 -g

##
## Targets inside the image.
##

all: $(BIN)

clean:
	rm -f $(BIN)

##
## Targets outside the image.
##

buildx:
	echo $(FULLNAME)
	$(BUILDAH) manifest rm $(BUILDAH_MANIFEST) || true
	$(BUILDAH) manifest create $(BUILDAH_MANIFEST)
	$(BUILDAH) build --tag $(FULLNAME) --manifest $(BUILDAH_MANIFEST) --arch amd64 .
	$(BUILDAH) build --tag $(FULLNAME) --manifest $(BUILDAH_MANIFEST) --arch arm64 .
	$(BUILDAH) manifest push --all $(BUILDAH_MANIFEST) $(FULLNAME)

##
## Platform utilities.
##

rhel:
	sudo yum -y install qemu-system-amd64 qemu-system-aarch64
