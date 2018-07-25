#Extract hits from SGA data analysed using John's software
library('tidyverse')
library('clusterProfiler')
source('enrichment_functions.R')

data <- 
  read_csv('data/150618_SGA/SGAdata.csv') %>%
  filter(is.na(cdc2_Interaction.Warning.Flags))

p <- ggplot(data,aes(cdc2_Interaction.Value))
p + geom_histogram(bins = 50, aes(y = ..density..), color = 'black', fill = 'white') + 
  geom_density(alpha = 0.2, fill="#FF6666")

interaction_cutoff <- 0.05

sig_data <- filter(data, abs(cdc2_Interaction.Value) > interaction_cutoff)

kegg_enrich <-enrichKEGG(sig_data$Systematic.Name, organism = 'spo')

go_db<-load_go()
go_enrich <- enricher(sig_data$Systematic.Name, TERM2GENE = go_db$term2gene, TERM2NAME = go_db$term2name)
dotplot(go_enrich)
write_csv(as.tibble(go_enrich),path = 'data/enrichment_GO.csv')


