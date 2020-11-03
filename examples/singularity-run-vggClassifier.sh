EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data
singularity run \
       --nv \
       -B $DATA_DIR:/data \
       docker://registry.int.janelia.org/heberlein/vggclassifier:1.0 \
       -i /data/experiments/tracked/$EXP_NAME \
       -o /data/experiments/tracked/$EXP_NAME/vgg \
       $*
