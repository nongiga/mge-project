"""

"""
rule unicycler:
	input:
		paired = expand("Filtered_data/{sample}/{read}_combined.trimmed.fastq.gz", read=["R1", "R2"], allow_missing=True)
	output:
		"assembled/{sample}/assembly.fasta",
		"assembled/{sample}/unicycler.log",
		"assembled/{sample}/assembly.gfa"
	priority: 50
	log:
		"logs/assembled/{sample}.log"
	threads: config['unicycler']['threads']
	params:
		keep=str(config['unicycler']['keep']),
		output_dir="assembled/{sample}"
	shell:
		"rm -rf {params.output_dir}; unicycler -1 {input.paired[0]} -2 {input.paired[1]} -t {threads} -o {params.output_dir} --keep {params.keep}"