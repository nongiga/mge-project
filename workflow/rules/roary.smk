#DONE
rule roary:
    input:
        lambda wildcards: expand(join("data/annontated",GLOBALNAME+"{sample}",GLOBALNAME+"{sample}.gff"),
                                 sample=GROUPS.get(int(wildcards.group)))
    output:
        "data/pangenome/{group}/pan_genome_reference.fa"
    log:
        "data/logs/pangenome/{group}.log"
    params:
        identity=config['roary']['identity']
        threads=config['roary']['threads']
        outdir="data/pangenome/{wildcards.group}"
    threads: config['roary']['threads']
    shell:
        "rm -rf {params.outdir};\
        roary -e --mafft -i {params.identity} -p {threads} -o {wildcards.group} -f {params.outdir} {input};"