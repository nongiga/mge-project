# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %% [markdown]
# ## To merge:
#  - Mathew's matlab data
#  - my cluster identification data
#  - mgefinder
#  - breseq (one day, hopefully)
# 


# %%
# add same strain data to awkward array so that each isolate has 
#   1. whether it is a part of a same-strain subset (true/false for filtering)
#   2. the # of SNPs between it and its colleagues
import sys
sys.path.append('PycharmProjects/mge-project/scripts/')
from presnakemake_processing import process_same_strain_file
same_strain_list=process_same_strain_file("~/PycharmProjects/mge-project/workflow/config/All_same_strain_pairs.xlsx")

print(same_strain_list)

# %% [markdown]
# #### My cluster data
# Plan data structure:
# 
# Person
# 
# 1. RandomID
# 2. NewRandomID
# 3. Same-strain case
#    1. CaseNum
#    2. Isolate
#       1. GFF data
#       2. RowNum
#       3. IsoNum
#       4. SampleDate
#       5. RawSeqsDir
#       6. RawSubDirName
#       7. SeqsDir
#       8. SeqsSubDirName
#       9. ReadLength
#       10. Used
#       11. Used_old
#       12. LowQualityThrs
#       13. Freezer_pos
#    2. Pangenome
#       1. gene names
#       2. gene IDs
#       3. coverage data
#       4. possible other roary input
#    3. MGEfinder
#    4. Breseq
#    5. Identified MGEs
# 4. Antibiotics purchase
# ...
# 
# %% [markdown]
# ## Task #1: import all data into person
# ### Experimenting with Awkward Array

# %%
import awkward as ak
import pprint
import pandas as pd
import numpy as np
import json

isolates_list=pd.read_excel("~/PycharmProjects/mge-project/workflow/config/isolates_list_Maccabi_E.coli_UTI_SeqPlates1to25.xlsx",
        engine="openpyxl")
isolates_list=isolates_list     .dropna(axis=1,how="all")     .dropna(axis=0,how="all")     .convert_dtypes(convert_floating=False)
isolates_list.SampleDate=isolates_list.SampleDate.apply(str)


# %%

#created nested struct and awkward array from excel
df=isolates_list
ilj = (df.groupby(['NewRandomID','RandomID','CaseNum'])
             .apply(lambda x: x[['IsoNum', 'RowNum','SampleDate','SeqSubDirName','LowQualityThrs', 'Freezer_pos', 'Used', 'SiteString']]
             .to_dict("records"))
             .reset_index()
             .rename(columns={0:'Isolates'})
             .to_json(orient='records'))
#print(json.dumps(json.loads(ilj), indent=2, sort_keys=True))

ila=ak.from_json(ilj)

#add raw seqname to struct
counts=ak.num(ila.Isolates)
Seqname=[str(s).replace('Maccabi_Ecoli_SeqPlate','').replace('Sample_','') for s in ak.flatten(ila.Isolates.SeqSubDirName)]
Seqname=ak.unflatten(Seqname, counts)
ila['Isolates']=ak.with_field(ila.Isolates, Seqname, where="Seqname")


# %%
# process same-strain into json and then awkwardarray
#sd = (same_strain_list.groupby(['RandomID']).aggregate(list)).to_dict()
ssj = (same_strain_list.groupby('RandomID')['Seqplates']
             .apply(list)
             .reset_index()
             .rename(columns={0:'Isolates'})
             .to_json(orient='records'))

#print(json.dumps(json.loads(ssj), indent=2, sort_keys=True))
ssa=ak.from_json(ssj)


# %%
# merge two arrays in outer join
dictionary, index = np.unique(np.asarray(ssa.RandomID), return_index=True)
closest = np.searchsorted(dictionary, np.asarray(ila.RandomID), side="left")
is_within_range = ak.Array(closest).mask[closest < len(dictionary)]
is_good_match = ak.Array(dictionary)[is_within_range] == ila.RandomID
reordering = ak.Array(closest).mask[is_good_match]
ila["Seqplates"] = ssa.Seqplates[index][reordering]


# %%
# Add same-strain using cartesian product
cart=ak.cartesian([ila.Isolates.Seqname, ila.Seqplates], nested=True)
is_ss=ak.any(cart.slot0==cart.slot1, axis=-1)
is_ss=ak.fill_none(is_ss, False)
ila['Isolates']=ak.with_field(ila.Isolates, is_ss, where="IsSameStrain")

# %% [markdown]
# ## Task #2: import pangenome coverage data
# The absolute necessaries:
#  - gene names (from roary)
#  - gene functions, scaffolds (from prokka)
#  - gene coverages (from coverage)
#  - BRESEQ
#  
# All else can wait!
# ### Work plan
#  Load into pangenomes structs and then merge them with dataset at very end

# %%
# get all gene_presence_absence files

import pyarrow as pa
import os
datadir=os.getcwd()+"/PycharmProjects/mge-project/data/"

dirnames=np.char.add(np.asarray(datadir+"/pangenome/", dtype=str),np.asarray(ila.NewRandomID,dtype=str))
isdir=[os.path.isdir(dn) for dn in dirnames]

#get pandas table
def get_pangenome_data(RID):
    if RID is None:
         return np.asarray(None)
    roary_pd=pd.read_csv(datadir+"/pangenome/"+str(RID)+'/gene_presence_absence.csv', error_bad_lines=False)
    roary_pa=pa.Table.from_pandas(roary_pd)
    roary_ak=ak.from_arrow(roary_pa)
    return roary_ak

roary_data=ak.concatenate([get_pangenome_data(rid) for rid in ila.mask[isdir].NewRandomID])
ila["Pangenome"]=roary_data
ak.to_parquet(ila, datadir+"/datastruct/up_to_pangenome.parquet")


# %%



# %%



