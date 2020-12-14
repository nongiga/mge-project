import os, pandas,re, itertools, numpy
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

#DONE
rule prokka_virus:
    input:
        "assembled/{sample}/assembly.fasta"
    output:
        temp(multiext("vir_annontated/{sample}/{sample}.","err","faa","ffn","fna","fsa","gbk","gff","log","sqn","tbl","tsv","txt"))
    log:
        "logs/vir_annontated/{sample}.log"
    params:
        "--outdir vir_annontated/{sample} --prefix {sample} --locustag {sample} \
        --force --evalue 0.05 --coverage 1 --cpus 1 --kingdom Viruses"
    shell:
        "prokka {params} {input}"
#DONE
rule prokka:
    input:
        assembly="assembled/{sample}/assembly.fasta",
        vir="vir_annontated/{sample}/{sample}.gbk"
    output:
        multiext("annontated/{sample}/{sample}.","err","faa","ffn","fna","fsa","gbk","gff","log","sqn","tbl","tsv","txt")
    log:
        "logs/annontated/{sample}.log"
    params:
        "--outdir annontated/{sample} --prefix {sample} --locustag {sample} \
        --force --evalue 0.05 --coverage 1 --cpus 1 --kingdom Bacteria"
    shell:
        "prokka {params} --proteins {input.vir} {input.assembly}"

#DONE
rule breseq:
    input:
        assembly=join("annontated/",GLOBALNAME+"{sample1}/",GLOBALNAME+"{sample1}.gff"),
        reads = expand(join(READS_DIR, GLOBALNAME+"{sample2}/{read}_combined.trimmed.fastq.gz"), read=["R1", "R2"], allow_missing=True)
    output:
        "breseq/{group}/{sample1}.{sample2}/output/index.html"
    params:
        "breseq/{group}/{sample1}.{sample2}/"
    priority: 50
    log:
        "logs/breseq/{group}/{sample1}.{sample2}.log"

    shell:
        "mkdir -p breseq/{wildcards.group}; \
        breseq  -r {input.assembly} {input.reads} -o {params}"

#DONE
rule split_seq:
    input:
        join(READS_DIR, GLOBALNAME+"{sample}/{read}_combined.trimmed.fastq.gz")
    output:
        "split_reads/"+GLOBALNAME+"{sample}/{read}_spl.combined.trimmed.fastq.gz"
    params:
        lngth=20,
    shell:
        "seqkit sliding {input} -s {params.lngth} -W {params.lngth} | gzip -c >{output};"
#DONE
rule roary:
    input:
        lambda wildcards: expand(join("annontated",GLOBALNAME+"{sample}",GLOBALNAME+"{sample}.gff"),sample=GROUPS.get(int(wildcards.group)))
    output:
        "roary/{group}/pan_genome_reference.fa"
    log:
        "logs/roary/{group}.log"
    params:
        "-e --mafft -i 99 -p"
    shell:
        "rm -rf roary/{wildcards.group};\
        roary {params} -o {wildcards.group} -f roary/{wildcards.group} {input};"

#DONE
rule bowtie2_build:
    input:
        reference="roary/{group}/pan_genome_reference.fa"
    output:
        multiext("bowtie_index/{group}/pangenome",".1.bt2", ".2.bt2", ".3.bt2", ".4.bt2", ".rev.1.bt2", ".rev.2.bt2")
    log:
        "logs/bowtie2_build/{group}/build.log"
    params:
        extra=""
    threads: 8
    wrapper:
        "0.68.0/bio/bowtie2/build"

#DONE
rule bowtie2:
    input:
        multiext("bowtie_index/{group}/pangenome",".1.bt2", ".2.bt2", ".3.bt2", ".4.bt2", ".rev.1.bt2", ".rev.2.bt2"),
        sample="split_reads/"+GLOBALNAME+"{sample}/R1_spl.combined.trimmed.fastq.gz"
    output:
        temp("pangenome_mapped/{sample}.{group}.bam")
    log:
        "logs/bowtie2/{sample}.{group}.log"
    params:
        index="bowtie_index/{group}/pangenome",
        extra=""
    shell:
        "bowtie2 --threads 8 {params.extra} -x {params.index} {input.sample} | samtools view -Sbh -o {output} -"

