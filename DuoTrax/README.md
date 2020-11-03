## Building on MAC

`MATLAB_ROOT=/Applications/MATLAB_R2019a.app make -e`

## Building on (any) Linux

`make`

## Building the docker image

`make buildDockerImage`

or to also push it to Janelia's docker registry
`make dockerImage`

## Running the matlab binary

```
run_DuoTrax.sh /misc/local/matlab-2019a \
       movFile /data/experiments/M5-116_5-116test_p03/movie.avi \
       trackXMLfile /data/config/Clstr3R_params.xml \
       settingsDir /data/settings
```

## Running with singularity

```
EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data
singularity run \
       -B ${DATA_DIR}:/data \
       docker://registry.int.janelia.org/heberlein/duotrax:1.0 \
       -e /data/experiments/$EXP_NAME \
       -xml /data/config/Clstr3R_params.xml \
       -s /data/settings
```

## Running with singularity on the cluster
```
EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data

bsub -n 2 -P heberlein \
       -o duotrax${EXP_NAME}.out \
       singularity run \
       -B ${DATA_DIR}:/data \
       docker://registry.int.janelia.org/heberlein/duotrax:1.0 \
       -e /data/experiments/$EXP_NAME \
       -xml /data/config/Clstr3R_params.xml \
       -s /data/settings
```

## Running with docker

```
EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data
docker run \
       -v $DATA_DIR:/data:rw \
       -it \
       registry.int.janelia.org/heberlein/duotrax:1.0 \
       -e /data/experiments/$EXP_NAME \
       -xml /data/config/Clstr3R_params.xml \
       -s /data/settings
```
