
# --- Load Libraries ---
library(readr)
library(dplyr)
library(tidyr)
library(gtsummary)
library(flextable)
library(ggplot2)
library(gridExtra)
library(grid)

# --- Data Loading and Cleaning ---
data_raw <- read_csv("/Users/Yasushi/github/zero_event_revise_2026/data_final_revise2025.csv", show_col_types = FALSE)

# Clean data
data <- data_raw %>%
  mutate(
    mhe_te2 = as.numeric(mhe_te),
    log_te2 = as.numeric(log_te),
    log_te2 = if_else(is.infinite(log_upper) | is.na(log_te), NA_real_, log_te2),
    mhe_te2 = if_else(mhe_te2 == 0, NA_real_, mhe_te2)
  ) %>%
  mutate(
    n_studies = k,
    n_participants = total_n,
    n_events = event.e.pooled + event.c.pooled,
    
    # Log-transformed effects (TE)
    logmh_te    = log(mh_te),
    logivr_te   = log(ivr_te),
    logtacc_te  = log(ivrTACC_te),
    logpeto_te  = log(peto_te),
    logmhe_te   = log(mhe_te2),
    loglog_te   = log(log_te2),
    logbayes_te = log(bayesr_te)
  ) %>%
  mutate(
    # ROR calculations (vs RevMan MH) for Table 2
    ror_reiv    = ivr_te / mh_te,
    ror_tacc    = ivrTACC_te / mh_te,
    ror_peto    = peto_te / mh_te,
    ror_mhe     = mhe_te2 / mh_te,
    ror_log     = log_te2 / mh_te,
    ror_bayes   = bayesr_te / mh_te
  ) %>%
  mutate(
    # ALL Log-ROR combinations for Figure 2 histograms
    # column 1 (MH)
    logror_mh_ivr   = log(ivr_te / mh_te),
    logror_mh_tacc  = log(ivrTACC_te / mh_te),
    logror_mh_peto  = log(peto_te / mh_te),
    logror_mh_mhe   = log(mhe_te2 / mh_te),
    logror_mh_log   = log(log_te2 / mh_te),
    logror_mh_bayes = log(bayesr_te / mh_te),
    # column 2 (IVR)
    logror_ivr_tacc  = log(ivrTACC_te / ivr_te),
    logror_ivr_peto  = log(peto_te / ivr_te),
    logror_ivr_mhe   = log(mhe_te2 / ivr_te),
    logror_ivr_log   = log(log_te2 / ivr_te),
    logror_ivr_bayes = log(bayesr_te / ivr_te),
    # column 3 (TACC)
    logror_tacc_peto  = log(peto_te / ivrTACC_te),
    logror_tacc_mhe   = log(mhe_te2 / ivrTACC_te),
    logror_tacc_log   = log(log_te2 / ivrTACC_te),
    logror_tacc_bayes = log(bayesr_te / ivrTACC_te),
    # column 4 (Peto)
    logror_peto_mhe   = log(mhe_te2 / peto_te),
    logror_peto_log   = log(log_te2 / peto_te),
    logror_peto_bayes = log(bayesr_te / peto_te),
    # column 5 (MHE)
    logror_mhe_log    = log(log_te2 / mhe_te2),
    logror_mhe_bayes  = log(bayesr_te / mhe_te2),
    # column 6 (LOG)
    logror_log_bayes  = log(bayesr_te / log_te2)
  )

# --- Table 1: Overall Characteristics ---

# Preparation for Table 1
data_table1 <- data %>%
  mutate(
    `Number of included studies` = n_studies,
    `Number of participants` = n_participants,
    `Number of events` = n_events,
    original_method = paste(model, method, sep = " "),
    `Statistical methods used in the Cochrane reviews` = case_when(
      original_method == "Fixed Inverse" ~ "Fixed IV method with a fixed correction",
      original_method == "Fixed MH" ~ "RevMan MH model*",
      original_method %in% c("Random MH", "Random Inverse") ~ "REIV",
      original_method %in% c("Fixed Peto", "Fixed PETO") ~ "Peto",
      TRUE ~ original_method # Fallback
    ),
    `Statistical methods used in the Cochrane reviews` = factor(
      `Statistical methods used in the Cochrane reviews`, 
      levels = c("Fixed IV method with a fixed correction", "RevMan MH model*", "Peto", "REIV")
    )
  )

table1_obj <- data_table1 %>%
  select(`Number of included studies`, `Number of participants`, `Number of events`, `Statistical methods used in the Cochrane reviews`) %>%
  tbl_summary()

