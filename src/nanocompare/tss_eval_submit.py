#!/home/liuya/anaconda3/envs/nmf/bin/python

import csv
import os
import subprocess
from sys import argv

from nanocompare.global_config import src_base_dir

scriptFileName = os.path.join(src_base_dir, "nanocompare", "tss_eval.sbatch")

if __name__ == '__main__':

    infile = open(argv[1], 'r')
    others = ' '.join(argv[2:])
    print(f'Other options={others}')

    csvfile = csv.DictReader(infile, delimiter='\t')
    for row in csvfile:
        if row['status'] == "submit":
            outlogdir = os.path.join('.', 'log')
            os.makedirs(outlogdir, exist_ok=True)

            command = f"""
set -x; 

sbatch --job-name=tss-eval-{row['RunPrefix']} --output=log/%x.%j.out --error=log/%x.%j.err \
--export=ALL,Dataset="{row['Dataset']}",DeepSignal_calls="{row['DeepSignal_calls']}",\
Tombo_calls="{row['Tombo_calls']}",Nanopolish_calls="{row['Nanopolish_calls']}",\
DeepMod_calls="{row['DeepMod_calls']}",Megalodon_calls="{row['Megalodon_calls']}",\
bgTruth="{row['bgTruth']}",RunPrefix="{row['RunPrefix']}",parser="{row['parser']}",\
otherOptions="{others}" {scriptFileName}

echo DONE
"""
            print(f"RunPrefix={row['RunPrefix']}")

            # output sbatch submit a job's results to STDOUT
            print(subprocess.Popen(command, shell=True, stdout=subprocess.PIPE).stdout.read().decode("utf-8"))
