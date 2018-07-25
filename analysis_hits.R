#Extract hits from SGA data analysed using John's software
library('tidyverse')
library('clusterProfiler')
source('enrichment_functions.R')
library('ggrepel')

data <- 
  read_csv('data/150618_SGA/SGAdata.csv') %>%
  filter(is.na(cdc2_Interaction.Warning.Flags))

p <- ggplot(data,aes(cdc2_Interaction.Value))
p + geom_histogram(bins = 50, aes(y = ..density..), color = 'black', fill = 'white') + 
  geom_density(alpha = 0.2, fill="#FF6666")

####Select interactors####

interaction_cutoff <- 0.05

sig_data <- filter(data, abs(cdc2_Interaction.Value) > interaction_cutoff)

####enrichment######
kegg_enrich <-enrichKEGG(sig_data$Systematic.Name, organism = 'spo')

go_db<-load_go()
go_enrich <- enricher(sig_data$Systematic.Name, TERM2GENE = go_db$term2gene, TERM2NAME = go_db$term2name)
dotplot(go_enrich)
write_csv(as.tibble(go_enrich),path = 'data/enrichment_GO.csv')

#########Take gene lists from time course and compare#####
gene_lists<-load_gene_lists()
annot_data <- inner_join(data, gene_lists, by = c('Systematic.Name' = 'Systematic ID'))

detach(package:ggbiplot)
detach(package:plyr)
avg_change <- 
  annot_data %>%
  group_by(id) %>%
  summarise(avg_interaction = mean(cdc2_Interaction.Value), sd_interaction = sd(cdc2_Interaction.Value))

p <- ggplot(avg_change, aes(y = avg_interaction, x = id))
p+geom_bar(stat = 'identity') + geom_errorbar(aes(ymin=avg_interaction-sd_interaction, ymax=avg_interaction+sd_interaction), width=.2)


p <- ggplot(annot_data, aes(y = cdc2_Interaction.Value, x = id, fill = id))
p + geom_violin()


annot_sig <- inner_join(sig_data, gene_lists, by = c('Systematic.Name' = 'Systematic ID'))
p <- ggplot(annot_sig, aes(y = cdc2_Interaction.Value, x = id, fill = id, label = Name))
p + geom_point() + geom_label_repel()


###Let's do ups and downs
up_data <- filter(data, cdc2_Interaction.Value > interaction_cutoff)
down_data <- filter(data, cdc2_Interaction.Value < -interaction_cutoff)

cl <- compareCluster(list(up = up_data$Systematic.Name, down = down_data$Systematic.Name), fun = 'enricher', TERM2GENE = go_db$term2gene, TERM2NAME = go_db$term2name)
dotplot(cl)
write_csv(as.data.frame(cl), path = 'data/up_down_enrichment.csv')
