"""

"""
rule unicycler:
    input:
        paired = expand(config['reads_dir']+"{sample}/{read}_combined.trimmed.fastq.gz", read=["R1", "R2"], allow_missing=True)
    output:
        "data/assembled/{sample}/assembly.fasta"
    priority: 10
    log:
        "data/logs/assembled/{sample}.log"
    threads: config['unicycler']['threads']
    params:
        extra="-t "+str(config['unicycler']['threads'])
    wrapper:
        "0.68.0/bio/unicycler"