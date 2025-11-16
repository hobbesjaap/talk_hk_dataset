#The MIT License (MIT)

#Copyright (c) 2025 Taura Edgar & Jacob Marsman

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
  
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

library(tidyverse)

# The aim is to have a 10-year rolling overview. The datasets contain larger
# groups than 10 years. The variable below holds the years to remove in order
# to generate a 10-year overview.

years_to_keep <- c("2015", "2016", "2017", "2018", "2019", "2020", "2021", "2022", "2023", "2024")
years2_to_keep <- c("2014-2015", "2015-2016", "2016-2017", "2017-2018", "2018-2019", "2019-2020", "2020-2021", "2021-2022", "2022-2023", "2023-2024")

# ACA Data

aca_data_total           <- read_csv("data/aca_data_total.csv")
aca_data_type            <- read_csv("data/aca_data_type.csv")
aca_data_investigation   <- read_csv("data/aca_data_investigation.csv")
aca_data_casework        <- read_csv("data/aca_data_casework.csv")

# DOJ Data

doj_data_total <- read_csv("data/doj_data_total.csv")
doj_data_breakdown <- read_csv("data/doj_data_breakdown.csv")
doj_data_summary <- read_csv("data/doj_data_summary.csv")

# ECSAF Data

ecsaf_data_total <- read_csv("data/ecsaf_data_total.csv")
ecsaf_data_victim_gender <- read_csv("data/ecsaf_data_victim_gender.csv")
ecsaf_data_victim_age <- read_csv("data/ecsaf_data_victim_age.csv")
ecsaf_data_perpetrator_gender <- read_csv("data/ecsaf_data_perpetrator_gender.csv")
ecsaf_data_perpetrator_age <- read_csv("data/ecsaf_data_perpetrator_age.csv")
ecsaf_data_perpetrator_relationship <- read_csv("data/ecsaf_data_perpetrator_relationship.csv")
ecsaf_data_type <- read_csv("data/ecsaf_data_type.csv")
ecsaf_data_location <- read_csv("data/ecsaf_data_location.csv")

# EDB Data

edb_data_total    <- read_csv("data/edb_data_total.csv")
edb_data_teachers <- read_csv("data/edb_data_teachers.csv")

# HK Police Data

hkp_data_total <- read_csv("data/hkp_data_total.csv")
hkp_data_type <- read_csv("data/hkp_data_type.csv")
hkp_data_victim_age <- read_csv("data/hkp_data_victim_age.csv")
hkp_data_victim_gender <- read_csv("data/hkp_data_victim_gender.csv")
hkp_data_relationship <- read_csv("data/hkp_data_relationship.csv")

# SWD Data

swd_data_total <- read_csv("data/swd_data_total.csv")
swd_data_victim_gender_age <- read_csv("data/swd_data_victim_gender_age.csv")
swd_data_perpetrator_gender_age <- read_csv("data/swd_data_perpetrator_gender_age.csv")
swd_data_type <- read_csv("data/swd_data_type.csv")
swd_data_relationship <- read_csv("data/swd_data_relationship.csv")
swd_data_nature <- read_csv("data/swd_data_nature.csv")
swd_data_neuro_dis <- read_csv("data/swd_data_neuro_dis.csv")

# Census Data

census_data <- read_csv("data/census_data.csv")

# CSD Data

csd_data <- read_csv("data/csd_data.csv")

# Tidying

census_data_totals <- census_data %>%
  filter(Gender == "Total") %>%
  select("Year","Numberx000")

swd_data_type$CSA_Type <- as.factor(swd_data_type$CSA_Type)
swd_data_type <- swd_data_type %>% mutate(CSA_Type = fct_relevel(CSA_Type,
                          "Sexual intercourse with relatives",
                          "Incest",
                          "Sexual intercourse with non-relatives",
                          "Other"))

swd_data_victim_gender_age <- swd_data_victim_gender_age %>% mutate(Age = fct_relevel(Age,
                          "15-17",
                          "12-14",
                          "9-11",
                          "6-8",
                          "3-5",
                          "0-2"
                          ))

# SWD Average CSA Cases

swd_csa_cases <- swd_data_total %>%
  filter(Abuse_Type == "Sexual Abuse") %>%
  select(Gender, Number_of_Cases, Source_Year)

