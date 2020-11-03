MATLAB_ROOT = /misc/local/matlab-2019a
MCC = ${MATLAB_ROOT}/bin/mcc
DOCKER = docker
VERSION = 1.0
DOCKER_REGISTRY = registry.int.janelia.org
CONTAINER_NAME = imagestack

OBJS := $(addprefix bin/, ImageStack.ctf ImageStack)

.PHONY: all clean

all: ${OBJS}

BUILD_OPTS = \
        -m imageStackMAIN \
        -d bin \
        -o ImageStack \
        -I src/matlab \
        -I src/matlab/xml2struct

bin/ImageStack.ctf: src/matlab/ImageStack.m
	echo "Create application CTF archive"
	-mkdir -p bin
	${MCC} \
        -v \
        -c \
        ${BUILD_OPTS}

bin/ImageStack: bin/ImageStack.ctf
	echo "Create application standalone executable"
	-mkdir -p bin
	${MCC} \
        -v \
        -C \
        ${BUILD_OPTS}

buildDockerImage: bin/ImageStack
	${DOCKER} build . \
        -t ${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}

dockerImage: buildDockerImage
	${DOCKER} push ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}
	${DOCKER} push ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}

clean:
	-rm -rf bin
