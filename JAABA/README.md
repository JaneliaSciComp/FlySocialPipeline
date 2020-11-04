## Building on MAC

`MATLAB_ROOT=/Applications/MATLAB_R2019a.app make -e`

## Building on (any) Linux

`make`

## Building the docker image

`make buildDockerImage`

or to also push it to Janelia's docker registry
`make pushDockerImage`

## Running the matlab binary

```
run_JAABADetect.sh /misc/local/matlab-2019a \
       /data/experiments/M5-116_5-116test_p03 \
       jablistfile /data/config/LEC.txt
```

## Running with singularity

### Before manual curration
```
EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data
CONFIG_DIR=/nrs/scicompsoft/goinac
singularity run \
       -B $DATA_DIR:/data \
       -B $CONFIG_DIR:$CONFIG_DIR:ro \
       docker://registry.int.janelia.org/heberlein/jaabadetect:1.0 \
       -e /data/experiments/$EXP_NAME \
       -jl /data/config/LEC.txt
```
### After manual curation
```
EXP_NAME=M5-116_5-116test_p04
DATA_DIR=$PWD/data
CONFIG_DIR=/nrs/scicompsoft/goinac

singularity run \
       -B $DATA_DIR:/data \
       -B $CONFIG_DIR:$CONFIG_DIR:ro \
       docker://registry.int.janelia.org/heberlein/jaabadetect:1.0 \
       -e /data/experiments/just-tracked/$EXP_NAME \
       -jl /data/config/LEC.txt \
       --dtfe-append 1
```

## Running with singularity on the cluster (after manual curation)

JAABADetect is a step that can take advantage of multiple cores.

```
EXP_NAME=M5-116_5-116test_p04
DATA_DIR=$PWD/data
CONFIG_DIR=/nrs/scicompsoft/goinac

bsub -n 16 -P heberlein \
       -o jaabadetect-with-dtfe-append${EXP_NAME}.out \
       singularity run \
       -B $DATA_DIR:/data \
       -B $CONFIG_DIR:$CONFIG_DIR:ro \
       docker://registry.int.janelia.org/heberlein/jaabadetect:1.0 \
       -e /data/experiments/just-tracked/$EXP_NAME \
       -jl /data/config/LEC.txt \
       --dtfe-append 1
```

## Running with docker

### Before manual curation
```
EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data
CONFIG_DIR=/nrs/scicompsoft/goinac
docker run \
       -v $DATA_DIR:/data:rw \
       -v $CONFIG_DIR:$CONFIG_DIR \
       -it \
       registry.int.janelia.org/heberlein/jaabadetect:1.0 \
       -e /data/experiments/$EXP_NAME \
       -jl /data/config/LEC.txt
```
### After manual curation
```
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
       --dtfe-append 1
```