swd_ave_csa_cases <- round(sum(swd_csa_cases$Number_of_Cases) / n_distinct(swd_csa_cases$Source_Year))

swd_csa_cases$Gender <- as.factor(swd_csa_cases$Gender)

swd_perps <- swd_data_perpetrator_gender_age %>%
  select(Gender, Number_of_Cases, Source_Year) %>%
  group_by(Source_Year, Gender) %>%
  summarise(across(everything(), sum))

swd_only_school_staff <- swd_data_relationship %>% filter(Relationship == "School teacher / personnel")

# Relationship simplification into better categories

#Outcome:

# 1. "Caregiver"
# 2. "Residential community"
# 3. "Family member / Relative"
# 4. "School / Religious personnel"
# 5. "Unidentified person / Others"
# 6. "Parent / Step-parent"
# 7. "Family friend"
# 8. "Unrelated person / Stranger"
# 9. "Friend / Schoolmate / Peer"
# 10. "Tutor / Coach"

swd_data_relationship <- swd_data_relationship %>%
  mutate(Relationship = recode(Relationship,
                               "Other" = "Unidentified person / Others",
                               "Step-parent" = "Parent / Step-parent",
                               "Family member" = "Family member / Relative",
                               "Relative" = "Family member / Relative",
                               "Family friend / parent of peer" = "Family friend",
                               "School teacher / personnel" = "School / Religious personnel",
                               "Staff of boarding section of school" = "School / Religious personnel",
                               "Religious personnel" = "School / Religious personnel",
                               "Schoolmate / friend / peer" = "Friend / Schoolmate / Peer",
                               "Co-tenant / Neighbour" = "Residential community",
                               "Inmate of residential service / boarding section of school" = "Friend / Schoolmate / Peer",
                               "Unrelated person / stranger" = "Unrelated person / Stranger",
                               "Unidentified person" = "Unidentified person / Others",
                               "Others" = "Unidentified person / Others",
                               "Family friend / parent of peer / school-mate / friend /peer" = "Family friend",
                               "School teacher / personnel / Tutor / Coach / Staff of boarding section of school / Religious personnel" = "School / Religious personnel",
                               "Co-tenant / Neighbour / Inmate of residential service / boarding section of school" = "Residential community",
                               "Unidentified person / Others" = "Unidentified person / Others",
                               "Family friend / parent of peer / schoolmate / friend / peer" = "Family friend",
                               "Co-tenant / neighbour" = "Residential community",
                               "Family friend / friend" = "Family friend",
                               "Family friend/friend" = "Family friend",
                               "Family’s friend / friend" = "Family friend",
                               "Unrelated person" = "Unrelated person / Stranger",
                               "Co-tenant/neighbour" = "Residential community",
                               "Teacher" = "School / Religious personnel",
                               "Family’s friend/friend" = "Family friend",
                               "Unrelated person stranger" = "Unrelated person / Stranger",
                               "School teacher / personnel / Staff of boarding section of school" = "School / Religious personnel",
                               "Tutor/coach" = "Tutor / Coach",
                               "Family Member" = "Family member / Relative",
                               "Parent" = "Parent / Step-parent"
                               ))

swd_data_nature <- swd_data_nature %>%
  mutate(Nature_of_Case = recode(Nature_of_Case,
                               "Considered harm/maltreatment" = "Considered \nharm/maltreatment",
                               "High risk, but not considered harm/maltreatment" = "High risk, but not considered \nharm/maltreatment",
                               "Not considered high risk of harm/maltreatment" = "Not considered high risk \nof harm/maltreatment"

  ))

hkp_data_victim_age <- hkp_data_victim_age %>% mutate(Age = fct_relevel(Age,
                                                                               "12-16",
                                                                               "6-11",
                                                                               "0-5"
                                                                        ))

