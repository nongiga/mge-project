import os, re, itertools, numpy, pandas
from os.path import basename, join

include: "../rules/unicycler.smk"
include: "../rules/prokka_virus.smk"
include: "../rules/prokka.smk"
include: "../rules/roary.smk"
include: "../rules/bowtie2_build_pangenome.smk"
include: "../rules/bowtie2_align_pangenome.smk"
include: "../rules/split_seq.smk"
include: "../rules/samtools_index_pangenome.smk"
include: "../rules/samtools_sort_pangenome.smk"
include: "../rules/mpileup_pangenome.smk"

rule all:
    input:
        mpileup=[expand("data/mpileup_pangenome/{sample}.{group}.mpileup.gz", sample=samples, group=group) for group, samples in config['groups'].items()]
    output:
          "pangenome.done"
    shell:
         "touch {output}"