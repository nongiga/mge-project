import os, re, itertools, pandas
from os.path import basename, join

include: "../rules/unicycler.smk"
include: "../rules/make_mge_dir.smk"
include: "../rules/bwa_mem2_mem.smk"
include: "../rules/bwa_mem2_index.smk"
include: "../rules/samtools_index_mgefinder.smk"
include: "../rules/mgefinder.smk"

rule all:
    input:
        mgefinder=[expand("data/mgefinder/{group}/dummy.txt", group=group) for group in config['groups'].keys()]
    output:
          "mgefinder.done"
    shell:
         "touch {output}"