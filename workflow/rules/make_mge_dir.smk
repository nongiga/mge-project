rule make_mge_dir:
	input:
		"assembled/"+config['global_name']+"{sample}/assembly.fasta"
	output:
		expand("mgefinder/{group}/00.{dirname}/{sample}.fna", dirname=["assembly","genome"],allow_missing=True)
	shell:
		"tee {output} < {input}"