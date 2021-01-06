import os, yaml
from snakemake import shell

from scripts.presnakemake_processing import create_run_configuration

config_file="workflow/config/base_config.yaml"

create_run_configuration(config_file)

cmd="snakemake -s workflow/server.workflow.smk --configfile workflow/config/config.yaml -j12 --use-conda -k  --until prokka"

shell(cmd)