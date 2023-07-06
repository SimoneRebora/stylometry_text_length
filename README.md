# stylometry_text_length

Scripts and corpora for the paper: "Short texts with fewer authors. Revisiting the boundaries of stylometry", presented at [DH2023](https://dh2023.adho.org/) ([Paper](https://zenodo.org/record/7961822) | [Slides](https://docs.google.com/presentation/d/1M7L5h-5-DYO1aiJEa6gt_SKBvN3KWpeml4jiGFZFijE/edit?usp=sharing))

## Structure

### Scripts

Analysis is performed by the **bash_text_length_parallel.sh** script, which calls the three R scripts and allows for parallelization of the process (up to 7 cores).  
- **01_evaluate_parallel_processing.R** reads analysis features from the *analysis_features.csv* file and prepares instructions for parallel processing
- **02_text_length_analysis** performs the analysis in parallel
- **03_conflate_results.R** conflates the results and saves them to a single file

### Analysis Features

Analysis features are defined in the *analysis_features.csv* file. You can modify them to run different analyses:
- **my_folder** defines the folder containing the corpus to be processed (corpus files should have extension .txt, file naming should follow the Stylo convention: see available corpora for example)
- **my_language** defines the language of the corpus 
- **n_authors** defines the numbers of authors on which to run the analysis (you should separate the numbers with a space) 
- **text dimensions** defines the dimensions of texts on which to run the analysis (you should separate the numbers with a space) 
- **random_selection** defines if texts are randomized (logical) 
- **MFW_series** defines the number(s) of most frequent units (words or characters) on which to run tests (you should separate the numbers with a space)
- **n_grams** defines if analysis is based on character n_grams (T) or words (F)
- **ngram_size** defines the dimensions of character n-grams on which to run the analysis (you should separate the numbers with a space)
- **distances** defines the stylometric distances to be used (you should separate the names with a space)
- **n_repetitions** defines the number of repetitions for each configuration
- **n_cores** defines the number of cores for parallel processing (the script currently supports from two to six cores)

### Available Corpora

The folders *100_english_novels, 68_german_novels, ELTeC-fra, and ELTeC-ita* contain the working corpora:  
- Ciotti, F., Schöch, C. and Burnard, L. (2022). ELTeC-ita European Literary Text Collection (ELTeC) https://github.com/COST-ELTeC/ELTeC-ita (accessed 31 October 2022).
- Computational Stylistics Group (2022a). 100 English Novels ver. 1.4 https://github.com/computationalstylistics/100_english_novels (accessed 31 October 2022).
- Computational Stylistics Group (2022b). 68 German Novels https://github.com/computationalstylistics/68_german_novels (accessed 31 October 2022).
- Schöch, C. and Burnard, L. (2021). French Novel Corpus (ELTeC-fra): April 2021 release Zenodo doi:10.5281/ZENODO.4662433. https://zenodo.org/record/4662433 (accessed 31 October 2022).

### Results

The *results_overview.csv* file contains an overview of the results obtained so far.  
The folder *Results* is prepared to contain further results.

## Instructions

Call the script via: `bash bash_text_length_parallel.sh analysis_features.csv`  

## Requirements

Required R libraries:
- tidyverse (1.3.2)
- stylo (0.7.4)
- stringr (1.4.1)
 
The bash script should run via command line on Unix-like systems.
