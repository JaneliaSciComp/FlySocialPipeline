EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data

docker run \
       -v $DATA_DIR:/data:rw \
       -it \
       registry.int.janelia.org/heberlein/duotrax:1.0 \
       -e /data/experiments/$EXP_NAME \
       -xml /data/config/Clstr3R_params.xml \
       -s /data/settings \
       $*
