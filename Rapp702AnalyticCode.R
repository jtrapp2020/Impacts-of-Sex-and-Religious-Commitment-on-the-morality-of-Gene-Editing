#JT Rapp - Final Project 702 Code - Dec. 13, 2025
# Code Set-up (Library + data reading) ------------------------------------
#Necessary Libraries
library(haven)
library(tidyverse)
library(broom)
library(DescTools)
library(ggplot2)
library(scales)
library(gtsummary)
library(smd)
library(tibble)
library(knitr)

#Load the dataset - ensure SAV file is in same folder with same name
raw_data <- read_sav("ATP W34.sav")
# Data Cleaning -----------------------------------------------------------
#Create Clean Analysis Data Set
analysis_df <- raw_data %>%
  select(MED7_W34, F_SEX_FINAL, F_RELCOM3CAT_FINAL, WEIGHT_W34) %>%
  # Filter out missing data/refusals
  filter(MED7_W34 <= 2,
         F_RELCOM3CAT_FINAL <= 3,
         F_SEX_FINAL <= 2) %>%
  mutate(
    #Create Binary Outcome (0/1) for Regression
    Outcome_Binary = if_else(MED7_W34 == 1, 1, 0),
    # Create Factor and MANUALLY set short labels
    #(1 = Appropriate Use, 2 = Too Far)
    Outcome_Factor = factor(MED7_W34,
                            levels = c(1, 2),
                            labels = c("Appropriate", "Too Far")),
    #Convert Sex to Factor
    Sex = as_factor(F_SEX_FINAL) %>% droplevels(),
    #Convert Stratifier to Factor
    Relig_Commitment = as_factor(F_RELCOM3CAT_FINAL) %>% droplevels()
  )

#Verify the levels are now correct
table(analysis_df$Outcome_Factor)
# Create Table One (Contingency Table) ------------------------------------
#Create Table 1
table1 <- analysis_df %>%
  select(Sex, Relig_Commitment, Outcome_Factor) %>%
  tbl_summary(
    #Split the table by Male/Female
    by = Sex,
    label = list(
      Relig_Commitment ~ "Religious Commitment",
      Outcome_Factor ~ "Opinion on Gene Editing"
    ),
    statistic = all_categorical() ~ "{n} ({p}%)",
    digits = all_categorical() ~ 1
  ) %>%
  #Calculate SMD
  add_difference(test = everything() ~ "smd") %>%
  #Hide the Confidence Interval column
  modify_column_hide(ci) %>%
  #Rename the estimate column to "SMD"
  modify_header(estimate ~ "**SMD**") %>%
  add_overall() %>%
  bold_labels()

# Print the table
table1
# Create Figure One (Stacked Bar Chart) -----------------------------------
#Create gg plot
ggplot(analysis_df, aes(x = Sex, fill = Outcome_Factor)) +
  geom_bar(position = "fill") +
  #Facet on Religious Commitment group
  facet_wrap(~ Relig_Commitment) +
  #Format the y-axis to show percentages
  scale_y_continuous(labels = scales::percent) +
  #Add labels
  labs(
    title = "Views on Gene Editing by Sex and Religious Commitment",
    subtitle = "Comparison of approval for gene editing on human embryos",
    x = "Sex",
    y = "Proportion",
    fill = "Response"
  ) +
  theme_minimal() +
  scale_fill_manual(values =
                      c("Appropriate" = "#4682B4", "Too Far" = "#CD5C5C")) +
  theme(legend.position = "bottom")
# Test One: Chi Square Test -----------------------------------------------
#Create the 2x2 contingency table
table_2x2 <- table(analysis_df$Sex, analysis_df$Outcome_Factor)

table_2x2
#Run Chi-Square
chisq_result <- chisq.test(table_2x2)
print(chisq_result)

#Check Expected values
chisq_result$expected
# Test 2: Logistic Regression ---------------------------------------------
#Fit Logistic Model
log_model_simple <- glm(Outcome_Binary ~ Sex,
                        data = analysis_df,
                        family = "binomial")

#Print Exponentiated Results
tidy(log_model_simple, exponentiate = TRUE, conf.int = TRUE)


# Test 3: Breslow-Day Test ------------------------------------------------
#Create a 3-way table: Predictor, Outcome, Stratifier
table_2x2xk <- xtabs(~ factor(Sex, levels = c("Female", "Male")) +
                       Outcome_Factor + Relig_Commitment,
                     data = analysis_df)

#Run Breslow-Day Test
bd_test <- BreslowDayTest(table_2x2xk)
print(bd_test)
# Test 4: Run CMH Test ----------------------------------------------------
#Run CMH Test
mantelhaen.test(table_2x2xk)
