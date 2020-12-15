rule samtools_index_mgefinder:
    input:
        "data/mgefinder/{group}/00.bam/{sample2}.{sample1}.bam"
    output:
        "data/mgefinder/{group}/00.bam/{sample2}.{sample1}.bam.bai"
    params:
        ""
    wrapper:
        "0.68.0/bio/samtools/index"