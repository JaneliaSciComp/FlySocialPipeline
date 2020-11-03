## Building the docker image

`make buildDockerImage`

or to also push it to Janelia's docker registry
`make dockerImage`

## Running with singularity

```
EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data

singularity \
    --nv \
    run -B<data directory outside the container>:/data \
    docker://registry.int.janelia.org/heberlein/vggclassifier:1.0 \
    -i /data/experiments/tracked/$EXP_NAME \
    -o /data/experiments/tracked/$EXP_NAME/vgg
```

## Running with singularity on the cluster
```
EXP_NAME=M5-116_5-116test_p03
DATA_DIR=$PWD/data

bsub -n 2 -P heberlein \
    -gpu "num=1" -q gpu_any \
    -o vgg${EXP}.out \
    singularity run \
    -B<data directory outside the container>:/data \
    --nv \
    docker://registry.int.janelia.org/heberlein/vggclassifier:1.0 \
    -i /data/experiments/tracked/$EXP_NAME \
    -o /data/experiments/tracked/$EXP_NAME/vgg
```
