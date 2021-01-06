rule samtools_sort_pangenome:
	input:
		"pangenome_aligned/{sample}.{group}.bam"
	output:
		temp("pangenome_aligned/{sample}.{group}.sorted.bam")
	params:
		extra=config['samtools_sort_pangenome']['extra'],
		tmp_dir=config['samtools_sort_pangenome']['tmpdir']
	threads: config['samtools_sort_pangenome']['threads']
	resources: mem_mb=1000
	shell:
		"samtools sort -T pangenome_aligned/{wildcards.sample}.{wildcards.group} "
		"-O bam {input} > {output}"