# Save Table 1
footnote_table1 <- "Note: Values in parentheses show percentages or interquartile range. *The Mantel-Haenszel model with a fixed continuity correction, adding 0.5 to all cells of the 2x2 table, implemented in the RevMan software. Abbreviations: MH, Mantel-Haenszel; REIV, random effects inverse variance method with a fixed correction."

table1_md <- table1_obj %>% as_tibble() %>% knitr::kable(format = "markdown", caption = "Table 1. Characteristics of included meta-analyses.")
writeLines(c(table1_md, "", footnote_table1), "/Users/Yasushi/github/zero_event_revise_2026/table1_20260314.md")

# --- Categorization for Table 2 ---
categorize_ror <- function(x) {
  case_when(
    is.na(x) ~ NA_character_,
    x >= 1.25 | x <= 0.8 ~ "Large",
    (x >= 0.8 & x < 0.9) | (x > 1.11 & x < 1.25) ~ "Moderate",
    x >= 0.9 & x <= 1.11 ~ "Small",
    TRUE ~ "NA"
  )
}

data <- data %>%
  mutate(
    cat_reiv  = categorize_ror(ror_reiv),
    cat_tacc  = categorize_ror(ror_tacc),
    cat_peto  = categorize_ror(ror_peto),
    cat_mhe   = categorize_ror(ror_mhe),
    cat_log   = categorize_ror(ror_log),
    cat_bayes = categorize_ror(ror_bayes)
  )

# --- Table 2 Logic ---
get_method_stats <- function(df, cat_col) {
  df_filtered <- df %>% filter(!is.na(!!sym(cat_col)))
  total_n_method <- nrow(df_filtered)
  stats <- df_filtered %>%
    group_by(category = !!sym(cat_col)) %>%
    summarise(
      count = n(),
      perc = (n() / total_n_method) * 100,
      k_med = median(n_studies, na.rm = TRUE),
      k_q1  = quantile(n_studies, 0.25, na.rm = TRUE),
      k_q3  = quantile(n_studies, 0.75, na.rm = TRUE),
      n_med = median(n_participants, na.rm = TRUE),
      n_q1  = quantile(n_participants, 0.25, na.rm = TRUE),
      n_q3  = quantile(n_participants, 0.75, na.rm = TRUE),
      e_med = median(n_events, na.rm = TRUE),
      e_q1  = quantile(n_events, 0.25, na.rm = TRUE),
      e_q3  = quantile(n_events, 0.75, na.rm = TRUE),
      .groups = 'drop'
    ) %>%
    complete(category = c("Small", "Moderate", "Large")) %>%
    mutate(
      methods_str = ifelse(is.na(count), "-", sprintf("%d (%.0f%%)", count, perc)),
      k_str = ifelse(is.na(k_med), "-", sprintf("%.0f (%.0f, %.0f)", k_med, k_q1, k_q3)),
      n_str = ifelse(is.na(n_med), "-", sprintf("%.0f (%.0f, %.0f)", n_med, n_q1, n_q3)),
      e_str = ifelse(is.na(e_med), "-", sprintf("%.0f (%.0f, %.0f)", e_med, e_q1, e_q3))
    )
  return(stats)
}

methods_list <- list("REIV"="cat_reiv", "REIV TACC"="cat_tacc", "Peto"="cat_peto", "MH (no correction)"="cat_mhe", "Logistic regression"="cat_log", "Bayesian model"="cat_bayes")
results <- lapply(names(methods_list), function(m_name) {
  stats <- get_method_stats(data, methods_list[[m_name]])
  stats$method_name <- m_name
  return(stats)
})
results_df <- bind_rows(results)

# Create segments for Table 2
methods_section <- results_df %>% select(method_name, category, methods_str) %>% pivot_wider(names_from = category, values_from = methods_str) %>% rename(Characteristics = method_name) %>% mutate(Section = "Methods")
studies_section <- results_df %>% select(method_name, category, k_str) %>% pivot_wider(names_from = category, values_from = k_str) %>% rename(Characteristics = method_name) %>% mutate(Section = "Median number of studies")
participants_section <- results_df %>% select(method_name, category, n_str) %>% pivot_wider(names_from = category, values_from = n_str) %>% rename(Characteristics = method_name) %>% mutate(Section = "Median number of participants")
events_section <- results_df %>% select(method_name, category, e_str) %>% pivot_wider(names_from = category, values_from = e_str) %>% rename(Characteristics = method_name) %>% mutate(Section = "Median number of events")

