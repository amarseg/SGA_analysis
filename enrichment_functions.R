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