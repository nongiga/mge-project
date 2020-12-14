#DONE
rule prokka_virus:
    input:
        "data/assembled/{sample}/assembly.fasta"
    output:
        temp(multiext("data/vir_annontated/{sample}/{sample}.","err","faa","ffn","fna","fsa","gbk","gff","log","sqn","tbl","tsv","txt"))
    log:
        "data/logs/vir_annontated/{sample}.log"
    params:
          sample='{sample}',
          cov=config['prokka']['coverage'],
          evalue=config['prokka']['evalue'],
          kingdom="Viruses"
    threads: config['prokka']['threads']
    conda:
         "envs/prokka.yaml"
    shell:
        "prokka --outdir data/vir_annontated/{sample} --prefix {sample} --locustag {sample}  --cpus {threads} \
           --coverage {params.cov} --evalue {params.evalue} --kingdom {params.kingdom} {input}"