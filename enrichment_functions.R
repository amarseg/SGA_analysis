load_go <- function(){
  require(AnnotationDbi)
  require(GO.db)
  
  go_data <- read_delim('ftp://ftp.pombase.org/pombe/annotations/Gene_ontology/gene_association.pombase.gz',
                        skip = 44, delim = '\t', col_names = F)
  term2gene <- go_data[,c(5,2)]
  
  term2name <- AnnotationDbi::select(GO.db, keys = keys(GO.db), columns = c('GOID','TERM'))
  
  go_database <- list(term2gene = term2gene, term2name = term2name)
  return(go_database)
}

load_gene_lists <- function(){
  rna_up <- read_tsv('C:/Users/am4613/OneDrive - Imperial College London/ondedriveBACK/gene_list_analysis/listas/up_rna.tsv')
  rna_down <- read_tsv('C:/Users/am4613/OneDrive - Imperial College London/ondedriveBACK/gene_list_analysis/listas/down_rna.tsv')
  prot_up <- read_tsv('C:/Users/am4613/OneDrive - Imperial College London/ondedriveBACK/gene_list_analysis/listas/up_prot.tsv')
  prot_down <- read_tsv('C:/Users/am4613/OneDrive - Imperial College London/ondedriveBACK/gene_list_analysis/listas/down_prot.tsv')
  
  gene_lists <-
    list(rna_up = rna_up, rna_down = rna_down, prot_up = prot_up, prot_down = prot_down) %>% bind_rows(.id = 'id')
  return(gene_lists)
}

plot_transcriptomics_proteomics <- function(id_list, what = 'RNA')
{
  require(tidyverse)
  source('C:/Users/am4613/Documents/GitHub/Proteomics/normalise_script.R')
  require(pheatmap)
  
  data <- read.delim('data/SQ_Results_PROTEIN.tsv', header = T, strings = F)
  norm_data <- normalise_ProtDataset(data, what = 'nada')
  norm_data <- rownames_to_column(norm_data)
  norm_data <- norm_data[,c(1,8:43)]
  
  rna <- read.delim('data/DESeq_norm_counts.txt', header = T, strings = F)
  rna <- rownames_to_column(rna)
  joint <- inner_join(norm_data, rna, by = 'rowname')
  
  if(what == 'RNA'){
    todo <- rna
  }else if(what == 'protein'){
    todo <- norm_data
  }else if(what == 'both'){
    todo <- joint
  }
  
  
  subset_todo <- filter(todo, rowname %in% id_list)
  pheatmap(select(subset_todo, -rowname), cluster_cols = F)
    
}



normalise_and_reorder <- function(data){
  

}