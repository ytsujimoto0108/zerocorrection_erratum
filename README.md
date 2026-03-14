# zerocorrection_erratum

## Background and Purpose of this Repository
This repository contains the data and analytical scripts for an **Erratum** to the article:
> Tsujimoto Y, Tsutsumi Y, Kataoka Y, Shiroshita A, Efthimiou O, Furukawa TA. "The impact of continuity correction methods in Cochrane reviews with single-zero trials with rare events: A meta-epidemiological study" (*Research Synthesis Methods* - 2024).

During the original data collection process, a random technical error occurred during the data downloading phase, which inadvertently resulted in only a portion of the eligible data being downloaded and analyzed (n=885 meta-analyses). 

To correct this, we have fully re-extracted the complete dataset. This repository serves to transparently share the updated, complete dataset (expanded to n=2,783 meta-analyses) and the R reproducible code used to recalculate the findings for the official Erratum. Importantly, the main conclusions of the original study strongly hold with the complete data.

## What the R Script Does (`r_command_revise2026.R`)
The core R script is designed to strictly follow the original data cleaning and methodological steps on the expanded dataset. Specifically, it:
1. **Data Cleaning & Preparation**: Loads the complete dataset, accurately handles non-convergent statistical models, and recalculates log-transformed effect estimates (Log-TE) and the log Ratio of Odds Ratios (Log-ROR) across multiple statistical methods (Mantel-Haenszel with fixed correction, REIV, Peto, Logistic regression, etc.).
2. **Table 1 Generation**: Summarizes the overall characteristics of the 2,783 meta-analyses (number of studies, participants, events, and statistical methods used). 
3. **Table 2 Generation**: Categorizes the meta-analyses by the magnitude of Log-RORs ("Small", "Moderate", "Large") between the RevMan MH model and tracking the descriptive statistics, and dynamically counts convergence missing values for a detailed footnote.
4. **Figure 2 Generation**: Creates a comprehensive 7x7 analytical grid—combining scatter plots (comparing method vs. method) in the upper triangle and Log-ROR probability distribution histograms in the lower triangle, closely matching the original paper's formatting.

## Tracked Files in this Repository
Based on the `.gitignore` settings, the following specific files are tracked and shared in this repository:

*   **`README.md`**: This document explaining the repository context.
*   **`.gitignore`**: The Git configuration file specifying which temporary or draft files to exclude.
*   **`data_final_revise2025.csv`**: The complete, re-downloaded raw dataset (n=2,783) forming the new basis of the erratum analysis.
*   **`r_command_revise2026.R`**: The fully integrated, reproducible analytical R script described above.
*   **`table1_20260314.md`**: The newly generated, corrected Table 1 in markdown format.
*   **`table2_20260314.md`**: The newly generated, corrected Table 2 (with comprehensive footnotes) in markdown format.
*   **`figure2_20260314.svg`**: The newly generated, corrected Figure 2 (7x7 matrix) in a high-resolution vector format.
