### imposters_testing

library(tidyverse)
library(stylo)

my_files <- list.files(pattern = "temporary_results_par_")
my_files <- my_files[which(grepl(pattern = ".RData", x = my_files))]

final_results <- data.frame()

for(my_file in my_files){
  
  load(my_file)
  
  final_results <- rbind(final_results, methods_combination)
  
}
 
my_time <- gsub("\\W", "-", Sys.time())
filename <- paste("Final_results__date", my_time, ".csv", sep = "")
final_results <- final_results[order(as.numeric(rownames(final_results))),]
write.csv(final_results, file = filename)
save.image(gsub(pattern = ".csv", replacement = ".RData", x = filename))

unlink("temporary_results_par_*")
unlink("progress_par_*")

print("Parallel processing complete!")