hkp_data_relationship <- hkp_data_relationship %>%
  mutate(Relationship = recode(Relationship,
                               "Neighborhood /Schoolmate / Friend" = "Neighborhood / Schoolmate / Friend",
                               "Stranger" = "Stranger",
                               "Lover" = "Ex-spouse / Boyfriend / Girlfriend",
                               "Family Member /Relative" = "Family Member / Relative",
                               "Employer / Employee/ Colleague" = "Employer / Colleague",
                               "Domestic Helper" = "Domestic Helper",
                               "Others" = "Others",
                               "Ex-spouse / Boy-friend / Girl-friend" = "Ex-spouse / Boyfriend / Girlfriend",
                               "Family Member" = "Family Member / Relative",
                               "Relative" = "Family Member / Relative",
                               "Employer / Employee / Colleagues" = "Employer / Colleague",
                               "Neighborhood / Schoolmate / Friend / Known Person" = "Neighborhood / Schoolmate / Friend",
  ))

edb_data_total$Number <- as.integer(edb_data_total$Number)

inspect_doj_data <- doj_data_summary %>%
  filter(Offence == "child pornography"
         | Offence == "gross indecency with or by man under 21"
         | Offence == "intercourse with girl under 13"
         | Offence == "intercourse with girl under 16"
         | Offence == "indecent conduct towards child under 16"
         | Offence == "homosexual buggery with or by man under 16"
  )

inspect_doj_data_outcomes <- inspect_doj_data %>%
  select(Source_Year,
         Outcome_Found_Guilty,
         Outcome_Found_Not_Guilty,
         Outcome_Pleaded_Guilty,
         Outcome_Others
         ) %>%
  group_by(Source_Year) %>%
  summarise(across(c(Outcome_Found_Guilty,
                     Outcome_Found_Not_Guilty,
                     Outcome_Pleaded_Guilty,
                     Outcome_Others
                     ), sum)) %>%
  pivot_longer(cols= c(Outcome_Found_Guilty, Outcome_Found_Not_Guilty, Outcome_Pleaded_Guilty, Outcome_Others),
               names_to = "Outcome",
               values_to = "Number"
  ) %>%
  mutate(Outcome = recode(Outcome,
                          "Outcome_Found_Guilty" = "Found Guilty",
                          "Outcome_Found_Not_Guilty" = "Found Not Guilty",
                          "Outcome_Pleaded_Guilty" = "Pleaded Guilty",
                          "Outcome_Others" = "Others",
  ))

inspect_doj_data_sentences <- inspect_doj_data %>%
  select(Source_Year,
         Sentence_Acquitted,
         Sentence_Custodial_Sentence,
         Sentence_Non_Custodial_Sentence,
         Sentence_Others) %>%
         group_by(Source_Year) %>%
           summarise(across(c(Sentence_Acquitted,
                              Sentence_Custodial_Sentence,
                              Sentence_Non_Custodial_Sentence,
                              Sentence_Others
                              ), sum)) %>%
  pivot_longer(cols= c(Sentence_Acquitted,
                       Sentence_Custodial_Sentence,
                       Sentence_Non_Custodial_Sentence,
                       Sentence_Others),
               names_to = "Sentence",
               values_to = "Number"
  ) %>%
  mutate(Sentence = recode(Sentence,
                          "Sentence_Acquitted" = "Acquitted",
                          "Sentence_Custodial_Sentence" = "Custodial Sentence",
                          "Sentence_Non_Custodial_Sentence" = "Non-Custodial Sentence",
                          "Sentence_Others" = "Others"
  ))

ecsaf_data_victim_gender$Source_Year <- as.factor(ecsaf_data_victim_gender$Source_Year)
aca_data_total$Source_Year <- as.factor(aca_data_total$Source_Year)

aca_combined <- aca_data_type %>%
  filter(Suspected_Abuse_Type == "Sexual abuse") %>%
  select(Suspected_Abuse_Type, Number_of_Cases, Source_Year)

aca_casework <- aca_data_casework %>%
  select(Suspected_Abuse_Type, Number_of_Cases, Source_Year) %>%
  filter(Suspected_Abuse_Type == "Sexual abuse") %>%
  rename(Casework = Number_of_Cases)

aca_investigation <- aca_data_investigation %>%
  select(Suspected_Abuse_Type, Number_of_Cases, Source_Year) %>%
  filter(Suspected_Abuse_Type == "Sexual abuse") %>%
  rename(Investigation = Number_of_Cases)

aca_combined <- full_join(aca_combined, aca_investigation)
aca_combined <- full_join(aca_combined, aca_casework)

