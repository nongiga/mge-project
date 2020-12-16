rule bwa_mem2_mem:
    input:
        multiext("data/assembled/"+config['global_name']+"{sample1}/assembly",".0123",".amb",".ann", ".bwt.2bit.64", ".bwt.8bit.32",".pac"),
        reads=expand(join(config['reads_dir'], config['global_name']+"{sample2}/{read}_combined.trimmed.fastq.gz"), read=["R1", "R2"], allow_missing=True)
    output:
        "data/mgefinder/{group}/00.bam/{sample2}.{sample1}.bam"
    log:
        "data/logs/bwa_mem2/{group}.{sample2}.{sample1}.log"
    params:
        index="data/assembled/"+config['global_name']+"{sample1}/assembly",
        extra=r"-R '@RG\tID:"+config['global_name']+"{sample1}\tSM:"+config['global_name']+"{sample1}'",
        sort=config['bwa_mem2_mem']['sort'],
        sort_order=config['bwa_mem2_mem']['sort_order'],
        sort_extra=""
    threads: config['bwa_mem2_mem']['threads']
    wrapper:
        "0.68.0/bio/bwa-mem2/mem"