col_order <- c("Section", "Characteristics", "Small", "Moderate", "Large")
final_table_df <- bind_rows(
  data.frame(Section = "Methods", Characteristics = "Methods", Small = "", Moderate = "", Large = ""),
  methods_section[, col_order],
  data.frame(Section = "Median number of studies", Characteristics = "Median number of studies", Small = "", Moderate = "", Large = ""),
  studies_section[, col_order],
  data.frame(Section = "Median number of participants", Characteristics = "Median number of participants", Small = "", Moderate = "", Large = ""),
  participants_section[, col_order],
  data.frame(Section = "Median number of events", Characteristics = "Median number of events", Small = "", Moderate = "", Large = ""),
  events_section[, col_order]
)

# Footnote preparation
n_missing_log = sum(is.infinite(data_raw$log_upper) | is.na(data_raw$log_te), na.rm = TRUE)
n_missing_mhe = sum(data_raw$mhe_te == 0 | is.na(data_raw$mhe_te), na.rm = TRUE)
total_excluded = n_missing_log + n_missing_mhe

footnote_text <- sprintf("Note: Values in parentheses shows percentage or interquartile range. Percentage calculations were based on a denominator that excluded %d missing values resulting from non-convergence for the MH and logistic regression models.\n*The Mantel-Haenszel model with a fixed continuity correction, adding 0.5 to all cells of the 2x2 table, which is the model implemented in the RevMan software.\n†Small, ROR in the range of 0.9 to 1.11; Moderate, ROR in the range of 0.8 to 0.9 or 1.11 to 1.25; Large, ROR in the range of ≥1.25 or ≤0.8. ‡random effects inverse variance model with a fixed continuity correction, adding 0.5 to all cells of the 2x2 table. §random effects inverse variance model with the treatment arm continuity correction, ||the Mantel-Haenszel model without correction, ¶Bayesian random effects model using a binomial likelihood for the outcome. Abbreviations: ROR, ratio of odds ratios; MH, Mantel-Haenszel; REIV, random effects inverse variance; TACC, treatment arm continuity correction.", total_excluded)

# Save Table 2 
table2_md_content <- final_table_df %>% 
  select(-Section) %>%
  knitr::kable(format = "markdown", caption = "Table 2. Characteristics of the included meta-analyses categorized according to the ratio of odds ratios for each method versus RevMan Mantel-Haenszel model*")

writeLines(c(table2_md_content, "", footnote_text), "/Users/Yasushi/github/zero_event_revise_2026/table2_20260314.md")

# --- Figure 2 ---
# Helper functions for clean axes
create_scatter_plot <- function(x_var, y_var) {
    p <- ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]])) +
      geom_point(size = 0.5, alpha = 0.4) + # slightly larger points for visibility
      geom_abline(intercept = 0, slope = 1, color="red") +
      theme_bw() +
      theme(axis.title = element_blank(), 
            text = element_text(family = "serif")) +
      coord_cartesian(xlim = c(-5, 5), ylim = c(-2, 6)) # Adjusted Y range as per PDF
    return(p)
}

create_histogram <- function(x_var) {
    p <- ggplot(data, aes(x = .data[[x_var]])) +
      geom_histogram(binwidth = 0.1, fill = "gray40", color = "gray40") +
      theme_bw() +
      theme(axis.title = element_blank(), 
            text = element_text(family = "serif")) +
      coord_cartesian(xlim = c(-2, 2), ylim = c(0, 600))
    return(p)
}

plots <- matrix(list(NULL), nrow = 7, ncol = 7)
empty <- ggplot() + theme_void()
for (i in 1:7) { for (j in 1:7) { plots[i,j] <- list(empty) } }

# Labels on the Diagonal
plots[1, 1] <- list(textGrob("RevMan MH", gp = gpar(fontsize = 20, fontfamily = "serif"))) 
plots[2, 2] <- list(textGrob("REIV", gp = gpar(fontsize = 20, fontfamily = "serif"))) 
plots[3, 3] <- list(textGrob("REIV TACC", gp = gpar(fontsize = 20, fontfamily = "serif"))) 
plots[4, 4] <- list(textGrob("Peto", gp = gpar(fontsize = 20, fontfamily = "serif"))) 
plots[5, 5] <- list(textGrob("MH", gp = gpar(fontsize = 20, fontfamily = "serif"))) 
plots[6, 6] <- list(textGrob("Logistic", gp = gpar(fontsize = 20, fontfamily = "serif"))) 
plots[7, 7] <- list(textGrob("Bayesian", gp = gpar(fontsize = 20, fontfamily = "serif")))

