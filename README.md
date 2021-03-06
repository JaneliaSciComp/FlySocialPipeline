# Fly Social Pipeline

![Pipeline Diagram](docs/pipeline_diagram.png)

## Check out the code
```
git clone git@github.com:JaneliaSciComp/FlySocialPipeline
```

### Pull external modules

* First time
```
git submodule update --init --recursive
```

* Not first time
```
git pull --recurse-submodules
```

## Build

To build all executables run
```
make
```

To build container images
```
make buildDockerImage
```
or to build for a different docker repository than 'registry.int.janelia.org/heberlein'
```
DOCKER_REPO=myrepo make -e buildDockerImage
```

To push container images to the docker repo
```
make pushDockerImage
```
or
```
DOCKER_REPO=myrepo make -e pushDockerImage
```

## Usage

You must have [Nextflow](https://www.nextflow.io) and [Singularity](https://sylabs.io) installed before running the pipeline.

### Local execution
```
./pipeline.nf --in /path/to/avis --config /path/to/config
```

### LSF execution on Janelia cluster
```
./pipeline.nf -profile lsf -with-tower 'http://nextflow.int.janelia.org/api' --in /path/to/avis --config /path/to/config
```
This also uses the internal Janelia instance of Nextflow Tower.

