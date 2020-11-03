DOCKER = docker
VERSION = 1.0
DOCKER_REGISTRY = registry.int.janelia.org
CONTAINER_NAME = vggclassifier

buildDockerImage: pipeline/classify_fly_wings.py
	${DOCKER} build . \
        -t ${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME} \
        -t ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}

dockerImage: buildDockerImage
	${DOCKER} push ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}:${VERSION}
	${DOCKER} push ${DOCKER_REGISTRY}/heberlein/${CONTAINER_NAME}

clean:
	-rm -rf bin
