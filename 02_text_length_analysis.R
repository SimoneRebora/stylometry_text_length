# imposters_analysis

library(stylo)
library(stringr)
library(tidyverse)

# Variables

methods_combination <- read.csv("Methods_combination_parallel.csv", stringsAsFactors = F, row.names = 1)

args <- commandArgs(trailingOnly=TRUE)
args_split <- unlist(strsplit(args, " "))

start_loop <- as.numeric(args_split[1])
end_loop <- as.numeric(args_split[2])

cat("Performing analysis between", start_loop, end_loop, "\n")

# Functions

# new minmax function
dist.minmaxfast = function(x){
  
  # test if the input dataset is acceptable
  if(is.matrix(x) == FALSE & is.data.frame(x) == FALSE) {
    stop("cannot apply a distance measure: wrong data format!")
  }
  # then, test whether the number of rows and cols is >1
  if(length(x[1,]) < 2 | length(x[,1]) < 2) {
    stop("at least 2 cols and 2 rows are needed to compute a distance!")
  }
  
  # getting the size of the input table
  rows = length(x[,1])
  # starting a new matrix
  y = matrix(nrow = rows, ncol = rows)
  rownames(y) = rownames(x)
  colnames(y) = rownames(x)
  # iterating over rows and columns
  for(i in 1:rows) {
    for(j in i:rows ) {
      y[j,i] = 1 - sum(pmin(x[i,], x[j,])) / sum(pmax(x[i,], x[j,]))
    }
  }
  
  # converting the matrix to the class 'dist'
  y = as.dist(y)
  
  return(y)
}


# Start main loop

results_filename <- paste("temporary_results_par_", str_pad(start_loop, 8, pad = "0"), ".RData", sep = "")
log_filename <- paste("progress_par_", str_pad(start_loop, 8, pad = "0"), ".log", sep = "")

methods_combination$attribution_quality <- NA

for(method in start_loop:end_loop){
  
  # read texts from files
  my_folder <- methods_combination$my_folder[method]
  my_language <- methods_combination$my_language[method]
  random_selection <- as.logical(methods_combination$random_selection[method])
  n_grams <- as.logical(methods_combination$n_grams[method])

  my_files <- list.files(my_folder, full.names = T)
  
  my_authors_full <- list.files(my_folder)
  
  my_authors_full <- strsplit(my_authors_full, "_")
  my_authors_full <- sapply(my_authors_full, function(x) x[1])
  
  my_authors <- table(my_authors_full)
  my_authors <- my_authors[my_authors > 1]
  
  my_authors <- names(my_authors)
  
  # select authors
  selected_authors <- sample(my_authors, methods_combination$n_authors[method], replace = F)
  
  filenames_tmp <- my_files[which(my_authors_full %in% selected_authors)]
  
  # read texts
  corpus_tmp <- lapply(filenames_tmp, readLines)
  
  corpus_tmp <- lapply(corpus_tmp, function(x) txt.to.words.ext(x, corpus.lang = my_language))
  
  # sample texts
  if(random_selection){
    
    corpus_tmp <- lapply(corpus_tmp, function(x) sample(x, methods_combination$text_dimensions[method], replace = F))
    
  }else{
    
    corpus_tmp_ids <- sapply(corpus_tmp, function(x) sample(1:(length(x)-methods_combination$text_dimensions[method]), 1, replace = F))
    corpus_tmp_ids <- lapply(corpus_tmp_ids, function(x) c(x, x+(methods_combination$text_dimensions[method]-1)))
    
    for(i in 1:length(corpus_tmp_ids)){
      
      corpus_tmp[[i]] <- corpus_tmp[[i]][corpus_tmp_ids[[i]][1]:corpus_tmp_ids[[i]][2]]
      
    }
    
  }
  
  # n-grams creation (note: makes sense only with non-random word selection)
  if(n_grams){
    
    my_ngram_size <- methods_combination$ngram_size[method]
    corpus_tmp_ngrams <- unlist(lapply(corpus_tmp, function(x) paste(x, collapse = " ")))
    corpus_tmp_ngrams <- strsplit(corpus_tmp_ngrams, "")
    corpus_tmp_ngrams <- lapply(corpus_tmp_ngrams, function(x) make.ngrams(x, my_ngram_size))
    corpus_tmp <- corpus_tmp_ngrams
    
  }
  
  names(corpus_tmp) <- my_authors_full[which(my_authors_full %in% selected_authors)]
  
  # run stylo analysis
  stylo_result <- stylo(gui = F, 
                        parsed.corpus = corpus_tmp,
                        mfw.min = methods_combination$MFW[method],
                        mfw.max = methods_combination$MFW[method],
                        mfw.incr = 0,
                        analysis.type = "CA",
                        distance.measure = methods_combination$distance[method],
                        write.png.file = F,
                        write.pdf.file = F)
  
  # calculate quality
  distances_table <- stylo_result$distance.table
  
  attribution_quality <- rep(0, ncol(distances_table))
  
  for(i in 1:ncol(distances_table)){
    
    my_author <- colnames(distances_table)[i]
    distances_table_tmp <- distances_table[-i,i]
    
    distances_table_tmp <- data.frame(name = names(distances_table_tmp), distance = as.vector(distances_table_tmp))
    
    distances_mean <- distances_table_tmp %>%
      group_by(name) %>%
      summarize(distance = mean(distance))
    
    attribution <- distances_mean$name[which.min(distances_mean$distance)]
    
    if(attribution == my_author)
      attribution_quality[i] <- 1
    
  }
  
  attribution_quality <- mean(attribution_quality)
  
  methods_combination$attribution_quality[method] <- attribution_quality
  
  if(method %% 10 == 0){
    
    cat("progress:", (method-start_loop+1)/(end_loop-start_loop+1), "\n", file = log_filename)
    unlink("*EDGES.csv")
    
  }
  
}

methods_combination <- methods_combination[(start_loop:end_loop),]

unlink("*EDGES.csv")
save.image(results_filename)

print("Process complete!")