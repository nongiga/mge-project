import os, yaml
from snakemake import shell

from scripts.python.presnakemake_processing import create_run_configuration

config_file="workflow/config/base_config.yaml"

create_run_configuration(config_file)

cmd="snakemake --cores 16 --use-conda -k --snakefile workflow/Snakefile --rerun-incomplete"

shell(cmd)