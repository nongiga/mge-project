
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