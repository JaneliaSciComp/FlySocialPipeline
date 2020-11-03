#!/bin/bash
# Scripts to run the classifier that discriminate fly wings (clipped:1, unclipped:-1)
# All data are in .mat file format in a folder with a data structure:
# ".video_cropSTACK", 38x38 by m stack of image frames.
# ".frameNUM", the actual frame number from original video recorded at 30 hz.
# ".clipID" , the labels (-1 is not clipped and 0.1, 0.5, and 1 are ranked clips with 1 being the most).
# ".EuclidDist", measure for each frame of how far the fly moved from the previous frame.
# ".filePATH", directory path where the .avi is saved.
# ".filter_config", fields that contain the the various parameter settings
# Args:
# 1. input directory of the folder including all .mat files
# 2. output directory (optional) of the result. If output directory is not provided, the result will be in the input folder
# Output:
# A .csv file (classification_result.csv) listing file name and corresponding classification result
# Usage when submitting jobs on the cluster:
# bsub -n 1 -o /dev/null "bash fly_wings.sh -i <input data folder> -o <output result folder (optional)>"


umask 0002

# Pass over command line arguments to the python script
python /scripts/classify_fly_wings.py "$@"
