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

*   **Updated Table 2:** Characteristics of the included meta-analyses categorized according to the ratio of odds ratios
*   **Updated Figure 2:** Agreement in effect estimates obtained by each statistical method to deal with single-zero studies
