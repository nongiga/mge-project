from os.path import basename, join

#DONE
rule unicycler:
    input:
        paired = expand(join(READS_DIR, "{sample}/{read}_combined.trimmed.fastq.gz"), read=["R1", "R2"], allow_missing=True)
    output:
        "assembled/{sample}/assembly.fasta"
    priority: 10
    log:
        "logs/assembled/{sample}.log"
    params:
        extra=" -t 1 "
    wrapper:
        "0.68.0/bio/unicycler"