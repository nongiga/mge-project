import os, re, itertools,  pandas
from os.path import basename, join

include: "../rules/unicycler.smk"
include: "../rules/prokka_virus.smk"
include: "../rules/prokka.smk"
include: "../rules/breseq.smk"

rule all:
    input:
        breseq=[expand("data/breseq/{group}/{sample1}.{sample2}/output/index.html", \
                       sample1=samples,sample2=samples,group=group) for group, samples in config['groups_p'].items()]
    output:
          "breseq.done"
    shell:
         "touch {output}"