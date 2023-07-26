
# INCLUDE BUILD VARIABLES
include vars.mk


# IMAGE BUILD PATHS
DIRS := build/bin           \
	build/cgish/bin     \
	build/cgish/cgi-bin \
	build/cgish/lib     \
	build/etc


# BUSYBOX BUILD VARS
# SEE:
#   https://busybox.net/FAQ.html
BBOX := build/bin/busybox
FLAGS = --static
JOBS = $$(echo "$$(nproc) / 2" | bc)
URL = git://git.busybox.net/busybox


# CGI SCRIPT
CGISH := build/cgish/lib/cgish


# NAME SERVICE SWITCH CONFIG
NSS := build/etc/nsswitch.conf


# DOCKER BUILD VARS
DOCKER_APP = cgish
DOCKER_USER ?= $(DOCKER_USER)/
HAS_GIT_TREE = $$(git rev-parse --is-inside-work-tree)
ifeq ($(HAS_GIT_TREE), true)
	DOCKER_TAG = $$(git log --format="%h" -n 1)
else
	DOCKER_TAG = latest
endif


# RULES
all: $(DIRS) $(BBOX) $(CGISH) $(NSS) docker_build
.PHONY: all


$(DIRS):
	mkdir -vp $(DIRS)


$(BBOX): build/bin
	git clone $(URL)
	cd busybox/; make defconfig
	(cd busybox/; LDFLAGS=$(FLAGS) $(MAKE) -j $(JOBS))
	cp -v busybox/busybox $@
	cd build/bin; ln -sv busybox sh


$(CGISH): build/cgish
	cp -v cgish $@
	chmod -c 755 $@
	cd build/cgish/bin; ln -sv ../lib/cgish run
	cd build/cgish/cgi-bin; ln -sv ../lib/cgish index.cgi


$(NSS): build/etc
	touch $@
	echo "hosts: files dns" >$@


docker_build: build/bin/sh
	cd build; docker build --build-arg PORT=$(PORT) --file ../Dockerfile --tag $(DOCKER_USER)$(DOCKER_APP):$(DOCKER_TAG) .