#Done not tested
rule samtools_sort:
    input:
        "pangenome_mapped/{sample}.{group}.bam"
    output:
        "pangenome_mapped/{sample}.{group}.sorted.bam"
    params:
        extra = "-m 4G",
        tmp_dir = "/tmp/"
    threads: 8 
    wrapper:
        "0.68.0/bio/samtools/sort"


rule samtools_index_pangenome:
    input:
        "pangenome_mapped/{sample}.{group}.sorted.bam"
    output:
        "pangenome_mapped/{sample}.{group}.sorted.bam.bai"
    params:
        "" # optional params string
    wrapper:
        "0.68.0/bio/samtools/index"

rule mpileup:
    input:
        "pangenome_mapped/{sample}.{group}.sorted.bam.bai",
        bam="pangenome_mapped/{sample}.{group}.sorted.bam",
        reference_genome="roary/{group}/pan_genome_reference.fa"
    output:
        "mpileup/{sample}.{group}.mpileup.gz"
    log:
        "logs/samtools/mpileup/{sample}.{group}.log"
    params:
        extra="-d 10000",  # optional
    wrapper:
        "0.68.0/bio/samtools/mpileup"


rule bwa_mem2_index:
    input:
        "assembled/{sample}/assembly.fasta"
    output:
        multiext("assembled/{sample}/assembly", ".0123",".amb",".ann", ".bwt.2bit.64", ".bwt.8bit.32",".pac"),
    log:
        "logs/bwa-mem2_index/{sample}.log"
    params:
        prefix="assembled/{sample}/assembly"
    wrapper:
        "0.68.0/bio/bwa-mem2/index"

rule bwa_mem2_mem:
    input:
        multiext("assembled/"+GLOBALNAME+"{sample1}/assembly",".0123",".amb",".ann", ".bwt.2bit.64", ".bwt.8bit.32",".pac"),
        reads=expand(join(READS_DIR, GLOBALNAME+"{sample2}/{read}_combined.trimmed.fastq.gz"), read=["R1", "R2"], allow_missing=True)
    output:
        "mgefinder/{group}/00.bam/{sample2}.{sample1}.bam"
    log:
        "logs/bwa_mem2/{group}.{sample2}.{sample1}.log"
    params:
        index="assembled/"+GLOBALNAME+"{sample1}/assembly",
        extra=r"-R '@RG\tID:"+GLOBALNAME+"{sample1}\tSM:"+GLOBALNAME+"{sample1}'",
        sort="samtools",
        sort_order="coordinate",
        sort_extra=""
    threads: 8
    wrapper:
        "0.68.0/bio/bwa-mem2/mem"


rule samtools_index_mgefinder:
    input:
        "mgefinder/{group}/00.bam/{sample2}.{sample1}.bam"
    output:
        "mgefinder/{group}/00.bam/{sample2}.{sample1}.bam.bai"
    params:
        "" 
    wrapper:
        "0.68.0/bio/samtools/index"

rule make_mge_dir:
    input:
        "assembled/"+GLOBALNAME+"{sample}/assembly.fasta" 
    output:
        expand("mgefinder/{group}/00.{dirname}/{sample}.fna", dirname=["assembly","genome"],allow_missing=True)
    shell:
        "tee {output} < {input}"

rule mgefinder:
    input:
        lambda wildcards: 
            expand("mgefinder/{group}/00.bam/{sample2}.{sample1}.bam.bai",
                sample1=GROUPS.get(int(wildcards.group)), 
                sample2=GROUPS.get(int(wildcards.group)), 
                allow_missing=True),
        lambda wildcards: 
            expand("mgefinder/{group}/00.{dirname}/{sample}.fna",
                sample=GROUPS.get(int(wildcards.group)), 
                dirname=["assembly","genome"],allow_missing=True),
    priority: 40
    output:
        "mgefinder/{group}/dummy.txt"
    params:
        prefix="mgefinder/{group}/"
    conda:
        "database/mgefinder.yaml"
    shell:
        "mgefinder workflow denovo {params.prefix}; touch {params.prefix}/dummy.txt"