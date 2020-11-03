MATLAB_ROOT = /misc/local/matlab-2019a
MCC = ${MATLAB_ROOT}/bin/mcc
DOCKER = docker
VERSION = 1.0
DOCKER_REGISTRY = registry.int.janelia.org
CONTAINER_NAME = duotrax

CBTRACK_DIR = ../external-modules/cbtrack
DTFE_DIR = ../external-modules/duotrax-fixerrors

OBJS := $(addprefix bin/, DuoTrax)

.PHONY: all clean

all: ${OBJS}

bin/DuoTrax.ctf: src/matlab//DuoTrax.m
	echo "Create application CTF archive"
	-mkdir -p bin
	${MCC} \
        -v \
        -c \
        -m DuoTrax \
        -d bin \
        -I src/matlab \
        -I ${CBTRACK_DIR} \
        -I ${CBTRACK_DIR}/filehandling \
        -I ${CBTRACK_DIR}/misc \
        -I ${DTFE_DIR}/matlab/netlab

bin/DuoTrax: bin/DuoTrax.ctf
	echo "Create application standalone executable"
	-mkdir -p bin
	${MCC} \
        -v \
        -C \
        -m DuoTrax \
        -d bin \
        -I src/matlab \
        -I ${CBTRACK_DIR} \
        -I ${CBTRACK_DIR}/filehandling \
        -I ${CBTRACK_DIR}/misc \
        -I ${DTFE_DIR}/matlab/netlab

buildDockerImage: bin/DuoTrax
	${DOCKER} build . \
        -t ${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}

dockerImage: buildDockerImage
	${DOCKER} push ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}

clean:
	-rm -rf bin
