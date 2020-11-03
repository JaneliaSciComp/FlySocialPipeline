MATLAB_ROOT = /misc/local/matlab-2019a
MCC = ${MATLAB_ROOT}/bin/mcc
DOCKER = docker
VERSION = 1.0
DOCKER_REGISTRY = registry.int.janelia.org

.PHONY: all clean

dockerImage:: buildDockerImage
	${DOCKER} push ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}
	${DOCKER} push ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}

clean::
	-@rm -rf bin
