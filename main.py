import os
from snakemake import shell



cmd="snakemake --cores 15 --use-conda -k --snakefile workflow/Snakefile --rerun-incomplete"

shell(cmd)