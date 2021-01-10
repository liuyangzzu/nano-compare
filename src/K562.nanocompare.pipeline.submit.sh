#!/bin/bash
#SBATCH --job-name=nanoc.pipeline.submit.K562
#SBATCH --partition=compute
#SBATCH --mem=50g # memory pool for all cores
#SBATCH --time=03:00:00 # time (DD-HH:MM:SS)
#SBATCH --output=log/%x.%j.out
#SBATCH --error=log/%x.%j.err

###################################################################################
### Settings for K562 dataset experimentation                                   ###
### This is the only file we need to modify for different data                  ###
### Nanopore tools tested for DeepSignal, Nanopolish, DeepMod and Tombo         ###
### Nano-compare project by Yang Liu                                            ###
###################################################################################
# set -x

### Input dataset parameters prepared for pipeline###
# dsname    -   data set name
# targetNum -   number of tasks splited to run
dsname=K562
targetNum=50

### Nanopore raw signal fast5 files, K562 is from tier2: /tier2/li-lab/Nanopore/NanoporeData/Leukemia_ONT/20180612_180601-18-li-004-GXB01102-001/  47.46GB
# inputDataDir  -   input of Nanopore reads file/files, can be tar file or a directory contains files
inputDataDir=/projects/li-lab/yang/workspace/nano-compare/data/raw-fast5/K562/K562-Nanopore_GT18-07372.fast5.tar

### Running configurations
### which nanopore tools can be used, such as ToolList=(Tombo DeepSignal)
# ToolList  -   a list of Nanopore tools prepared to run
#ToolList=(DeepMod)

ToolList=(DeepSignal Tombo DeepMod Nanopolish)


### Which step is going to run, true or false, if 'true' means running this step

run_preprocessing=false
run_basecall=false
run_resquiggling=false
run_methcall=false
run_combine=false
run_clean=true

### true if inputDataDir is a folder contains *.tar or *.tar.gz
multipleInputs=false

### which kind of intermediate file we want to backup or clean, these options are used in final stage of combine step
tar_basecall=false
tar_methcall=true
clean_basecall=true
clean_preprocessing=true

### The output base dir
outbasedir=/fastscratch/liuya/nanocompare/${dsname}-Runs
mkdir -p ${outbasedir}

### Reference file path configuration, used by each base or meth calling
correctedGroup="RawGenomeCorrected_000"
refGenome="/projects/li-lab/reference/hg38/hg38.fasta"
chromSizesFile="/projects/li-lab/yang/workspace/nano-compare/data/genome-annotation/hg38.chrom.sizes"
deepsignalModel="/projects/li-lab/yang/workspace/nano-compare/data/dl-model/model.CpG.R9.4_1D.human_hx1.bn17.sn360/bn_17.sn_360.epoch_7.ckpt"
deepModModel="/projects/li-lab/yang/workspace/nano-compare/data/dl-model/rnn_conmodC_P100wd21_f7ne1u0_4/mod_train_conmodC_P100wd21_f3ne1u0"
clusterDeepModModel="/projects/li-lab/yang/workspace/nano-compare/data/dl-model/na12878_cluster_train_mod-keep_prob0.7-nb25-chr1/Cg.cov5.nb25"

### Number of processes for basecall, alignment, and methlation nanopore tool
processors=16
#processors=64

isGPU="no"
###################################################################################
###################################################################################
###################################################################################


###################################################################################
### Preserve followings to run Base Modified Prediction pipeline                ###
###################################################################################
# Please put this file at nano-compare/src dir, or it need modify following paths
# change working path to script path
cd "$(dirname "$0")"/nanocompare/methcall

source nanocompare.pipeline.submit.sh

###################################################################################
###################################################################################
###################################################################################