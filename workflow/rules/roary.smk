#DONE
rule roary:
	input:
		lambda wildcards: expand(join("annontated",config['global_name']+"{sample}",config['global_name']+"{sample}.gff"),
								 sample=config['groups'].get(int(wildcards.group)))
	output:
		"pangenome/{group}/pan_genome_reference.fa",
		directory("pangenome/{group}"),
	log:
		"logs/pangenome/{group}.log"
	params:
		identity=config['roary']['identity'],
		outdir="pangenome/{group}"
	threads: config['roary']['threads']
	resources: mem_mb=10000
	shell:
		"rm -rf {params.outdir};"
		"roary -e --mafft -i {params.identity} -p {threads} -o {wildcards.group} -f {params.outdir} {input};"