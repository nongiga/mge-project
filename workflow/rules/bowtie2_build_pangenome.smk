rule bowtie2_index_pangenome:
    input:
        reference="data/pangenome/{group}/pan_genome_reference.fa"
    output:
        multiext("data/bowtie2_index/{group}/pangenome",".1.bt2", ".2.bt2", ".3.bt2", ".4.bt2", ".rev.1.bt2", ".rev.2.bt2")
    log:
        "data/logs/bowtie2_index/{group}/build.log"
    params:
        extra=config['bowtie2_build_pangenome']['extra']
    threads: config['bowtie2_build_pangenome']['threads']
    wrapper:
        "0.68.0/bio/bowtie2/build"