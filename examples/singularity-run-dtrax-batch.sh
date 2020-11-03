experimentFolder=$1

for exp in `ls ${experimentFolder}` ; do
    bsub -P heberlein \
	 -o duotrax-${exp}.log \
         singularity run \
         -B /groups/heberlein/heberleinlab/Simon:/groups/heberlein/heberleinlab/Simon \
         -B /groups/branson/home/leea30/jsp/settings:/groups/branson/home/leea30/jsp/settings \
         -B ${experimentFolder}:${experimentFolder} \
         docker://registry.int.janelia.org/heberlein/duotrax:1.0 \
         -e ${experimentFolder}/${exp} \
         -xml /groups/heberlein/heberleinlab/Simon/Code/ConfigFiles/Clstr3R_params.xml \
         -s /groups/branson/home/leea30/jsp/settings/base
done

