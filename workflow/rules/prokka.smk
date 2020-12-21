

rule prokka:
	input:
		assembly="assembled/{sample}/assembly.fasta",
		vir="vir_annontated/{sample}/{sample}.gbk"
	output:
		multiext("annontated/{sample}/{sample}.","err","faa","ffn","gbk","gff","tsv","txt"),
		temp(multiext("annontated/{sample}/{sample}.","fna","fsa","log","sqn","tbl"))
	params:
		  sample='{sample}',
		  cov=config['prokka']['coverage'],
		  evalue=config['prokka']['evalue'],
		  kingdom="Bacteria"
	threads: config['prokka']['threads']
	shell:
		"prokka  --outdir annontated/{params.sample} --prefix {params.sample} --locustag {params.sample}  --cpus {threads} \
		   --coverage {params.cov} --evalue {params.evalue} --kingdom {params.kingdom} \
		   --proteins {input.vir} {input.assembly} --force"