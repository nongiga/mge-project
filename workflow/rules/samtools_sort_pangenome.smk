rule samtools_sort_pangenome:
	input:
		"pangenome_aligned/{sample}.{group}.bam"
	output:
		"pangenome_aligned/{sample}.{group}.sorted.bam"
	params:
		extra=config['samtools_sort_pangenome']['extra'],
		tmp_dir=config['samtools_sort_pangenome']['tmpdir']
	threads: config['samtools_sort_pangenome']['threads']
	shell:
		"samtools sort {params.extra} {threads} -o {output} "
		"-T {params.tmp_dir} {input}"