experimentFolder=$1
configFolder=/nrs/scicompsoft/goinac/simonj/data/config

CONTAINER_IMAGE=imagestack.simg
REMOTE_IMAGE=docker://registry.int.janelia.org/heberlein/imagestack:1.0

if [[ ! -f ${CONTAINER_IMAGE} ]] ; then
    echo "Build the local $CONTAINER_IMAGE} image from ${REMOTE_IMAGE}"
    singularity build ${CONTAINER_IMAGE} ${REMOTE_IMAGE}
fi

for exp in `ls ${experimentFolder}` ; do
    bsub -P heberlein \
	 -o imagestack-${exp}.log \
	 -e imagestack-${exp}-errors.log \
         singularity run \
         -B ${experimentFolder}:${experimentFolder} \
         -B ${configFolder}:${configFolder} \
         ${CONTAINER_IMAGE} \
         ${experimentFolder}/${exp} \
         1 \
         ${configFolder}/Clstr3R_params.xml \
         ${configFolder}/deepID_values.txt
done
