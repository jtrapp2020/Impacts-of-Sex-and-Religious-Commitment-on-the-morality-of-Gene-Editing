# Public Views on Gene Editing: A Statistical Analysis

This repository contains the final analytical report for **BIOSTAT 702: Categorical Data Analysis**. The project utilizes data from the Pew Research Center to investigate the intersection of gender, religious commitment, and bioethical opinions regarding gene editing technology.

## 📌 Project Overview
Gene editing technology raises complex moral and scientific questions. This analysis focuses on determining if a "gender gap" exists in public opinion regarding gene editing for human embryos and whether differences in religious commitment explain this potential gap.

**Primary Research Question:** Is there an association between sex and the opinion that gene editing is "taking medical technology too far," and does this association hold when controlling for religious commitment?

## 📂 Data Source
The data is derived from the **2018 American Trends Panel (Wave 34)** conducted by the Pew Research Center.
* **Sample Size:** $N = 2,264$ (Analytical sample after exclusion of refusals)
* **Key Variables:**
    * **Outcome:** Opinion on Gene Editing ("Appropriate use" vs. "Taking technology too far")
    * **Predictor:** Sex (Male vs. Female)
    * **Stratifying Variable:** Religious Commitment (High, Medium, Low)

## 📊 Methodology
The analysis was conducted in **R** using R Markdown. The statistical workflow included:

1.  **Descriptive Statistics:** Summary tables (`gtsummary`) and standardized mean differences (SMD) to assess covariate balance.
2.  **Visual Analysis:** Stacked bar charts to visualize opinion distribution across strata.
3.  **Aim 1 Analysis:**
    * Chi-Square Test of Independence.
    * Unadjusted Logistic Regression (to calculate raw Odds Ratios).
4.  **Aim 2 Analysis:**
    * **Breslow-Day Test:** To test for homogeneity of odds ratios (interaction check).
    * **Cochran-Mantel-Haenszel (CMH) Test:** To estimate a common odds ratio adjusted for religious commitment.

## 🔑 Key Findings
* **Significant Gender Gap:** Females were significantly less likely to view gene editing as an "appropriate use of medical technology" compared to males ($p < .001$).
* **Role of Religion:** While religious commitment is strongly associated with bioethical views, it **did not** explain the gender gap.
* **Conclusion:** The association between sex and opinion is robust. Even after adjusting for religious commitment, females had approximately **45\% lower odds** of approval compared to males (Adjusted OR $\approx$ 0.55).

## 🛠️ Dependencies & Usage
To reproduce this analysis, clone the repository and open the R Markdown file.

**Required R Packages:**
```r
install.packages(c("tidyverse", "gtsummary", "broom", "DescTools", "knitr"))