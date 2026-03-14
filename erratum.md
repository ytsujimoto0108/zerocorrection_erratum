# Erratum

In the article titled “The impact of continuity correction methods in Cochrane reviews with single-zero trials with rare events: A meta-epidemiological study,” published online on June 9, 2024, in *Research Synthesis Methods*, a portion of the eligible data was inadvertently omitted from the original analyses due to a random technical error during the data downloading process. All analyses were recalculated after adding the omitted data, increasing the number of included meta-analyses from 885 to 2783. 

Importantly, the findings and the study's overall conclusions were not significantly affected. The central finding—that evaluating single-zero studies with the Mantel-Haenszel (MH) model with a fixed continuity correction yields results substantially different from those produced by the MH model without correction or by logistic regression models—remains robust. In the corrected analysis, a large difference in the point estimates (ratio of odds ratios [ROR] $\ge$ 1.25 or $\le$ 0.8) was observed in 36% (vs. 27% in the original) and 32% (vs. 32% in the original) of existing meta-analyses when comparing results between RevMan MH and either MH without correction or logistic regression, respectively. 

The characteristics of the included meta-analyses and the detailed size distribution of RORs have been updated (corrected Table 1 and Table 2, respectively). Additionally, data from the newly included reviews were added to Figure 2 to reflect the updated agreement in effect estimates obtained across all statistical methods. The updated complete dataset and the R scripts used for all recalculations are publicly available in the GitHub repository (https://github.com/ytsujimoto0108/zerocorrection_erratum). None of the study’s conclusions were altered by these changes. This article was corrected online.


---

### Enclosures to the Erratum:

#### Updated Table 1: Overall Characteristics of the included meta-analyses
| Characteristic | N = 2,783 |
| :--- | :--- |
| **Number of included studies** | 3.00 (2.00, 4.00) |
| **Number of participants** | 403 (237, 653) |
| **Number of events** | 9 (5, 18) |
| **Statistical methods used in the Cochrane reviews** | |
| Fixed IV method with a fixed correction | 27 (1.0%) |
| RevMan MH model* | 1,686 (61%) |
| Peto | 10 (0.4%) |
| REIV | 1,060 (38%) |

*Note: Values in parentheses show percentages or interquartile range. *The Mantel-Haenszel model with a fixed continuity correction, adding 0.5 to all cells of the 2x2 table, implemented in the RevMan software. Abbreviations: MH, Mantel-Haenszel; REIV, random effects inverse variance method with a fixed correction.*

#### Updated Table 2: Characteristics of the included meta-analyses categorized according to the ratio of odds ratios for each method versus RevMan Mantel-Haenszel model*

|Characteristics               |Small          |Moderate       |Large          |
|:-----------------------------|:--------------|:--------------|:--------------|
|Methods                       |               |               |               |
|REIV                          |2120 (76%)     |439 (16%)      |224 (8%)       |
|REIV TACC                     |1973 (71%)     |529 (19%)      |281 (10%)      |
|Peto                          |1534 (55%)     |533 (19%)      |715 (26%)      |
|MH (no correction)            |1222 (46%)     |500 (19%)      |955 (36%)      |
|Logistic regression           |1061 (45%)     |554 (23%)      |745 (32%)      |
|Bayesian model                |429 (15%)      |511 (18%)      |1843 (66%)     |
|Median number of studies      |               |               |               |
|REIV                          |2 (2, 4)       |3 (2, 4)       |3 (2, 3)       |
|REIV TACC                     |3 (2, 4)       |3 (2, 4)       |2 (2, 3)       |
|Peto                          |3 (2, 4)       |2 (2, 3)       |2 (2, 3)       |
|MH (no correction)            |3 (2, 4)       |3 (2, 4)       |2 (2, 3)       |
|Logistic regression           |3 (2, 4)       |3 (2, 4)       |3 (2, 4)       |
|Bayesian model                |3 (3, 5)       |3 (2, 4)       |2 (2, 3)       |
|Median number of participants |               |               |               |
|REIV                          |400 (232, 634) |417 (247, 665) |432 (252, 670) |
|REIV TACC                     |408 (233, 645) |396 (247, 662) |402 (240, 661) |
|Peto                          |454 (286, 690) |349 (206, 613) |335 (178, 552) |
|MH (no correction)            |490 (312, 707) |404 (250, 664) |308 (164, 526) |
|Logistic regression           |489 (302, 706) |406 (241, 662) |378 (225, 607) |
|Bayesian model                |539 (331, 786) |492 (306, 696) |351 (205, 574) |
|Median number of events       |               |               |               |
|REIV                          |8 (4, 16)      |11 (6, 21)     |18 (11, 31)    |
|REIV TACC                     |9 (5, 17)      |10 (5, 19)     |15 (7, 27)     |
|Peto                          |11 (7, 20)     |7 (4, 13)      |5 (3, 18)      |
|MH (no correction)            |13 (7, 23)     |10 (6, 17)     |6 (4, 13)      |
|Logistic regression           |13 (7, 23)     |9 (5, 16)      |8 (5, 17)      |
|Bayesian model                |14 (7, 23)     |12 (7, 22)     |8 (4, 16)      |

*Note: Values in parentheses shows percentage or interquartile range. Percentage calculations were based on a denominator that excluded 529 missing values resulting from non-convergence for the MH and logistic regression models.
\*The Mantel-Haenszel model with a fixed continuity correction, adding 0.5 to all cells of the 2x2 table, which is the model implemented in the RevMan software.
†Small, ROR in the range of 0.9 to 1.11; Moderate, ROR in the range of 0.8 to 0.9 or 1.11 to 1.25; Large, ROR in the range of ≥1.25 or ≤0.8. ‡random effects inverse variance model with a fixed continuity correction, adding 0.5 to all cells of the 2x2 table. §random effects inverse variance model with the treatment arm continuity correction, ||the Mantel-Haenszel model without correction, ¶Bayesian random effects model using a binomial likelihood for the outcome. Abbreviations: ROR, ratio of odds ratios; MH, Mantel-Haenszel; REIV, random effects inverse variance; TACC, treatment arm continuity correction.*

#### Updated Figure 2: Agreement in effect estimates obtained by each statistical method to deal with single-zero studies
*(Please see the attached file `figure2_20260314.svg` for the high-resolution vector image)*
![Updated Figure 2](figure2_20260314.svg)

*Panels at the lower-left present histograms of LogROR, for which the denominator of the ROR appears in the diagonal at the right and the numerator above. Upper right panels present scatter plots of Log odds ratios, with the vertical axis representing the statistical methods indicated in the diagonal at the bottom and the horizontal axis representing the methods indicated at the left. RevMan MH denotes the Mantel-Haenszel model with a fixed continuity correction, adding 0.5 to all cells of the 2x2 table, which is the model implemented in the RevMan software. REIV denotes random effects inverse variance model with a fixed continuity correction, adding 0.5 to all cells of the 2x2 table. REIV TACC denotes random effects inverse variance model with the treatment arm continuity correction. MH denotes the Mantel-Haenszel model without correction. Bayesian random effects model using a binomial likelihood for the outcome.*
