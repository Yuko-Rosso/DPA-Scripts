#Extract 15 random GTEx samples
library(dplyr)
library(readr)
library(tibble)

base_dir <- "2024/BMed BSc Hons/Research Project/"
setwd(base_dir)

df <- read_tsv("output/merge_tcga_gtex.tsv") |>
  column_to_rownames(var="Ensembl_ID")

set.seed(321)
cls_gtex <- grep("^GTEX", names(df), value = TRUE) |>
  sample(size =16)

#set.seed(321)
cls_xena <- grep("^TCGA", names(df), value = TRUE) 
 # sample(size =10)

cls <- c(cls_xena, cls_gtex)

df_cls <- df |>
  select(all_of(cls)) 
  
rownames(df_cls) <- sub("\\..*", "", rownames(df_cls))

head(df_cls)

df_cls <- df_cls |> 
  rownames_to_column(var= "ENSEMBL")

write.csv(df_cls, "output/df_cls.csv", row.names = FALSE)

#THIRD SCRIPT