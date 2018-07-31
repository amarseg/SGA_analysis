##Creates tidy dataset with my data (it's about time)
library(tidyverse)

data <- read.delim('data/SQ_Results_PROTEIN.tsv', header = T, strings = F)
norm_data <- normalise_ProtDataset(data, what = 'nada')
norm_data <- rownames_to_column(norm_data)
norm_data <- norm_data[,c(1,8:43)]
######Process sample names so everything is nice#####
sample_prot <- 
  colnames(norm_data) %>%
  str_replace(pattern = 'b018p004AM', replacement = 'Protein') %>%
  str_replace(pattern = 'T', replacement = '') %>%
  str_replace(pattern = 'G', replacement = '')
colnames(norm_data) <- sample_prot

rna <- read.delim('data/DESeq_norm_counts.txt', header = T, strings = F)
rna <- rownames_to_column(rna)
#########Process RNA names#################
sample_rna <- 
  colnames(rna) %>%
  str_replace(pattern = 'rev', replacement = 'RNA') %>%
  str_replace(pattern = 'tp', replacement = '') %>%
  str_replace(pattern = 'sho', replacement = '') %>% 
  str_replace(pattern = '.bam', replacement = '')

colnames(rna) <- sample_rna
######Join two datasets################
all_data <- 
  left_join(rna, norm_data, by = 'rowname') %>%
  gather(key = 'rowname') %>%
  separate(rowname, into = c('Type','Time','Replicate'), sep = '_', fill = 'right') 

all_data[is.na(all_data$Replicate),] <- 1

write_csv(all_data, 'tidy_omics.csv')


  
  