#DONE
rule breseq:
    input:
        assembly=join("data/annontated/",GLOBALNAME+"{sample1}/",GLOBALNAME+"{sample1}.gff"),
        reads = expand(join(READS_DIR, GLOBALNAME+"{sample2}/{read}_combined.trimmed.fastq.gz"), read=["R1", "R2"], allow_missing=True)
    output:
        "data/breseq/{group}/{sample1}.{sample2}/output/index.html"
    params:
        "data/breseq/{group}/{sample1}.{sample2}/"
    threads: config['breseq']['threads']
    priority: config['breseq']['priority']
    log:
        "data/logs/breseq/{group}/{sample1}.{sample2}.log"
    conda:
        "envs/breseq.yaml"
    shell:
        "breseq  -r {input.assembly} {input.reads} -j {threads} -o {params}"