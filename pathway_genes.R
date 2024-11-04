library(msigdb)
library(ExperimentHub)
library(GSEABase)

base_dir <- "2024/BMed BSc Hons/Research Project/"
setwd(base_dir)

eh = ExperimentHub()
query(eh, 'msigdb')
#eh[['EH7359']]
mdb <- getMsigdb(org = 'hs', id = 'EZID', version = '7.5')
mdb <- appendKEGG(mdb)
#subset collection c2
listCollections(mdb)
listSubCollections(mdb)
#subcol <- c('CP:BIOCARTA','CP:KEGG','CP:REACTOME','CP:PID','CP')
subcol <- c('CP:KEGG')
c2 <- subsetCollection(mdb, collection='c2') |>
  subsetCollection(subcollection = subcol)

length(names(c2))

gsList <- GSEABase::geneIds(c2)

#FROM PANOMIR
pathList <- lapply(gsList, function(x) {
  clusterProfiler::bitr(x, fromType = "ENTREZID", toType = "ENSEMBL",
                        OrgDb = org.Hs.eg.db::org.Hs.eg.db)
}
)

temp <- lapply(names(pathList), function(x) {
  data.frame(
    Pathway = (x),
    pathList[[x]]
  )
}
)

temp <- do.call(rbind, (temp))
pathExpTab <- tibble::as_tibble(temp)
dim(pathExpTab)
write.csv(pathExpTab, "output/path_gene.csv", row.names = FALSE)

#FIRST SCRIPT
