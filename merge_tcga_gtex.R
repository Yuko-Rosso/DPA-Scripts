library(readr)
library(tibble)
library(dplyr)

base_dir <- "2024/BMed BSc Hons/Research Project/"
setwd(base_dir)

file_path <- "GTEX/gene_reads_colon_sigmoid.gct"

gtc_data_sigmoid <- read_tsv(file_path, skip = 2) |>
  mutate(Ensembl_ID = Name) |>
  select(-id, -Description, -Name) |>
  column_to_rownames(var="Ensembl_ID")

#head(gtc_data_sigmoid)



#Cluster X
df <- read_csv("output/Cluster_3_EG.csv") 

samples <- names(df) [-1]
samples <- gsub("\\.", "-", samples)

#Xena colon cancer data
df <- read_tsv("output/TCGA-COAD.htseq_counts.tsv") |>
  select("Ensembl_ID", samples) |>
  column_to_rownames(var = "Ensembl_ID")

#Covert log values

df <- 2^df -1 

# Merge the two data frames by their common gene identifier columns
df <- merge(df, gtc_data_sigmoid, by = 'row.names', all = FALSE) |>
  dplyr::rename(Ensembl_ID = Row.names)

write.table(df, file="output/merge_tcga_gtex.tsv", sep = "\t", row.names = FALSE, quote = FALSE)

#SECOND SCRIPT




