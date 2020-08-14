context("User Tests")

base_path <- "c:/packages/rptr/tests/testthat"

base_path <- "./"

test_that("demo table works.", {
  
  
  library(tidyverse)
  library(haven)

  dir_base <- "c:/Projects/Experis/Ideation/R Training/Clinical/code/"
  
  source(file.path(dir_base, "formats.R"))
  
  
  # Data Filepath
  dir_data <- file.path(dir_base, "data") 
  
  # Load Data
  data_demo   <- file.path(dir_data, "dm.sas7bdat") %>%
    read_sas() %>% filter(ARM != "SCREEN FAILURE") 
  
  
  sex_decode <- c("M" = "Male",
                  "F" = "Female")
  
  race_decode <- c("WHITE" = "White",
                   "BLACK OR AFRICAN AMERICAN" = "Black or African American",
                   "ASIAN" = "Asian or Pacific Islander",
                   "NATIVE AMERICAN" = "Native American",
                   "UNKNOWN" = "Unknown")
  
  arm_pop <- data_demo %>% count(ARM) %>% deframe() 
  
  
  demo_age <-
    data_demo %>%
    group_by(ARM) %>%
    summarise(across(.cols = AGE,
                     .fns = list(N      = ~ n_fmt(.),
                                 Mean   = ~ mean_sd(mean(.), sd(.)),
                                 Median = ~ median_fmt(median(.)),
                                 `Q1 - Q3` = ~ quantile_range(quantile(., 0.25),
                                                              quantile(., 0.75)),
                                 Range  = ~ range_fmt(range(.))
                     ))) %>%
    pivot_longer(-ARM,
                 names_to  = c("var", "label"),
                 names_sep = "_",
                 values_to = "value") %>%
    pivot_wider(names_from = ARM,
                values_from = "value") 
  

  
  demo_sex <-
    data_demo %>%
    add_count(ARM, SEX,  name = "n_SEX") %>%
    select(ARM, SEX, n_SEX) %>%
    distinct() %>%
    pivot_longer(cols = c(SEX),
                 names_to  = "var",
                 values_to = "label") %>%
    pivot_wider(names_from  = ARM,
                values_from = n_SEX,
                values_fill = 0) %>%
    mutate(label = factor(label, levels = names(sex_decode),
                          labels = sex_decode),
           `ARM A` = cnt_pct(`ARM A`, arm_pop["ARM A"]),
           `ARM B` = cnt_pct(`ARM B`, arm_pop["ARM B"]),
           `ARM C` = cnt_pct(`ARM C`, arm_pop["ARM C"]),
           `ARM D` = cnt_pct(`ARM D`, arm_pop["ARM D"])) 
  
  
  
  demo_race <-
    data_demo %>%
    add_count(ARM, RACE, name = "n_RACE") %>%
    select(ARM, RACE, n_RACE) %>%
    distinct() %>%
    pivot_longer(cols = RACE,
                 names_to  = "var",
                 values_to = "label") %>%
    pivot_wider(names_from  = ARM,
                values_from = n_RACE,
                values_fill = 0) %>%
    mutate(label = factor(label, levels = names(race_decode),
                          labels = race_decode),
           `ARM A` = cnt_pct(`ARM A`, arm_pop["ARM A"]),
           `ARM B` = cnt_pct(`ARM B`, arm_pop["ARM B"]),
           `ARM C` = cnt_pct(`ARM C`, arm_pop["ARM C"]),
           `ARM D` = cnt_pct(`ARM D`, arm_pop["ARM D"])) %>%
    arrange(var, label) 
  
  
  demo <- bind_rows(demo_age, demo_sex, demo_race) 
  
  
  #View(demo)
  
  
  # Stub decode
  block_fmt <- c(AGE = "Age", SEX = "Sex", RACE = "Race")
  
  # Define table
  tbl <- create_table(demo, first_row_blank = TRUE) %>% 
    define(var, blank_after = TRUE, dedupe = TRUE, 
           format = block_fmt, label = "") %>% 
    define(label, label = "") %>%
    define(`ARM A`, align = "center", label = "Placebo", n = 36) %>% 
    define(`ARM B`, align = "center", label = "Drug 10mg", n = 38) %>% 
    define(`ARM C`, align = "center", label = "Drug 20mg", n = 38) %>% 
    define(`ARM D`, align = "center", label = "Competitor", n = 38)
  
  # Define Report
  rpt <- create_report(file.path(base_path, "output/user4.out")) %>%
    titles("Table 14.1/4", 
           "Demographics and Baseline Characteristics",
           "Specify Population") %>% 
    add_content(tbl)
  
  # Write out report
  res1 <- write_report(rpt)

  
})