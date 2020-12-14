#DONE
rule split_seq:
    input:
        join(READS_DIR, GLOBALNAME+"{sample}/{read}_combined.trimmed.fastq.gz")
    output:
        "data/split_reads/"+GLOBALNAME+"{sample}/{read}_spl.combined.trimmed.fastq.gz"
    params:
        lngth=config['split_seq']['length'],
    conda:
      "envs/seqkit.yaml"
    shell:
        "seqkit sliding {input} -s {params.lngth} -W {params.lngth} | gzip -c >{output};"