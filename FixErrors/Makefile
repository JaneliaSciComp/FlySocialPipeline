MATLAB_ROOT = /misc/local/matlab-2019a
MCC = ${MATLAB_ROOT}/bin/mcc
DOCKER = docker
VERSION = 1.0
DOCKER_REGISTRY = registry.int.janelia.org
CONTAINER_NAME = fixerrors

DTFE_DIR = ../external-modules/duotrax-fixerrors

OBJS := $(addprefix bin/, fixerrors)

.PHONY: all clean

all: ${OBJS}

BUILD_OPTS = \
        -m fixerrors \
        -d bin \
        -o fixerrors \
        -I ${DTFE_DIR}/fixerrors \
        -I ${DTFE_DIR}/fixerrors/JavaTableWrapper \
        -I ${DTFE_DIR}/fixerrors/JavaTableWrapper/+uiextras/+jTable \
        -a ${DTFE_DIR}/fixerrors/JavaTableWrapper/+uiextras/+jTable/UIExtrasTable.jar \
        -I ${DTFE_DIR}/matlab/filehandling \
        -I ${DTFE_DIR}/matlab/netlab \
        -I ${DTFE_DIR}/matlab/misc

bin/fixerrors.ctf: ${DTFE_DIR}/fixerrors/fixerrors.m
	echo "Create fixerrors CTF archive"
	-mkdir -p bin
	${MCC} \
        -v \
        -c \
        ${BUILD_OPTS}

bin/fixerrors: bin/fixerrors.ctf
	echo "Create fixerrors standalone executable"
	-mkdir -p bin
	${MCC} \
        -v \
        -C \
        ${BUILD_OPTS}

buildDockerImage: bin/fixerrors
	${DOCKER} build . \
        -t ${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}

dockerImage: buildDockerImage
	${DOCKER} push ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}

clean:
	-rm -rf bin
