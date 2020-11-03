EXP_NAME=M5-116_5-116test_p03
BASE_DIR=/groups/heberlein/heberleinlab/Simon
SETTINGS_DIR=/groups/branson/home/leea30/jsp/settings

# Notice that I am using the same mapping inside the container
# as it is outside the container

singularity run \
       -B ${BASE_DIR}:${BASE_DIR} \
       -B ${SETTINGS_DIR}:${SETTINGS_DIR} \
       docker://registry.int.janelia.org/heberlein/duotrax:1.0 \
       -e ${BASE_DIR}/PipelineTest/$EXP_NAME \
       -xml ${BASE_DIR}/Code/ConfigFiles/Clstr3R_params.xml \
       -s ${SETTINGS_DIR}/base \
	$*
