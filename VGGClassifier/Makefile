include ../base.mk

CONTAINER_NAME = vggclassifier

buildDockerImage:: pipeline/classify_fly_wings.py
	${DOCKER} build . \
        -t ${CONTAINER_NAME} \
        -t ${DOCKER_REPO}/${CONTAINER_NAME} \
        -t ${DOCKER_REPO}/${CONTAINER_NAME}:${VERSION}