# Upper Triangle: Scatter Plots (comparing method in row vs method in column)
# Row 1 scatters
plots[1, 2] <- list(create_scatter_plot("logivr_te", "logmh_te"))
plots[1, 3] <- list(create_scatter_plot("logtacc_te", "logmh_te"))
plots[1, 4] <- list(create_scatter_plot("logpeto_te", "logmh_te"))
plots[1, 5] <- list(create_scatter_plot("logmhe_te", "logmh_te"))
plots[1, 6] <- list(create_scatter_plot("loglog_te", "logmh_te"))
plots[1, 7] <- list(create_scatter_plot("logbayes_te", "logmh_te"))

# Row 2 scatters
plots[2, 3] <- list(create_scatter_plot("logtacc_te", "logivr_te"))
plots[2, 4] <- list(create_scatter_plot("logpeto_te", "logivr_te"))
plots[2, 5] <- list(create_scatter_plot("logmhe_te", "logivr_te"))
plots[2, 6] <- list(create_scatter_plot("loglog_te", "logivr_te"))
plots[2, 7] <- list(create_scatter_plot("logbayes_te", "logivr_te"))

# Row 3 scatters
plots[3, 4] <- list(create_scatter_plot("logpeto_te", "logtacc_te"))
plots[3, 5] <- list(create_scatter_plot("logmhe_te", "logtacc_te"))
plots[3, 6] <- list(create_scatter_plot("loglog_te", "logtacc_te"))
plots[3, 7] <- list(create_scatter_plot("logbayes_te", "logtacc_te"))

# Row 4 scatters
plots[4, 5] <- list(create_scatter_plot("logmhe_te", "logpeto_te"))
plots[4, 6] <- list(create_scatter_plot("loglog_te", "logpeto_te"))
plots[4, 7] <- list(create_scatter_plot("logbayes_te", "logpeto_te"))

# Row 5 scatters
plots[5, 6] <- list(create_scatter_plot("loglog_te", "logmhe_te"))
plots[5, 7] <- list(create_scatter_plot("logbayes_te", "logmhe_te"))

# Row 6 scatters
plots[6, 7] <- list(create_scatter_plot("logbayes_te", "loglog_te"))

# Lower Triangle: Histograms (Log-ROR distributions)
# Col 1 histograms
plots[2, 1] <- list(create_histogram("logror_mh_ivr"))
plots[3, 1] <- list(create_histogram("logror_mh_tacc"))
plots[4, 1] <- list(create_histogram("logror_mh_peto"))
plots[5, 1] <- list(create_histogram("logror_mh_mhe"))
plots[6, 1] <- list(create_histogram("logror_mh_log"))
plots[7, 1] <- list(create_histogram("logror_mh_bayes"))

# Col 2 histograms
plots[3, 2] <- list(create_histogram("logror_ivr_tacc"))
plots[4, 2] <- list(create_histogram("logror_ivr_peto"))
plots[5, 2] <- list(create_histogram("logror_ivr_mhe"))
plots[6, 2] <- list(create_histogram("logror_ivr_log"))
plots[7, 2] <- list(create_histogram("logror_ivr_bayes"))

# Col 3 histograms
plots[4, 3] <- list(create_histogram("logror_tacc_peto"))
plots[5, 3] <- list(create_histogram("logror_tacc_mhe"))
plots[6, 3] <- list(create_histogram("logror_tacc_log"))
plots[7, 3] <- list(create_histogram("logror_tacc_bayes"))

# Col 4 histograms
plots[5, 4] <- list(create_histogram("logror_peto_mhe"))
plots[6, 4] <- list(create_histogram("logror_peto_log"))
plots[7, 4] <- list(create_histogram("logror_peto_bayes"))

# Col 5 histograms
plots[6, 5] <- list(create_histogram("logror_mhe_log"))
plots[7, 5] <- list(create_histogram("logror_mhe_bayes"))

# Col 6 histograms
plots[7, 6] <- list(create_histogram("logror_log_bayes"))

# Save Final Figure 2
# We must transpose the matrix because R matrices are column-major by default
g2 <- suppressWarnings(arrangeGrob(grobs = t(plots), ncol = 7))
suppressWarnings(ggsave("/Users/Yasushi/github/zero_event_revise_2026/figure2_20260314.svg", g2, width = 18, height = 12))
