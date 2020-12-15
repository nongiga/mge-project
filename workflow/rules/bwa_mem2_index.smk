
rule bwa_mem2_index:
    input:
        "data/assembled/{sample}/assembly.fasta"
    output:
        multiext("data/assembled/{sample}/assembly", ".0123",".amb",".ann", ".bwt.2bit.64", ".bwt.8bit.32",".pac"),
    log:
        "data/logs/bwa-mem2_index/{sample}.log"
    params:
        prefix="data/assembled/{sample}/assembly"
    wrapper:
        "0.68.0/bio/bwa-mem2/index"
