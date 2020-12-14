"""

"""
rule unicycler:
    input:
        paired = expand(READS_DIR+"{sample}/{read}_combined.trimmed.fastq.gz", read=["R1", "R2"], allow_missing=True)
    output:
        "data/assembled/{sample}/assembly.fasta"
    priority: 10
    log:
        "data/logs/assembled/{sample}.log"
    params:
        extra="-t "+config['unicycler']['threads']
    threads: config['unicycler']['threads']
    wrapper:
        "0.68.0/bio/unicycler"