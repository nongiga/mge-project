rule samtools_sort_pangenome:
    input:
        "data/pangenome_aligned/{sample}.{group}.bam"
    output:
        "data/pangenome_aligned/{sample}.{group}.sorted.bam"
    params:
        extra=config['samtools_sort_pangenome']['extra'],
        tmp_dir=config['samtools_sort_pangenome']['tmpdir']
    threads: config['samtools_sort_pangenome']['threads']
    wrapper:
        "0.68.0/bio/samtools/sort"