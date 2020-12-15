#DONE
rule split_seq:
    input:
        join(config['reads_dir'], config['global_name']+"{sample}/{read}_combined.trimmed.fastq.gz")
    output:
        temp("data/split_reads/"+config['global_name']+"{sample}.{read}_spl.combined.trimmed.fastq.gz")
    params:
        lngth=config['split_seq']['length'],
    conda:
      "../envs/seqkit.yaml"
    shell:
        "seqkit sliding {input} -s {params.lngth} -W {params.lngth} | gzip -c >{output};"