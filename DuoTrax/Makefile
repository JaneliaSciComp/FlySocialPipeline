include ../base.mk

CONTAINER_NAME = duotrax

CBTRACK_DIR = ../external-modules/cbtrack
DTFE_DIR = ../external-modules/duotrax-fixerrors

OBJS := $(addprefix bin/, DuoTrax)

all: ${OBJS}

BUILD_OPTS = \
        -m DuoTrax \
        -d bin \
        -I src/matlab \
        -I ${CBTRACK_DIR} \
        -I ${CBTRACK_DIR}/filehandling \
        -I ${CBTRACK_DIR}/misc \
        -I ${DTFE_DIR}/matlab/netlab

bin/DuoTrax.ctf:: src/matlab//DuoTrax.m
	echo "Create application CTF archive"
	-mkdir -p bin
	${MCC} \
        -v \
        -c \
	${BUILD_OPTS}

bin/DuoTrax:: bin/DuoTrax.ctf
	echo "Create application standalone executable"
	${MCC} \
        -v \
        -C \
	${BUILD_OPTS}

buildDockerImage:: bin/DuoTrax
	${DOCKER} build . \
        -t ${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}
