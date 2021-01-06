import pandas, re, yaml

class NoAliasDumper(yaml.SafeDumper):
    def ignore_aliases(self, data):
        return True

def process_same_strain_file(same_strain_file, *arg):
    """
    Processes Mathew's original 'all_same_strain_pairs' to get a linear list of all the sample plates and their
    respective group

    :param same_strain_file: Mathew's og file, saved under workflow/config
    :return: pandas dataformat of linearized list
    """
    ss=pandas.read_excel(same_strain_file, engine='openpyxl')
    ss=ss.drop(['Drisha_1','Drisha_2','Sampling_date1','Sampling_date2','No_SNPs'], axis=1)
    ss=ss.dropna(axis=0, how='all')
    ss2=ss.drop(["Seq_plate_position_2"],axis=1).rename(columns={"Seq_plate_position_1":"Seq_plate_position_2"})
    ss=ss.drop(["Seq_plate_position_1"],axis=1).append(ss2,ignore_index=True)
    ss=ss.rename(columns={"Seq_plate_position_2":"Seqplates"})
    ss["Seqplates"]=[re.sub(r'([A-H])', r'_\1',k) for k in ss["Seqplates"]]
    ss["Seqplates"]=[re.sub('\.', '',k) for k in ss["Seqplates"]]
    ss['RandomID']=ss['RandomID'].astype(int)
    if len(arg)>1:
        ss.to_csv(arg[0])
    
    return ss

def create_run_configuration(config_file):
    """

    :param config_file: configuration file for snakemake workflow
    :return: none
    """


    config=yaml.safe_load(open(config_file))

    ss=process_same_strain_file(config['same_strain_file'], config['same_strain_output'])

    PRIORITY_GROUPS= [int(line.strip()) for line in open(config['priority_samples_file'], 'r')]
    groups=ss.groupby('RandomID')['Seqplates'].apply(lambda g: list(set(g.values.tolist()))).to_dict()
    groups_p={key: value for key, value in groups.items() if key in PRIORITY_GROUPS}
    samples = [item for sublist in groups.values() for item in sublist]

    if config["test_mode"]:
        groups=config['test_group']
        groups_p=groups
        samples=[config['global_name'] + item for sublist in groups.values() for item in sublist]

    config['groups']=groups
    config['groups_p'] = groups_p
    config['samples'] = samples

    with open('workflow/config/config.yaml','w') as yamlfile:
        yaml.Dumper.ignore_aliases = lambda *args: True
        yaml.dump(config, yamlfile, Dumper=NoAliasDumper, sort_keys=False) # Also note the safe_dump

    return config

