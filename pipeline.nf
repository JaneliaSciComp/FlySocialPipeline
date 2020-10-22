#!/usr/bin/env nextflow

/*
    Fly Behavior Pipeline

    Parameters:
        in: input directory containing avi movies
        out: output directory
        config: configuration directory
*/

params.config = "/nrs/scicompsoft/jspipeline/ConfigFiles"
params.in = "$HOME/movies"
params.out = "$baseDir/output"

configDir = file(params.config)
inputDir = file(params.in)
outputDir = file(params.out)

if( !inputDir.exists() ) {
  error "The specified input directory does not exist: ${params.in}"
}
log.info "Processing input: $inputDir"

/*
    Set up output directory
*/

outputDir.mkdirs()
log.info "Saving results to: $outputDir"

roiFile = file(configDir+"/roidata.mat")

avis_to_process = Channel.fromPath(inputDir+"/*.avi").map { f -> [f.simpleName, f] }

process MovieFileSetup {

    input:
    tuple val(experimentName), val(aviFile) from avis_to_process

    output:
    val "$outputDir/${aviFile.simpleName}" into experiments_to_process

    """
    experimentPath="$outputDir/$experimentName"
    if [[ ! -d \$experimentPath ]]; then
        mkdir -p \$experimentPath
        cd \$experimentPath
        cp $aviFile .
        cp $roiFile .
        ln -s *.avi movie.avi || true
    fi
    """
}

/*
    Duotrax with wings
*/
process DtraxWings {

    container = "registry.int.janelia.org/heberlein/duotrax:1.0"
    containerOptions = "-B $configDir"
    cpus 1

    input:
    val experimentPath from experiments_to_process

    output:
    stdout into result

    """
    /app/entrypoint.sh -e $experimentPath -xml $configDir/Clstr3R_params.xml -s $configDir/DuoTrax/base
    """
}

result.subscribe { println it }
