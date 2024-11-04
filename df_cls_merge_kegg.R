library(readr)
library(dplyr)
library(tibble)

base_dir <- "2024/BMed BSc Hons/Research Project/"
setwd(base_dir)
      
pg <- read_csv(file = "output/path_gene.csv") |>
  select(ENSEMBL, Pathway)

gx <- read_csv(file = "output/df_cls.csv") 


#df_cls_filtered <- df_cls %>%
  #filter(rowSums(select(., -ENSEMBL) >= 100) > 0)

df <- merge(pg, gx, by = "ENSEMBL", all = FALSE) |>
  arrange(Pathway)

#ds <- pg |>
 # inner_join(gx, by = "ENSEMBL") |> 
 # arrange(Pathway)

df <- df |>
  group_by(Pathway) |>
  filter(n_distinct(ENSEMBL) >= 10) |>
  ungroup()

length(unique(df$Pathway))

df_r <- df |>
  mutate_if(is.numeric, rank)

#df_r <- df |>
 # mutate_if(is.numeric, ~rank(-., ties.method = "first")) #Descending order

df_m <- df_r |>
  group_by(Pathway) |>  
  summarise(across(where(is.numeric),\(x) mean(x, na.rm = TRUE))) 

write.csv(df_m, "output/aggregated_pathways.csv", row.names = FALSE)

#FOURTH SCRIPT