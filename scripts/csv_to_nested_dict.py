import awkward as ak
import pandas as pd
from collections import defaultdict 

isolates_list=pd.read_excel("/home/kishonystud/kishonyserver/noga/PycharmProjects/mge-project/workflow/config/isolates_list_Maccabi_E.coli_UTI_SeqPlates1to25.xlsx",engine="openpyxl")
isolates_list=isolates_list \
    .dropna(axis=1,how="all") \
    .dropna(axis=0,how="all") \
   .convert_dtypes(convert_floating=False)

d=isolates_list.groupby('NewRandomID').apply(lambda x: x.set_index('IsoNum').to_dict(orient='index')).to_dict()
print(d)