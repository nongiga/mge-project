rule bwa_mem2_mem:
	input:
		multiext("assembled/"+config['global_name']+"{sample1}/assembly",".0123",".amb",".ann", ".bwt.2bit.64", ".pac"),
		reads=expand("Filtered_data/"+config['global_name']+"{sample2}/{read}_combined.trimmed.fastq.gz", read=["R1", "R2"], allow_missing=True)
	output:
		"mgefinder/{group}/00.bam/{sample2}.{sample1}.bam"
	log:
		"logs/bwa_mem2/{group}.{sample2}.{sample1}.log"
	params:
		index="assembled/"+config['global_name']+"{sample1}/assembly",
		extra=r"-R '@RG\tID:"+config['global_name']+"{sample1}\tSM:"+config['global_name']+"{sample1}'",
		sort=config['bwa_mem2_mem']['sort'],
		sort_order=config['bwa_mem2_mem']['sort_order'],
		global_name=config['global_name'],
		sort_extra=""
	threads: config['bwa_mem2_mem']['threads']
	shell:
		"bwa-mem2 mem -t {threads} {params.index} {input.reads} | samtools sort -o {output} -"
