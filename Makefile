MAKEFILES = $(shell find . -maxdepth 2 -type f -name Makefile)
SUBDIRS = $(filter-out ./,$(dir $(MAKEFILES)))

all:
	for dir in $(SUBDIRS); do \
	    make -C $$dir all; \
	done

buildDockerImage:
	for dir in $(SUBDIRS); do \
	    make -C $$dir buildDockerImage; \
	done

dockerImage:
	for dir in $(SUBDIRS); do \
	    make -C $$dir dockerImage; \
	done

clean:
	for dir in $(SUBDIRS); do \
	    make -C $$dir clean; \
	done
