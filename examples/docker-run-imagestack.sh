EXP_NAME=M5-116_5-116test_p03
BASE_DIR=/groups/heberlein/heberleinlab/Simon

# ImageStack parameters:
#   experimentDir
#   filterValue: {0, 1} - if 1 filter frames based on trackconfig otherwise process all frames
#   vggConfigFile
#   trackConfigFile
#
# Here is a full example:
# docker run \
#       -v /groups/heberlein/heberleinlab/Simon:/data \
#       -it \
#       registry.int.janelia.org/heberlein/imagestack:1.0 \
#       /data/PipelineTest_4JCS_oldCode /M5-116_5-116test_p03 \
#       1 \
#       /data/ConfigFiles/deepID_values.txt \
#       /data/ConfigFiles/Clstr3R_params45000.xml

docker run \
       -v $DATA_DIR:/data:rw \
       -it \
       registry.int.janelia.org/heberlein/imagestack:1.0 \
       $*
