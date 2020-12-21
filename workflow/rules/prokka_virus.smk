#DONE
rule prokka_virus:
	input:
		"assembled/{sample}/assembly.fasta"
	output:
		temp(multiext("vir_annontated/{sample}/{sample}.","err","faa","ffn","fna","fsa","gbk","gff","log","sqn","tbl","tsv","txt"))
	params:
		  sample='{sample}',
		  cov=config['prokka']['coverage'],
		  evalue=config['prokka']['evalue'],
		  kingdom="Viruses"
	threads: config['prokka']['threads']
	shell:
		"prokka --outdir vir_annontated/{params.sample} --prefix {params.sample} --locustag {params.sample}  --cpus {threads} \
		   --coverage {params.cov} --evalue {params.evalue} --kingdom {params.kingdom} {input} --force"