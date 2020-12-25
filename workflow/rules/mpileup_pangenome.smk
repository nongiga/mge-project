
rule mpileup_pangenome:
	input:
		"pangenome_aligned/{sample}.{group}.sorted.bam.bai",
		bam="pangenome_aligned/{sample}.{group}.sorted.bam",
		reference_genome="pangenome/{group}/pan_genome_reference.fa"
	output:
		"mpileup_pangenome/{sample}.{group}.mpileup.gz"
	log:
		"logs/mpileup_pangenome/{sample}.{group}.log"
	params:
		extra=config['mpileup_pangenome']['extra']  # optional
	resources:
		mem_mb=2000
	shell:
		"samtools mpileup -f {input.reference_genome} "
		"{input.bam}  | gzip > {output}"