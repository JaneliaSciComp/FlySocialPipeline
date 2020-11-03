if [ $(uname) == 'Linux' ]; then
	echo "Detected Host System: Linux"
	# Setup xauth file location; Remove if exists
	echo "Setting up X11 forwarding for User: ${USER}"
	XTEMP=/tmp/.docker.xauth.${USER}
	if [ -e ${XTEMP} ]; then
		rm -f ${XTEMP}
	fi

	# Create new xauth file
	touch ${XTEMP}

	# modify xauth file
	xauth nlist $(hostname)/unix:${DISPLAY:1:1} | sed -e 's/^..../ffff/' | xauth -f ${XTEMP} nmerge -

    docker run \
    	-e DISPLAY=${DISPLAY} \
		-e QT_X11_NO_MITSHM=1 \
		-v ${XTEMP}:${XTEMP} \
		-e XAUTHORITY=${XTEMP} \
		--device=/dev/dri:/dev/dri \
        -v /tmp/:/tmp/ \
		--net=host \
        -v ${DATA_DIR}/:/data/:rw \
        -it \
        registry.int.janelia.org/heberlein/fixerrors:1.0 \
        $*

	# Clean up auth file when done
	if [ -e ${XTEMP} ]; then
		rm -f ${TEMP}
	fi

elif [ $(uname) == 'Darwin' ]; then

    localip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

    xhost + $localip

    DISPLAY_NUM=`ps -ef | grep "Xquartz :\d" | grep -v xinit | awk '{ print $9; }'`

    DISPLAY="${localip}${DISPLAY_NUM}"

    echo "Display: ${DISPLAY}"

    DISPLAY_PARAM="-e DISPLAY=${DISPLAY}"

    DATA_DIR=${PWD}/local/testData

    docker run \
        -v /tmp/:/tmp/ \
        -v ${DATA_DIR}/:/data/:rw \
        ${DISPLAY_PARAM} \
        -it \
        registry.int.janelia.org/heberlein/fixerrors:1.0 \
        $*
fi
