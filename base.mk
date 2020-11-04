MATLAB_ROOT = /misc/local/matlab-2019a
MCC = ${MATLAB_ROOT}/bin/mcc
DOCKER = docker
VERSION = 1.0
DOCKER_REGISTRY = registry.int.janelia.org
DOCKER_REPO = ${DOCKER_REGISTRY}/heberlein

.PHONY: all clean

pushDockerImage:: buildDockerImage
	${DOCKER} push ${DOCKER_REPO}/${CONTAINER_NAME}:${VERSION}
	${DOCKER} push ${DOCKER_REPO}/${CONTAINER_NAME}

clean::
	-@rm -rf bin
