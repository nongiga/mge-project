
rule spades_only_prokka:
	input:
		assembly="Filtered_data/{sample}/spades_assembly/scaffolds.fasta",
	output:
		"spades_annontated/{sample}/{sample}.gff",
		temp(multiext("spades_annontated/{sample}/{sample}.","fna","fsa","log","sqn","tbl","tsv","txt","err","faa","ffn","gbk"))
	params:
		  sample='{sample}',
		  cov=config['prokka']['coverage'],
		  evalue=config['prokka']['evalue'],
		  kingdom="Bacteria"
	threads: config['prokka']['threads']
	shell:
		"prokka  --outdir spades_annontated/{params.sample} --prefix {params.sample} --locustag {params.sample}  --cpus {threads} "
		"--coverage {params.cov} --evalue {params.evalue} --kingdom {params.kingdom} {input.assembly} --force;"
