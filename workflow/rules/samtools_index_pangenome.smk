rule samtools_index_pangenome:
    input:
        "data/pangenome_aligned/{sample}.{group}.sorted.bam"
    output:
        "data/pangenome_aligned/{sample}.{group}.sorted.bam.bai"
    params:
        config['samtools_index_pangenome']['params'] # optional params string
    threads: config['samtools_index_pangenome']['threads']
    wrapper:
        "0.68.0/bio/samtools/index"
