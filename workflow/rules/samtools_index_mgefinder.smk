rule samtools_index_mgefinder:
	input:
		"mgefinder/{group}/00.bam/{sample2}.{sample1}.bam"
	output:
		"mgefinder/{group}/00.bam/{sample2}.{sample1}.bam.bai"
	params:
		""
	resources:
		mem_mb=128
	shell:
		"samtools index {params} {input} {output}"