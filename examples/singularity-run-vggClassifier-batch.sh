experimentFolder=$1

CONTAINER_IMAGE=vggclassifier.simg
REMOTE_IMAGE=docker://registry.int.janelia.org/heberlein/vggclassifier:1.0

if [[ ! -f ${CONTAINER_IMAGE} ]] ; then
    echo "Build the local $CONTAINER_IMAGE} image from ${REMOTE_IMAGE}"
    singularity build ${CONTAINER_IMAGE} ${REMOTE_IMAGE}
fi

for exp in `ls ${experimentFolder}` ; do
    bsub -n 2 -P heberlein \
        -gpu "num=1" -q gpu_any \
        -o ${experimentFolder}/${exp}/vgg-${exp}.log \
        -e ${experimentFolder}/${exp}/vgg-${exp}-errors.log \
        singularity \
        run \
        --nv \
        -B ${experimentFolder}:${experimentFolder} \
        ${CONTAINER_IMAGE} \
        -i ${experimentFolder}/${exp} \
        -o ${experimentFolder}/${exp}/vgg
done
