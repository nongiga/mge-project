#DONE
rule prokka_virus:
    input:
        "assembled/{sample}/assembly.fasta"
    output:
        temp(multiext("vir_annontated/{sample}/{sample}.","err","faa","ffn","fna","fsa","gbk","gff","log","sqn","tbl","tsv","txt"))
    log:
        "logs/vir_annontated/{sample}.log"
    params:
        "--outdir vir_annontated/{sample} --prefix {sample} --locustag {sample} \
        --force --evalue 0.05 --coverage 1 --cpus 1 --kingdom Viruses"
    shell:
        "prokka {params} {input}"
#DONE
rule prokka:
    input:
        assembly="assembled/{sample}/assembly.fasta",
        vir="vir_annontated/{sample}/{sample}.gbk"
    output:
        multiext("annontated/{sample}/{sample}.","err","faa","ffn","fna","fsa","gbk","gff","log","sqn","tbl","tsv","txt")
    log:
        "logs/annontated/{sample}.log"
    params:
        "--outdir annontated/{sample} --prefix {sample} --locustag {sample} \
        --force --evalue 0.05 --coverage 1 --cpus 1 --kingdom Bacteria"
    shell:
        "prokka {params} --proteins {input.vir} {input.assembly}"