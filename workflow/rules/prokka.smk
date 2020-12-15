

rule prokka:
    input:
        assembly="data/assembled/{sample}/assembly.fasta",
        vir="data/vir_annontated/{sample}/{sample}.gbk"
    output:
        multiext("data/annontated/{sample}/{sample}.","err","faa","ffn","fna","fsa","gbk","gff","log","sqn","tbl","tsv","txt")
    log:
        "data/logs/annontated/{sample}.log"
    params:
          sample='{sample}',
          cov=config['prokka']['coverage'],
          evalue=config['prokka']['evalue'],
          kingdom="Bacteria"
    threads: config['prokka']['threads']
    conda:
         "../envs/prokka.yaml"
    shell:
        "prokka  --outdir data/vir_annontated/{params.sample} --prefix {params.sample} --locustag {params.sample}  --cpus {threads} \
           --coverage {params.cov} --evalue {params.evalue} --kingdom {params.kingdom} \
           --proteins {input.vir} {input.assembly}"