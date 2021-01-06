
rule coverage:
	input:
		"pangenome_aligned/{sample}.{group}.sorted.bam.bai",
		bam="pangenome_aligned/{sample}.{group}.sorted.bam",
	output:
		"cov_pangenome/{sample}.{group}.tsv"
	log:
		"logs/cov_pangenome/{sample}.{group}.log"
	shell:
		"samtools coverage {input.bam} > {output}"