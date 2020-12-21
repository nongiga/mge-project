
rule mpileup_pangenome:
	input:
		"pangenome_aligned/{sample}.{group}.sorted.bam.bai",
		bam="pangenome_aligned/{sample}.{group}.sorted.bam",
		reference_genome="pangenome/{group}/pan_genome_reference.fa"
	output:
		"mpileup_pangenome/{sample}.{group}.mpileup.gz"
	log:
		"logs/samtools/mpileup_pangenome/{sample}.{group}.log"
	params:
		extra=config['mpileup_pangenome']['extra']  # optional
	shell:
		"samtools mpileup {params.extra} -f {input.reference_genome} "
		"{input.bam}  | pigz > {output} {log}"