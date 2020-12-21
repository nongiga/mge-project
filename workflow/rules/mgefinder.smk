rule mgefinder:
	input:
		lambda wildcards:
			expand("mgefinder/{group}/00.bam/{sample2}.{sample1}.bam.bai",
				sample1=config['groups'].get(int(wildcards.group)),
				sample2=config['groups'].get(int(wildcards.group)),
				allow_missing=True),
		lambda wildcards:
			expand("mgefinder/{group}/00.{dirname}/{sample}.fna",
				sample=config['groups'].get(int(wildcards.group)),
				dirname=["assembly","genome"],allow_missing=True),
	priority: 40
	output:
		"mgefinder/{group}/dummy.txt"
	conda:
		"../envs/mgefinder.yaml"
	params:
		prefix="mgefinder/{group}/"
	shell:
		"mgefinder workflow denovo {params.prefix}; touch {params.prefix}/dummy.txt"