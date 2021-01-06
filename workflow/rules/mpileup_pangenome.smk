
rule mpileup_pangenome:
	input:
		bam="pangenome_aligned/{sample}.{group}.sorted.bam",
		bai="pangenome_aligned/{sample}.{group}.sorted.bam.bai",
		reference_genome="pangenome/{group}/pan_genome_reference.fa",
	output:
		"mpileup_pangenome/{sample}.{group}.bcf"
	log:
		"logs/mpileup_pangenome/{sample}.{group}.log"
	params:
		extra=config['mpileup_pangenome']['extra']  # optional
	resources:
		mem_mb=2000
	shell:
		"bcftools mpileup -d 1000 -f {input.reference_genome} {input.bam} -Ob -o {output}"
