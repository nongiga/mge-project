
rule bwa_mem2_index:
	input:
		"assembled/{sample}/assembly.fasta"
	output:
		multiext("assembled/{sample}/assembly", ".0123",".amb",".ann", ".bwt.2bit.64", ".bwt.8bit.32",".pac"),
	log:
		"logs/bwa-mem2_index/{sample}.log"
	params:
		prefix="assembled/{sample}/assembly"
	wrapper:
		"0.68.0/bio/bwa-mem2/index"
