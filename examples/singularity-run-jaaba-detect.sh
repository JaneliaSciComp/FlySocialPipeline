EXP_NAME=M5-116_5-116test_p04
BASE_DIR=/groups/heberlein/heberleinlab/Simon

singularity run \
       -B $BASE_DIR:${BASE_DIR} \
       docker://registry.int.janelia.org/heberlein/jaabadetect:1.0 \
       -e ${BASE_DIR}/PipelineTest/$EXP_NAME \
       -jl ${BASE_DIR}/Code/ConfigFiles/LEC.txt \
       $*
