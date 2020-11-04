MAKEFILES = $(shell find . -maxdepth 2 -type f -name Makefile)
SUBDIRS = $(filter-out ./,$(dir $(MAKEFILES)))

.PHONY: all clean

all:
	for dir in $(SUBDIRS); do \
	    make -C $$dir all; \
	done

buildDockerImage:
	for dir in $(SUBDIRS); do \
	    make -C $$dir buildDockerImage; \
	done

pushDockerImage:
	for dir in $(SUBDIRS); do \
	    make -C $$dir pushDockerImage; \
	done

clean:
	for dir in $(SUBDIRS); do \
	    make -C $$dir clean; \
	done
