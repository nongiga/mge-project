#DONE
rule bowtie2_align_pangenome:
    input:
        multiext("bowtie2_index/{group}/pangenome",".1.bt2", ".2.bt2", ".3.bt2", ".4.bt2", ".rev.1.bt2", ".rev.2.bt2"),
        sample="split_reads/"+str(config['global_name'])+"{sample}.R1_spl.combined.trimmed.fastq.gz"
    output:
        temp("pangenome_aligned/{sample}.{group}.bam")
    log:
        "logs/pangenome_aligned/{sample}.{group}.log"
    params:
        index="bowtie2_index/{group}/pangenome",
        extra=config['bowtie2_pangenome']['extra']
    threads: config['bowtie2_pangenome']['threads']
    conda: "../envs/bowtie2.yaml"
    shell:
        "bowtie2 --threads {threads} {params.extra} -x {params.index} {input.sample} \
        | samtools view -Sbh -o {output} -"