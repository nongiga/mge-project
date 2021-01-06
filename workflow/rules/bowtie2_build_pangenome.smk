
rule bowtie2_index_pangenome:
	input:
		reference="pangenome/{group}/pan_genome_reference.fa"
	output:
		temp(multiext("bowtie2_index/{group}/pangenome",".1.bt2", ".2.bt2", ".3.bt2", ".4.bt2", ".rev.1.bt2", ".rev.2.bt2"))
	log:
		"logs/bowtie2_index/{group}/build.log"
	params:
		extra=config['bowtie2_build_pangenome']['extra'],
		index="bowtie2_index/{group}/pangenome"
	threads: config['bowtie2_build_pangenome']['threads']
	shell:
	   "bowtie2-build --threads {threads} {params.extra} "
		"{input.reference} {params.index}"