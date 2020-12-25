rule samtools_index_pangenome:
    input:
        "pangenome_aligned/{sample}.{group}.sorted.bam"
    output:
        "pangenome_aligned/{sample}.{group}.sorted.bam.bai"
    params:
        config['samtools_index_pangenome']['extra'] # optional params string
    threads: config['samtools_index_pangenome']['threads']

    shell:
        "samtools index {params} {input} {output}"
