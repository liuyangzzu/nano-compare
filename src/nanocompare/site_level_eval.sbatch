#!/bin/bash
#SBATCH --job-name=meth-corr
#SBATCH --partition=compute
#SBATCH --qos=long
#SBATCH -N 1 # number of nodes
#SBATCH -n 4 # number of cores
#SBATCH --mem-per-cpu=290g
#SBATCH --time=2-13:59:00 # time (D-HH:MM:SS)
#SBATCH -o log/%x.%j.out # STDOUT
#SBATCH -e log/%x.%j.err # STDERR

##SBATCH --mem 290g # memory pool for all cores
##SBATCH -p gpu
##SBATCH --gres=gpu:1             # number of gpus per node
##SBATCH -q inference

## Pass all following vars to py script
set -x

echo "DeepSignal_calls: $DeepSignal_calls"
echo "Tombo_calls: $Tombo_calls"
echo "Nanopolish_calls: $Nanopolish_calls"
echo "DeepMod_calls: $DeepMod_calls"
echo "DeepMod_cluster_calls: $DeepMod_cluster_calls"
echo "Megalodon_calls": ${Megalodon_calls}
echo "bgTruth: $bgTruth"
echo "parser: $parser"
echo "RunPrefix: $RunPrefix"
echo "otherOptions:" $otherOptions

set -x

echo ${NanoCompareDir}

pythonFn=nanocompare/site_level_eval.py

PYTHONPATH=. python ${pythonFn} --calls DeepSignal:${DeepSignal_calls} \
	Tombo:${Tombo_calls} Nanopolish:${Nanopolish_calls} DeepMod.Cluster:${DeepMod_calls} \
	Megalodon.ZW:${Megalodon_calls} --bgtruth ${parser}:${bgTruth} \
	--runid MethCorr-${RunPrefix} --dsname ${Dataset} \
	--toolcov-cutoff 3 --min-bgtruth-cov 5 --baseFormat 1 \
	$otherOptions #--enable-cache --using-cache #--enable-cache --using-cache # cutoff=3 is reasonable now
