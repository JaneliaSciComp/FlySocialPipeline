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
run_ImageStack.sh /misc/local/matlab-2019a <dataFolder> <filterValue> <xmlConfigFile> <vggConfigFile>
```

## Running with singularity

```
singularity \
    run -B<data directory outside the container>:/data docker://registry.int.janelia.org/heberlein/imagestack:1.0 \
    /data \
    1 \
    /data/ConfigFiles/Clsr3R_params.xml \
    /data/ConfigFiles/deepID_values.txt
```

## Running with singularity on the cluster
```
EXP=M5-116_5-116test_p08
bsub -n 2 -P heberlein \
    -o imagestack${EXP}.out \
    singularity \
    run \
    -B /groups/heberlein/heberleinlab/Simon/PipelineTest:/data \
    docker://registry.int.janelia.org/heberlein/imagestack:1.0 \
    /data/${EXP} \
    1 \
    /data/ConfigFiles/Clsr3R_params.xml \
    /data/ConfigFiles/deepID_values.txt
```

## Running with docker

```
docker \
    run -v <absolute data directory outside the container>:/data -it \
    registry.int.janelia.org/heberlein/imagestack:1.0 \
    /data \
    1 \
    /data/ConfigFiles/Clsr3R_params.xml \
    /data/ConfigFiles/deepID_values.txt
```
