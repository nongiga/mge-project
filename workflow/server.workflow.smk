import os, re, itertools, numpy, pandas
from os.path import basename, join

workdir: "data/"

rule all:
	input:
		expand("mgefinder/{group}/dummy.txt",group=config['groups'].keys()),
		#mgefinder_bam=[expand("mgefinder/{group}/00.bam/{sample2}.{sample1}.bam.bai", sample1=samples,sample2=samples,group=group) for group, samples in config['groups'].items()],
		#mgefinder_assembly=[expand("mgefinder/{group}/00.{dirname}/{sample}.fna",group=group, sample=samples, dirname=["assembly","genome"]) for group, samples in config['groups'].items()],
		mpileup=[expand("mpileup_pangenome/{sample}.{group}.mpileup.gz", sample=samples, group=groups) for groups, samples in config['groups'].items()],
		breseq=[expand("variant_reports/{group}/{sample1}.{sample2}/output/index.html",sample1=samples,sample2=samples, group=group) for group, samples in config['groups_p'].items()],

	# output:
	# 	"serverworkflow.done"
	# shell:
	# 	"touch {output}"

#processing yp roary
include: "rules/roary.smk"
include: "rules/split_seq.smk"
include: "rules/bowtie2_build_pangenome.smk"
include: "rules/bowtie2_align_pangenome.smk"
include: "rules/mpileup_pangenome.smk"
include: "rules/samtools_sort_pangenome.smk"
include: "rules/samtools_index_pangenome.smk"

#processing up to mgefinder
include: "rules/mgefinder.smk"
include: "rules/make_mge_dir.smk"
include: "rules/bwa_mem2_mem.smk"
include: "rules/bwa_mem2_index.smk"
include: "rules/samtools_index_mgefinder.smk"

#processing up to breseq not including
include: "rules/unicycler.smk"
include: "rules/prokka_virus.smk"
include: "rules/prokka.smk"
include: "rules/breseq.smk"