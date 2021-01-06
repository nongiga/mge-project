#DONE
rule breseq:
	input:
		reads = expand("Filtered_data/"+config['global_name']+"{sample1}/{read}_combined.trimmed.fastq.gz", read=["R1", "R2"], allow_missing=True),
		assembly="annontated/"+config['global_name']+"{sample2}/"+config['global_name']+"{sample2}.gff"
	output:
		#directory("variant_reports/{group}/{sample1}.{sample2}/"),
		"variant_reports/{group}/{sample1}.{sample2}/output/index.html"
	params:
		"variant_reports/{group}/{sample1}.{sample2}/"
	threads: config['breseq']['threads']
	priority: config['breseq']['priority']
	log:
		"logs/variant_reports/{group}/{sample1}.{sample2}.log"
	shell:
		"rm -rf {params}/*; "
		"breseq  -r {input.assembly} {input.reads} -j {threads} -o {params}; "