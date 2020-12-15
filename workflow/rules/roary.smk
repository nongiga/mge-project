#DONE
rule roary:
    input:
        lambda wildcards: expand(join("data/annontated",config['global_name']+"{sample}",config['global_name']+"{sample}.gff"),
                                 sample=config['groups'].get(int(wildcards.group)))
    output:
        "data/pangenome/{group}/pan_genome_reference.fa"
    log:
        "data/logs/pangenome/{group}.log"
    params:
        identity=config['roary']['identity'],
        outdir="data/pangenome/{group}"
    threads: config['roary']['threads']
    conda: "../envs/roary.yaml"
    shell:
        "rm -rf {params.outdir};\
        roary -e --mafft -i {params.identity} -p {threads} -o {wildcards.group} -f {params.outdir} {input};"