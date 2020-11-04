include ../base.mk

CONTAINER_NAME = jaabadetect

FEATURE_PARAMS = animalList.xml \
        apt.xml \
        featureConfig.xml \
        featureConfig_adam.xml \
        featureConfig_ARjumps.xml \
        featureConfig_attemptedcopulation.xml \
        featureConfig_mice.xml \
        featureConfig_pivot_headAR.xml \
        featureConfig_RightingAR.xml \
        featureConfig_spacetime_flies.xml \
        featureConfig_spacetime_mice.xml \
        featureConfigAdamMice.xml \
        featureConfigEric.xml \
        featureConfigEyrun.xml \
        featureConfigHoghof.xml \
        featureConfigHoghofDeepStationary.xml \
        featureConfigHoghofplus.xml \
        featureConfigHoghofplus_few.xml \
        featureConfigHoghofplus_hsflow.xml \
        featureConfigHoghofplus_modernNames.xml \
        featureConfigHoghofplusStationary_modernNames.xml \
        featureConfigHoghofplusStationary_modernNames_hsflow.xml \
        featureConfigHoghofplusStationary_modernNames_hsflow_bkgsup.xml \
        featureConfigLarvae.xml \
        featureConfigLarvaehighres.xml \
        featureConfigLarvaehighres_past.xml \
        featureConfigLarvaeLouis.xml \
        featureConfigLarvaeReid.xml \
        featureConfigLarvaeSamuel.xml \
        featureConfigLarvaeSpeciestemp.xml \
        featureConfigList.xml \
        featureConfigMWTContour.xml \
        featureConfigVivekMice.xml \
        featureConfigWings.xml \
        featureConfigWithROIs.xml

JAABA_DEPS = \
        -I ${JAABA_DIR}/filehandling \
        -I ${JAABA_DIR}/misc \
        -I ${JAABA_DIR}/perframe \
        -I ${JAABA_DIR}/perframe/params \
        -I ${JAABA_DIR}/perframe/@Trx \
        -I ${JAABA_DIR}/spaceTime \
        -a ${JAABA_DIR}/perframe/compute_perframe_features/compute_*.m \
        ${INCLUDED_FEATURE_PARAMS}

JAABA_DIR = ../external-modules/jaaba

INCLUDED_FEATURE_PARAMS := $(addprefix -a ${JAABA_DIR}/perframe/params/, ${FEATURE_PARAMS})

OBJS := $(addprefix bin/, JAABADetect dtfe_append)

all: ${OBJS}

bin/JAABADetect.ctf:: ${JAABA_DIR}/perframe/JAABADetect.m
	echo "Create application CTF archive"
	-mkdir -p bin
	${MCC} \
        -v \
        -c \
        -m JAABADetect -d bin ${JAABA_DEPS}

bin/JAABADetect:: bin/JAABADetect.ctf
	echo "Create application standalone executable"
	-mkdir -p bin
	${MCC} \
        -v \
        -C \
        -m JAABADetect -d bin ${JAABA_DEPS}

bin/dtfe_append.ctf:: src/matlab/dtfe_append/appendScoresBatch.m
	echo "Create dtfe_append CTF archive"
	-mkdir -p bin
	${MCC} \
        -c \
        -m appendScores.m \
        -d bin \
        -o dtfe_append \
        -I src/matlab/dtfe_append

bin/dtfe_append:: bin/dtfe_append.ctf
	echo "Create standalone dtfe_append executable"
	-mkdir -p bin
	${MCC} \
        -C \
        -m appendScores.m \
        -d bin \
        -o dtfe_append \
        -I src/matlab/dtfe_append

buildDockerImage:: bin/JAABADetect bin/dtfe_append
	${DOCKER} build . \
	-t ${CONTAINER_NAME} \
	-t ${DOCKER_REPO}/${CONTAINER_NAME} \
	-t ${DOCKER_REPO}/${CONTAINER_NAME}:${VERSION}
