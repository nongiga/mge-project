#DONE
rule spades_breseq:
	input:
		reads = expand("Filtered_data/"+config['global_name']+"{sample1}/{read}_combined.trimmed.fastq.gz", read=["R1", "R2"], allow_missing=True),
		assembly="spades_annontated/"+config['global_name']+"{sample2}/"+config['global_name']+"{sample2}.gff"
	output:
		#directory("variant_reports/{group}/{sample1}.{sample2}/"),
		"spades_variant_reports/{group}/{sample1}.{sample2}/output/index.html"
	params:
		"spades_variant_reports/{group}/{sample1}.{sample2}/"
	threads: config['breseq']['threads']
	priority: config['breseq']['priority']
	log:
		"logs/spades_variant_reports/{group}/{sample1}.{sample2}.log"
	shell:
		"rm -rf {params}/*; "
		"breseq  -r {input.assembly} {input.reads} -j {threads} -o {params}; "