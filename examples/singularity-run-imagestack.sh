EXP_NAME=M5-116_5-116test_p03
BASE_DIR=/groups/heberlein/heberleinlab/Simon

# ImageStack parameters:
#   experimentDir
#   filterValue: {0, 1} - if 1 filter frames based on trackconfig otherwise process all frames
#   trackConfigFile
#   vggConfigFile
#
# Here is a full example:
# singularity run \
#       -B /groups/heberlein/heberleinlab/Simon:/data \
#       docker://registry.int.janelia.org/heberlein/imagestack:1.0 \
#       /data/PipelineTest_4JCS_oldCode/M5-116_5-116test_p03 \
#       1 \
#       /data/ConfigFiles/Clstr3R_params45000.xml \
#       /data/ConfigFiles/deepID_values.txt

singularity run \
       -B $BASE_DIR:${BASE_DIR} \
       docker://registry.int.janelia.org/heberlein/imagestack:1.0 \
       $*
