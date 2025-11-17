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

# This is where we'll calculate the impact statements that go into the report

# Value to change for current year
# This to help future versions of the report, as future impact statements can be
# calculated just by updating the datasets and this variable

current_year <- "2024"

# EDB

ave_deregistered_teachers <- edb_data_total %>%
  filter(Action == "Cancellation of teacher registration") %>%
  tally(Number)

ave_deregistered_years <- edb_data_total %>%
  count(Action == "Cancellation of teacher registration") %>%
  tibble() %>%
  select(2) %>%
  slice(2) %>%
  as.integer()

edb_ave_deregistered <- round(ave_deregistered_teachers / ave_deregistered_years)

rm(ave_deregistered_teachers)
rm(ave_deregistered_years)

# SWD

# How many percent of cases were done by children?
# (Only 16 or below age range, as 17-12 also includes adults)

perps_below_16 <- swd_data_perpetrator_gender_age %>% 
  #filter(Source_Year == current_year) %>%
  filter(Age == "16 or below") %>% 
  select(Age,Number_of_Cases) %>% 
  tally(Number_of_Cases) %>% 
  as.integer()

perps_total <- swd_data_perpetrator_gender_age %>%
#  filter(Source_Year == current_year) %>%
  select(Age,Number_of_Cases) %>% 
  tally(Number_of_Cases) %>% 
  as.integer()

perps_male <- swd_data_perpetrator_gender_age %>%
#  filter(Source_Year == current_year) %>%
  filter(Gender == "M") %>%
  select(Age,Number_of_Cases) %>% 
  tally(Number_of_Cases) %>% 
  as.integer()

swd_case_types_total <- swd_data_type %>%
  tally(Number_of_Cases) %>%
  as.integer()

swd_case_types_penetration <- swd_data_type %>%
  filter(CSA_Type != "Other") %>%
  tally(Number_of_Cases) %>%
  as.integer()

victims_total <- swd_data_victim_gender_age %>%
#  filter(Source_Year == current_year) %>%
  tally(Number_of_Cases) %>%
  as.integer()

victims_female <- swd_data_victim_gender_age %>%
#  filter(Source_Year == current_year) %>%
  filter(Gender == "F") %>%
  tally(Number_of_Cases) %>%
  as.integer()

all_girls <- census_data %>%
  filter(Year == current_year) %>%
  filter(Gender == "F") %>%
  filter(Age == "Total") %>%
  select("Numberx000") %>%
  as.integer()

victims_12_to_17 <- swd_data_victim_gender_age %>%
#  filter(Source_Year == current_year) %>%
  filter(Age == "12-14" | Age == "15-17") %>%
  tally(Number_of_Cases) %>%
  as.integer()

victims_neurodiverse <- swd_data_neuro_dis %>%
  filter(Abuse_Type == "Sexual") %>%
#  filter(Source_Year == current_year) %>%
  filter(Neuro_Affirming_Typology == "Neurodivergence") %>%
  tally(Number_of_Cases) %>%
  as.integer()

victims_disability <- swd_data_neuro_dis %>%
  filter(Abuse_Type == "Sexual") %>%
#  filter(Source_Year == current_year) %>%
  filter(Neuro_Affirming_Typology == "Disability") %>%
  tally(Number_of_Cases) %>%
  as.integer()

doj_all_guilty <- inspect_doj_data_outcomes %>%
  filter(Outcome == "Found Guilty" | Outcome == "Pleaded Guilty") %>%
  tally(Number) %>%
  as.integer()

doj_all_outcomes <- inspect_doj_data_outcomes %>%
  tally(Number) %>%
  as.integer()

doj_perc_all_guilty <- round((doj_all_guilty / doj_all_outcomes)*100)

swd_known_relationships <- swd_data_relationship %>%
  filter(Relationship != "Unidentified person / Others") %>%
  filter(Relationship != "Unrelated person / Stranger") %>%
  tally(Number_of_Cases) %>%
  as.integer()

swd_all_relationships <- swd_data_relationship %>% tally(Number_of_Cases) %>% as.integer()

# is_ = Impact Statement

is_swd_know_abuser <- round((swd_known_relationships / swd_all_relationships)*100)
is_swd_perps_children <- round((perps_below_16 / perps_total)*100)
is_swd_perps_male <- round((perps_male / perps_total)*100)
is_swd_cases_penetration <- round((swd_case_types_penetration / swd_case_types_total)*100)
is_swd_victims_female <- round((victims_female / victims_total)*100)
is_swd_one_of_out_girls <- round(all_girls / victims_female)
is_swd_between_12_17 <- round((victims_12_to_17 / victims_total)*100)
is_swd_neurodiverse <- round((victims_neurodiverse / victims_total)*100)
is_swd_disability <- round((victims_disability / victims_total)*100)

# HKPF

hkp_vict_girls <- hkp_data_victim_gender %>%
  filter(Gender == "F") %>%
  tally(Number_of_Cases) %>% as.integer()

hkp_vict_all <- hkp_data_victim_gender %>% tally(Number_of_Cases) %>% as.integer()

hkp_know_abuser <- hkp_data_relationship %>%
  filter(Relationship != "Stranger") %>%
  tally(Number_of_Cases) %>% as.integer()

hkp_all_relation <- hkp_data_relationship %>%
  #filter(Relationship != "Stranger") %>%
  tally(Number_of_Cases) %>% as.integer()

hkp_penetration <- hkp_data_type %>%
  filter(CSA_Type == "Rape" | CSA_Type == "Incest" | CSA_Type == "Buggery" 
  | CSA_Type == "Unlawful Sexual Intercourse") %>%
  tally(Number_of_Cases) %>% as.integer()

hkp_all_types <- hkp_data_type %>% tally(Number_of_Cases) %>% as.integer()

is_hkp_penetration <- round((hkp_penetration / hkp_all_types)*100)
is_hkp_know_abuser <- round((hkp_know_abuser / hkp_all_relation)*100)
is_hkp_vict_girls <- round((hkp_vict_girls / hkp_vict_all)*100)

# DOJ

doj_non_custodial <- inspect_doj_data_sentences %>% filter(Sentence == "Non-Custodial Sentence") %>% tally(Number) %>% as.integer()
doj_total_outcome <- inspect_doj_data_sentences %>% tally(Number) %>% as.integer()

is_doj_not_incarcerated <- round((doj_non_custodial / doj_total_outcome)*100)

doj_penetration_charges <- inspect_doj_data %>%
  filter(Offence == "intercourse with girl under 16" |
           Offence == "intercourse with girl under 13" |
           Offence == "homosexual buggery with or by man under 16"
  ) %>%
  tally(Number_of_Charges) %>% as.integer()

doj_all_charges <- inspect_doj_data %>%
  tally(Number_of_Charges) %>% as.integer()

is_doj_penetration_charges <- round((doj_penetration_charges / doj_all_charges)*100)

swd_2020_24_cases <- swd_data_relationship %>%
  filter(Source_Year == "2020" |
           Source_Year == "2021" |
           Source_Year == "2022" |
           Source_Year == "2023" |
           Source_Year == "2024") %>%
  tally(Number_of_Cases) %>% as.integer()

swd_2020_24_cases_friend <- swd_data_relationship %>%
  filter(Source_Year == "2020" |
           Source_Year == "2021" |
           Source_Year == "2022" |
           Source_Year == "2023" |
           Source_Year == "2024") %>%
  filter(Relationship == "Friend / Schoolmate / Peer") %>%
  tally(Number_of_Cases) %>% as.integer()

hkp_data_type %>%
  filter(Source_Year == "2024") %>%
  tally(Number_of_Cases) %>% as.integer()

