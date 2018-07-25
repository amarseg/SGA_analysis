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