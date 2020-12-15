
rule mpileup_pangenome:
    input:
        "data/pangenome_aligned/{sample}.{group}.sorted.bam.bai",
        bam="data/pangenome_aligned/{sample}.{group}.sorted.bam",
        reference_genome="data/pangenome/{group}/pan_genome_reference.fa"
    output:
        "data/mpileup_pangenome/{sample}.{group}.mpileup.gz"
    log:
        "data/logs/samtools/mpileup_pangenome/{sample}.{group}.log"
    params:
        extra=config['mpileup_pangenome']['extra']  # optional
    wrapper:
        "0.68.0/bio/samtools/mpileup"