import os, re, itertools, numpy, pandas
from os.path import basename, join

workdir: "data/"

rule all:
	input:
		breseq=[expand("spades_variant_reports/{group}/{sample1}.{sample2}/output/index.html", sample1=samples,sample2=samples,group=group) for group, samples in config['groups_p'].items()],


#processing up to breseq
include: "rules/spades_prokka.smk"
include: "rules/spades_breseq.smk"
