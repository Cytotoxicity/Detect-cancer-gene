import pandas as pd
import numpy as np
from sklearn.cluster import DBSCAN

rna = r.rna
rna.drop('pro', inplace = True, axis = 1)
rna['cancer'] = np.log10(rna['cancer'])
rna['normal'] = np.log10(rna['normal'])
rna

rna = rna[(rna['cancer'] >= -8) & (rna['normal'] >=-8)]
rna.reset_index(inplace = True, drop = True)

feature = rna[['normal', 'cancer']]
feature

model =  DBSCAN(eps=0.5, min_samples=10)
predict=pd.DataFrame(model.fit_predict(feature))
predict.columns=['predict']

predict['predict'].value_counts()

cancer_gene_DBSCAN = list(rna[predict['predict'] == -1]['gene'])
