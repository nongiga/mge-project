import os, yaml
from snakemake import shell

from scripts.presnakemake_processing import create_run_configuration

config_file="workflow/config/base_config.yaml"

create_run_configuration(config_file)

cmd="snakemake --cores 1 --use-conda -k --snakefile workflow/Snakefile"

#shell(cmd)