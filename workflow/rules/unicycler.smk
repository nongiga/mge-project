"""

"""
rule unicycler:
    input:
        paired = expand("Filtered_data/{sample}/{read}_combined.trimmed.fastq.gz", read=["R1", "R2"], allow_missing=True)
    output:
        "assembled/{sample}/assembly.fasta"
    priority: 10
    log:
        "logs/assembled/{sample}.log"
    threads: config['unicycler']['threads']
    params:
        extra="-t "+str(config['unicycler']['threads'])
    shell:
        "unicycler -1 short_reads_1.fastq.gz -2 short_reads_2.fastq.gz -o output_dir"