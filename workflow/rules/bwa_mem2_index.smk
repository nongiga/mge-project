
rule bwa_mem2_index:
	input:
		"assembled/{sample}/assembly.fasta"
	output:
		multiext("assembled/{sample}/assembly", ".0123",".amb",".ann", ".bwt.2bit.64", ".pac"),
	log:
		"logs/bwa-mem2_index/{sample}.log"
	params:
		prefix="assembled/{sample}/assembly"
	shell:
		 "bwa-mem2 index -p {params.prefix} {input}"
