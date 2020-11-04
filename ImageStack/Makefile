include ../base.mk

CONTAINER_NAME = imagestack

OBJS := $(addprefix bin/, ImageStack.ctf ImageStack)

all: ${OBJS}

BUILD_OPTS = \
        -m imageStackMAIN \
        -d bin \
        -o ImageStack \
        -I src/matlab \
        -I src/matlab/xml2struct

bin/ImageStack.ctf:: src/matlab/ImageStack.m
	echo "Create application CTF archive"
	-mkdir -p bin
	${MCC} \
        -v \
        -c \
        ${BUILD_OPTS}

bin/ImageStack:: bin/ImageStack.ctf
	echo "Create application standalone executable"
	-mkdir -p bin
	${MCC} \
        -v \
        -C \
        ${BUILD_OPTS}

buildDockerImage:: bin/ImageStack
	${DOCKER} build . \
        -t ${CONTAINER_NAME} \
        -t ${DOCKER_REPO}/${CONTAINER_NAME} \
        -t ${DOCKER_REPO}/${CONTAINER_NAME}:${VERSION}
