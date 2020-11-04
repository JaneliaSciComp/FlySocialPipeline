#!/usr/bin/env nextflow

/*
    Fly Behavior Pipeline

    Parameters:
        in: input directory containing avi movies
        out: output directory
        config: configuration directory
        crepo: container repository
        xml: xml config file name based on the movie frames
        withFrameFilter: {0|1} frame filter for generating image stacks
*/

params.config = "/nrs/scicompsoft/jspipeline/ConfigFiles"
params.in = "$HOME/movies"
params.out = "$baseDir/output"
params.crepo = "registry.int.janelia.org/heberlein"
params.xml = "Clstr3R_params.xml"
params.withFrameFilter = 1

configDir = file(params.config)
inputDir = file(params.in)
outputDir = file(params.out)
containersRepository = params.crepo
xmlConfigFile = params.xml
useFrameFilter = params.withFrameFilter

if( !inputDir.exists() ) {
  error "The specified input directory does not exist: ${params.in}"
}
log.info "Processing input: $inputDir"

/*
    Set up output directory
*/
log.info "Saving results to: $outputDir"

roiFile = file("${configDir}/roidata.mat")

avis_to_process = Channel
                    .fromPath("$inputDir/*.avi")
                    .map { f -> [f.simpleName, f] }

process MovieFileSetup {

    input:
    tuple val(experimentName), val(aviFile) from avis_to_process

    output:
    val "$outputDir/${aviFile.simpleName}" into experiments_to_process

    """
    umask 0000
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
 * Generate track data using DuoTrax
*/
process GenerateTrackData {

    container = "$containersRepository/duotrax:1.0"
    cpus 1

    input:
    val experimentPath from experiments_to_process

    output:
    val experimentPath into experiments_tracked
    stdout into trackResult

    """
    /app/entrypoint.sh \
        -e $experimentPath \
        -xml $configDir/$xmlConfigFile \
        -s $configDir
    """
}

trackResult.subscribe { println it }

/**
 * Generate perframe data
 */
process GeneratePerFrameData {
    label: supportsCPUParallelism

    container = "$containersRepository/jaabadetect:1.0"

    input:
    val experimentPath from experiments_tracked

    output:
    val experimentPath into experiments_with_perframedata
    stdout into perFrameResult

    """
    /app/entrypoint.sh \
        -e $experimentPath \
        -jl $configDir/LEC.txt
    """
}

perFrameResult.subscribe { println it }

/**
 * Generate Image Stacks for the Deep ID Classifier
 */
process GenerateImageStacks {
    container = "$containersRepository/imagestack:1.0"
    cpus 1

    input:
    val experimentPath from experiments_with_perframedata

    output:
    val experimentPath into experiments_with_imagestackdata
    stdout into imageStackResult

    """
    /app/entrypoint.sh \
        $experimentPath \
        $useFrameFilter \
        $configDir/$xmlConfigFile \
        $configDir/deepID_values.txt
    """
}

imageStackResult.subscribe { println it }

/**
 * Run Deep ID Classifier
 */
process RunVGGClassifier {
    label: requireGPU

    container = "$containersRepository/vggclassifier:1.0"
    cpus 1

    input:
    val experimentPath from experiments_with_imagestackdata

    output:
    val experimentPath into experiments_with_classifiedstacks
    stdout into imageStackClassifierResult

    """
    /scripts/fly_wings.sh \
        -i $experimentPath \
        -o $experimentPath/vgg
    """
}

imageStackClassifierResult.subscribe { println it }
