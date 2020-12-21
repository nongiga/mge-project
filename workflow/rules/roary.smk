#DONE
rule roary:
	input:
		lambda wildcards: expand(join("annontated",config['global_name']+"{sample}",config['global_name']+"{sample}.gff"),
								 sample=config['groups'].get(int(wildcards.group)))
	output:
		"pangenome/{group}/pan_genome_reference.fa"
	log:
		"logs/pangenome/{group}.log"
	params:
		identity=config['roary']['identity'],
		outdir="data/pangenome/{group}"
	threads: config['roary']['threads']
	shell:
		"roary -e --mafft -i {params.identity} -p {threads} -o {wildcards.group} -f {params.outdir} {input};"