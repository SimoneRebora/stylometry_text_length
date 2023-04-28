#!/usr/bin/bash

# Step 1. Prepare instructions for parallel processing based on analysis features
Rscript 01_evaluate_parallel_processing.R $1

# save instructions in array
declare -a array=()
i=0

while IFS= read -r line; do
    array[i]=$line
    let "i++"
done < "parallel_processing_instructions.txt"

# Step 2. Perform analysis by splitting it into multiple parallel processes
n_cores=$(<n_cores.txt)

if [[ "$n_cores" == 2 ]]; then
Rscript 02_text_length_analysis.R "${array[0]}" &
Rscript 02_text_length_analysis.R "${array[1]}" &
wait
fi

if [[ "$n_cores" == 3 ]]; then
Rscript 02_text_length_analysis.R "${array[0]}" &
Rscript 02_text_length_analysis.R "${array[1]}" &
Rscript 02_text_length_analysis.R "${array[2]}" &
wait
fi

if [[ "$n_cores" == 4 ]]; then
Rscript 02_text_length_analysis.R "${array[0]}" &
Rscript 02_text_length_analysis.R "${array[1]}" &
Rscript 02_text_length_analysis.R "${array[2]}" &
Rscript 02_text_length_analysis.R "${array[3]}" &
wait
fi

if [[ "$n_cores" == 5 ]]; then
Rscript 02_text_length_analysis.R "${array[0]}" &
Rscript 02_text_length_analysis.R "${array[1]}" &
Rscript 02_text_length_analysis.R "${array[2]}" &
Rscript 02_text_length_analysis.R "${array[3]}" &
Rscript 02_text_length_analysis.R "${array[4]}" &
wait
fi

if [[ "$n_cores" == 6 ]]; then
Rscript 02_text_length_analysis.R "${array[0]}" &
Rscript 02_text_length_analysis.R "${array[1]}" &
Rscript 02_text_length_analysis.R "${array[2]}" &
Rscript 02_text_length_analysis.R "${array[3]}" &
Rscript 02_text_length_analysis.R "${array[4]}" &
Rscript 02_text_length_analysis.R "${array[5]}" &
wait
fi

if [[ "$n_cores" == 7 ]]; then
Rscript 02_text_length_analysis.R "${array[0]}" &
Rscript 02_text_length_analysis.R "${array[1]}" &
Rscript 02_text_length_analysis.R "${array[2]}" &
Rscript 02_text_length_analysis.R "${array[3]}" &
Rscript 02_text_length_analysis.R "${array[4]}" &
Rscript 02_text_length_analysis.R "${array[5]}" &
Rscript 02_text_length_analysis.R "${array[6]}" &
wait
fi

# Step 3. Conflate results into a single table
Rscript 03_conflate_results.R

echo "Process complete!"