# Filtering out the old years

aca_casework <- aca_casework %>% filter(Source_Year %in% years2_to_keep)
aca_combined <- aca_combined %>% filter(Source_Year %in% years2_to_keep)
aca_data_casework <- aca_data_casework %>% filter(Source_Year %in% years2_to_keep)
aca_data_investigation <- aca_data_investigation %>% filter(Source_Year %in% years2_to_keep)
aca_data_total <- aca_data_total %>% filter(Source_Year %in% years2_to_keep)
aca_data_type <- aca_data_type %>% filter(Source_Year %in% years2_to_keep)
aca_investigation <- aca_investigation %>% filter(Source_Year %in% years2_to_keep)

census_data <- census_data %>% filter(Year %in% years_to_keep)
census_data_totals <- census_data_totals %>% filter(Year %in% years_to_keep)

doj_data_breakdown <- doj_data_breakdown %>% filter(Year %in% years_to_keep)
doj_data_summary <- doj_data_summary %>% filter(Source_Year %in% years_to_keep)
doj_data_total

ecsaf_data_location <- ecsaf_data_location %>% filter(Source_Year %in% years2_to_keep)
ecsaf_data_perpetrator_age <- ecsaf_data_perpetrator_age %>% filter(Source_Year %in% years2_to_keep)
ecsaf_data_perpetrator_gender <- ecsaf_data_perpetrator_gender %>% filter(Source_Year %in% years2_to_keep)
ecsaf_data_perpetrator_relationship <- ecsaf_data_perpetrator_relationship %>% filter(Source_Year %in% years2_to_keep)
ecsaf_data_total <- ecsaf_data_total %>% filter(Source_Year %in% years2_to_keep)
ecsaf_data_type <- ecsaf_data_type %>% filter(Source_Year %in% years2_to_keep)
ecsaf_data_victim_age <- ecsaf_data_victim_age %>% filter(Source_Year %in% years2_to_keep)
ecsaf_data_victim_gender <- ecsaf_data_victim_gender %>% filter(Source_Year %in% years2_to_keep)

edb_data_teachers <- edb_data_teachers %>% filter(Year %in% years_to_keep)
edb_data_total <- edb_data_total %>% filter(Year %in% years2_to_keep)

hkp_data_relationship <- hkp_data_relationship %>% filter(Source_Year %in% years_to_keep)
hkp_data_total <- hkp_data_total %>% filter(Source_Year %in% years_to_keep)
hkp_data_type <- hkp_data_type %>% filter(Source_Year %in% years_to_keep)
hkp_data_victim_age <- hkp_data_victim_age %>% filter(Source_Year %in% years_to_keep)
hkp_data_victim_gender <- hkp_data_victim_gender %>% filter(Source_Year %in% years_to_keep)

inspect_doj_data <- inspect_doj_data %>% filter(Source_Year %in% years_to_keep)
inspect_doj_data_outcomes <- inspect_doj_data_outcomes %>% filter(Source_Year %in% years_to_keep)
inspect_doj_data_sentences <- inspect_doj_data_sentences %>% filter(Source_Year %in% years_to_keep)

swd_csa_cases <- swd_csa_cases %>% filter(Source_Year %in% years_to_keep)
swd_data_nature <- swd_data_nature %>% filter(Source_Year %in% years_to_keep)
swd_data_neuro_dis <- swd_data_neuro_dis %>% filter(Source_Year %in% years_to_keep)
swd_data_perpetrator_gender_age <- swd_data_perpetrator_gender_age %>% filter(Source_Year %in% years_to_keep)
swd_data_relationship <- swd_data_relationship %>% filter(Source_Year %in% years_to_keep)
swd_data_total <- swd_data_total %>% filter(Source_Year %in% years_to_keep)
swd_data_type <- swd_data_type %>% filter(Source_Year %in% years_to_keep)
swd_data_victim_gender_age <- swd_data_victim_gender_age %>% filter(Source_Year %in% years_to_keep)
swd_perps <- swd_perps %>% filter(Source_Year %in% years_to_keep)


test <- doj_data_summary %>%
  select(Offence, Number_of_Charges, Source_Year) %>%
  filter(Offence == "homosexual buggery with or by man under 16")
