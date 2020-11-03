EXP_NAME=M5-116_5-116test_p04
DATA_DIR=$PWD/data
CONFIG_DIR=/nrs/scicompsoft/goinac

docker run \
       -v $DATA_DIR:/data:rw \
       -v $CONFIG_DIR:$CONFIG_DIR \
       -it \
       registry.int.janelia.org/heberlein/jaabadetect:1.0 \
       -e /data/experiments/just-tracked/$EXP_NAME \
       -jl /data/config/LEC.txt \
       --dtfe-append 1 \
       $*

