#DONE
rule breseq:
    input:
        reads = expand(join(config['reads_dir'], config['global_name']+"{sample1}/{read}_combined.trimmed.fastq.gz"), read=["R1", "R2"], allow_missing=True),
        assembly=join("data/annontated/",config['global_name']+"{sample2}/",config['global_name']+"{sample2}.gff")
    output:
        "data/breseq/{group}/{sample1}.{sample2}/output/index.html"
    params:
        "data/breseq/{group}/{sample1}.{sample2}/"
    threads: config['breseq']['threads']
    priority: config['breseq']['priority']
    log:
        "data/logs/breseq/{group}/{sample1}.{sample2}.log"
    conda:
        "../envs/breseq.yaml"
    shell:
        "breseq  -r {input.assembly} {input.reads} -j {threads} -o {params}"