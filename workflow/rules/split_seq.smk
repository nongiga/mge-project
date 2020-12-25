#DONE
rule split_seq:
	input:
		join("Filtered_data/"+config['global_name']+"{sample}/{read}_combined.trimmed.fastq.gz")
	output:
		temp("split_reads/"+config['global_name']+"{sample}.{read}_spl.combined.trimmed.fastq.gz")
	params:
		lngth=config['split_seq']['length'],
	threads: 1
	shell:
		"seqkit sliding {input} -s {params.lngth} -W {params.lngth} | gzip -c >{output};"