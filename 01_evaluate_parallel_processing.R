# evaluate_parallel_processing

features_file <- commandArgs(trailingOnly=TRUE)

all_features <- read.csv(features_file, stringsAsFactors = F)

n_cores <- as.numeric(all_features$value[all_features$feature == "n_cores"])
text_dimensions <- as.numeric(unlist(strsplit(all_features$value[all_features$feature == "text_dimensions"], " ")))
MFW_series <- as.numeric(unlist(strsplit(all_features$value[all_features$feature == "MFW_series"], " ")))
my_folder <- unlist(strsplit(all_features$value[all_features$feature == "my_folder"], " "))
my_language <- unlist(strsplit(all_features$value[all_features$feature == "my_language"], " "))
repetitions <- 1:as.numeric(all_features$value[all_features$feature == "n_repetitions"])
distances <- unlist(strsplit(all_features$value[all_features$feature == "distances"], " "))
n_authors <- as.numeric(unlist(strsplit(all_features$value[all_features$feature == "n_authors"], " ")))
random_selection <- as.logical(all_features$value[all_features$feature == "random_selection"])
n_grams <- as.logical(all_features$value[all_features$feature == "n_grams"])
ngram_size <- as.numeric(unlist(strsplit(all_features$value[all_features$feature == "ngram_size"], " ")))

methods_combination <- expand.grid(my_folder, my_language, random_selection, text_dimensions, n_authors, MFW_series, n_grams, ngram_size, distances, repetitions, stringsAsFactors = FALSE)

colnames(methods_combination) <- c("my_folder", "my_language", "random_selection", "text_dimensions", "n_authors", "MFW", "n_grams", "ngram_size", "distance", "repetition")

methods_combination <- methods_combination[sample(1:length(methods_combination$my_folder)),]

write.csv(methods_combination, "Methods_combination_parallel.csv")
cat(n_cores, file = "n_cores.txt")

x <- 1:length(methods_combination$my_folder)
start_end <- split(x, sort(x%%n_cores))
start_end <- sapply(start_end, function(x) paste(x[1],x[length(x)]))

cat(start_end, sep = "\n", file = "parallel_processing_instructions.txt")

