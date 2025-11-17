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

# Initial setup

library(tidyverse)
library(ggtext)
library(showtext)
library(patchwork)
library(janitor)

font_add_google("Outfit", family = "special")
showtext_auto()

custom_colours <- c("#8C254D", "#C6B910", "#DBD5CD", "#10576A", "#B66F84", "#dfd012", "#AFAAA4", "#177b96")
custom_colours2 <- c("#8C254D", "#C6B910", "#7F7770", "#10576A", "#B66F84", "#dfd012", "#AFAAA4", "#177b96")
custom_colours_long <- c("#8C254D", "#C6B910", "#DBD5CD", "#10576A", "#B66F84", "#dfd012", "#AFAAA4", "#177b96","#000000","#E1C4CC","#7F7770", "#D3C511","#146980")
female_male_colours <- c("#8C254D","#10576A","#7F7770")
c_burgundy <- "#8C254D"

# Census Totals

ggplot(census_data_totals, aes(x = Year, y = Numberx000)) +
  geom_line(color = "#B66F84", size = 1.5) +
  geom_area(fill = "#8C254D", alpha = 0.3) +
  scale_color_manual(values = custom_colours) +
  scale_x_continuous(n.breaks = 10) +
  geom_point(color = "#8C254D") +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                           nudge_x = 0.4,
                           segment.colour = NA,
                           nudge_y = 15,
                           size = 4,
                           direction = "y",
                           show.legend = F) +
  labs(
       y = "Population Size",
       x = "Year",
       #title="Child Population (<18) in Hong Kong - Annual Trend",
       caption="Source: Hong Kong Census and Statistics Department"
       ) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 16, hjust = 0, color="#8C254D"),
    plot.subtitle=element_text(color=c_burgundy)
  )

#ggsave("generated/hk_child_pop.png")

# SWD - Number of CSA Cases Annual Trend

swd_csa_cases %>%
  group_by(Source_Year) %>%
  summarise(across(c(Number_of_Cases), sum)) %>%
  ggplot(aes(x = Source_Year, y = Number_of_Cases)) +
  geom_line(color = "#C6B910", size = 1.5) +
  geom_point(color = "#C6B910", size = 3) +
  geom_area(fill = "#dfd012", alpha = 0.3) +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                            nudge_x = 0.4,
                            segment.colour = NA,
                            nudge_y = 15,
                            size = 4,
                            direction = "y",
                            show.legend = F) +
  scale_x_continuous(n.breaks = 10) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Number of CSA Cases - Annual Trend",
    caption="Source: Social Welfare Department"
  ) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )
#ggsave("generated/swd_csa_cases.png")

#ggplot(aes(fill=fct_relevel(CSA_Type, "Buggery","Rape","Incest","Unlawful Sexual\nIntercourse"), y=Number_of_Cases, x=Source_Year, group=Penetrative)) +

  #  
  
swd_data_type %>%
  mutate(CSA_Type = str_wrap(CSA_Type, width = 20)) %>%
  #fct_relevel(CSA_Type, "Other") %>%
  ggplot(aes(fill=fct_relevel(CSA_Type, "Other"), y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Type of CSA Cases - Annual Trend",
    caption="Source: Social Welfare Department"
  ) +
  guides(fill=guide_legend(title="Type of CSA")) +
  scale_x_continuous(n.breaks = 12) +
#  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    legend.text=element_text(size=10),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 16, color="#8C254D"),
    plot.subtitle=element_text(color="#8C254D")
  )

# SWD Victim combined graph

swd_vict_gender <- swd_csa_cases %>%
  ggplot(aes(x = Source_Year, y = Number_of_Cases, colour=Gender)) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                           nudge_x = 0.3,
                           nudge_y = 5,
                           size = 4,
                           segment.colour = NA,
                           direction = "y",
                           show.legend = F) +
  scale_x_continuous(n.breaks = 10) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Victims by Gender and Age - Annual Trend",
    subtitle="One case refers to one child"
  ) +
  scale_color_manual(values = female_male_colours) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color="#8C254D"),
    plot.subtitle=element_text(color="#8C254D")
  )

swd_vict_age <- swd_data_victim_gender_age %>%
  ggplot(aes(fill=Age, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours) +
  labs(
    y = "Population Size",
    x = "Year",
    caption="Source: Social Welfare Department"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  scale_x_continuous(n.breaks = 10) +
  ylim(0,600) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

swd_vict_gender + swd_vict_age + plot_layout(nrow = 2)

# SWD Perpetrator combined graph

swd_perp_gender <- swd_data_perpetrator_gender_age %>%
  select(Gender, Number_of_Cases, Source_Year) %>%
  group_by(Source_Year, Gender) %>%
  summarise(across(everything(), sum)) %>%
  group_by(Gender) %>%
  ggplot(aes(x = Source_Year, y = Number_of_Cases, colour=Gender)) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                            nudge_x = 0.3,
                            nudge_y = 5,
                            size = 4,
                            segment.colour = NA,
                            direction = "y",
                            show.legend = F) +
  scale_x_continuous(n.breaks = 10) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Perpetrators by Age and Gender - Annual Trend",
    subtitle="One perpetrator might have harmed/maltreated more than one victim.
One victim might be harmed/maltreated by one or more perpetrators.
Perpetrators under the category of the Unknown age group were unrelated or unidentified persons, or where the age could not be determined.") +
  scale_color_manual(values = female_male_colours) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

swd_perp_age <- swd_data_perpetrator_gender_age %>%
  select(Age_Combined, Number_of_Cases, Source_Year) %>%
  filter(Age_Combined != "NA") %>%
  ggplot(aes(fill=Age_Combined, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    caption="Source: Social Welfare Department"
  ) +
  guides(fill = guide_legend(title="Age",reverse=FALSE)) +
  scale_x_continuous(n.breaks = 10) +
  ylim(0,600) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

swd_perp_gender + swd_perp_age + plot_layout(nrow = 2)


swd_data_relationship %>%
  mutate(Relationship = str_wrap(Relationship, width = 20)) %>%
  ggplot(aes(fill=Relationship, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Victim-Perpetrator Relationship - Annual Trend",
    subtitle="Perpetrators under the category 'Unknown' were unrelated or unidentified persons, \nor where the relationship could not be determined.",
    caption="Source: Social Welfare Department"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  scale_x_continuous(n.breaks = 12) +
  #ylim(0,600) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    #legend.position="top",
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

swd_data_nature %>%
  ggplot(aes(fill=Nature_of_Case, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Nature of Cases - Annual Trend",
    subtitle="Custom data requested from SWD by TALK to highlight case assessment outcomes.",
    caption="Source: Social Welfare Department"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  scale_x_continuous(n.breaks = 10) +
  #ylim(0,600) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    legend.title=element_blank(),
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# SWD Neurodivergence - Disability

swd_data_neuro_dis %>%
  filter(Abuse_Type == "Sexual") %>%
  #  mutate(CSA_Type = str_wrap(CSA_Type, width = 20)) %>%
  ggplot(aes(fill=Neuro_Affirming_Typology, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Neurodiversity and Disability Cases - Annual Trend",
    subtitle="One child may have more than one type of neurodivergence or disability",
    caption="Source: Social Welfare Department"
  ) +
  guides(fill=guide_legend(title="Group")) +
  scale_x_continuous(n.breaks = 12) +
  ylim(0,300) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# HK Police

hkp_data_total %>%
  group_by(Source_Year) %>%
  summarise(across(c(Number_of_Cases), sum)) %>%
  ggplot(aes(x = Source_Year, y = Number_of_Cases)) +
  geom_line(color = "#10576A", size = 1.5) +
  geom_point(color = "#10576A", size = 3) +
  geom_area(fill = "#10576A", alpha = 0.3) +
  #geom_smooth() +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                            nudge_x = 0.2,
                            segment.colour = NA,
                            nudge_y = 15,
                            size = 4,
                            direction = "y",
                            show.legend = F) +
  scale_x_continuous(n.breaks = 11) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Number of CSA Cases - Annual Trend",
    caption="Source: Hong Kong Police Force"
  ) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

hkp_data_type %>%
  mutate(CSA_Type = str_wrap(CSA_Type, width = 20)) %>%
  ggplot(aes(fill=fct_relevel(CSA_Type, "Buggery","Rape","Incest","Unlawful Sexual\nIntercourse"), y=Number_of_Cases, x=Source_Year, group=Penetrative)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Type of CSA Cases - Annual Trend",
    caption="Source: Hong Kong Police Force"
  ) +
  guides(fill=guide_legend(title="Type of CSA",reverse=T)) +
  scale_x_continuous(n.breaks = 10) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# HKP Victim Gender

hkp_vict_gender <- hkp_data_victim_gender %>%
  ggplot(aes(x = Source_Year, y = Number_of_Cases, colour=Gender)) +
  geom_line(size=1.5) +
  geom_point(size=3) +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                            nudge_x = 0.3,
                            nudge_y = 5,
                            size = 4,
                            segment.colour = NA,
                            direction = "y",
                            show.legend = F) +
  scale_x_continuous(n.breaks = 10) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Victims by Gender and Age - Annual Trend",
    subtitle="A case is as a report made to the police station, may include multiple victims, aged 0-16"
  ) +
  scale_color_manual(values = female_male_colours) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# Victim Age

hkp_vict_age <- hkp_data_victim_age %>%
  drop_na(Age) %>%
  ggplot(aes(fill=Age, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours) +
  labs(
    y = "Population Size",
    x = "Year",
    caption="Source: Hong Kong Police Force"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  scale_x_continuous(n.breaks = 12) +
  ylim(0,750) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

hkp_vict_gender + hkp_vict_age + plot_layout(nrow = 2)

hkp_data_relationship %>%
  mutate(Relationship = str_wrap(Relationship, width = 20)) %>%
  ggplot(aes(fill=Relationship, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Victim-Perpetrator Relationship - Annual Trend",
    #subtitle="Perpetrators under the category of the Unknown age group were unrelated or unidentified persons, \nor where the age could not be determined.",
    caption="Source: Hong Kong Police Force"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  scale_x_continuous(n.breaks = 12) +
  #ylim(0,600) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    #legend.position="top",
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# EDB

edb_data_total %>%
  mutate(Action = str_wrap(Action, width = 20)) %>%
  ggplot(aes(fill=Action, y=Number, x=Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Actions taken related to teacher conduct - Annual Trend",
    subtitle="For cases involving indecent, boundary-crossing or sexual behaviour",
    caption="Source: Education Bureau"
  ) +
  guides(fill=guide_legend(title="")) +
  #scale_x_continuous(n.breaks = 12) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# DOJ

number_csa_charges <- inspect_doj_data %>%
  group_by(Source_Year) %>%
  summarise(across(c(Number_of_Charges), sum)) %>%
  ggplot(aes(x = Source_Year, y = Number_of_Charges)) +
  geom_line(color = "#8C254D", size = 1.5) +
  geom_point(color = "#8C254D", size = 3) +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                            nudge_x = 0.3,
                            nudge_y = 5,
                            size = 4,
                            segment.colour = NA,
                            direction = "y",
                            show.legend = F) +
  scale_x_continuous(n.breaks = 10) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Number of CSA Charges - Annual Trend",
    caption="Source: Department of Justice"
  ) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

csa_charges_offences <- 
inspect_doj_data %>%
  mutate(Offence = str_wrap(Offence, width = 20)) %>%
  ggplot(aes(fill=fct_relevel(Offence, "intercourse with\ngirl under 16", "intercourse with\ngirl under 13","homosexual buggery\nwith or by man under\n16"), y=Number_of_Charges, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Offences for CSA Charges - Annual Trend",
    #subtitle="Perpetrators under the category of the Unknown age group were unrelated or unidentified persons, or where the age could not be determined.",
    caption="Source: Department of Justice"
  ) +
  guides(fill = guide_legend(title="Offence",reverse=F)) +
  scale_x_continuous(n.breaks = 10) +
  ylim(0,200) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="right",
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

number_csa_charges + csa_charges_offences + plot_layout(nrow = 2)

graph_doj_outcomes <- inspect_doj_data_outcomes %>%
  ggplot(aes(fill=Outcome, y=Number, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  guides(fill = guide_legend(reverse=TRUE)) +
labs(
  y = "Population Size",
  x = "Year",
  #title="Outcome of CSA Cases - Annual Trend",
  #subtitle="Perpetrators under the category of the Unknown age group were unrelated or unidentified persons, or where the age could not be determined.",
  caption="Source: Department of Justice"
) +
  guides(fill = guide_legend(reverse=TRUE)) +
  scale_x_continuous(n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="right",
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

graph_doj_outcomes

graph_doj_sentences <- inspect_doj_data_sentences %>%
  ggplot(aes(fill=Sentence, y=Number, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = rev(custom_colours_long),na.translate = F) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Offences for CSA Charges** Annual Trend",
    #subtitle="Perpetrators under the category of the Unknown age group were unrelated or unidentified persons, or where the age could not be determined.",
    caption="Source: Department of Justice"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  labs(
    y = "Population Size",
    x = "Year",
   # title="Sentencing in CSA Cases - Annual Trend",
    #subtitle="Perpetrators under the category of the Unknown age group were unrelated or unidentified persons, or where the age could not be determined.",
    caption="Source: Department of Justice"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  scale_x_continuous(n.breaks = 12) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="right",
    legend.text=element_text(size=10),
    plot.title = element_text(family = "special", size = 16, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

graph_doj_sentences

graph_doj_outcomes + graph_doj_sentences

# ECSAF Data

graph_ecsaf_calls <- ecsaf_data_total %>%
  ggplot(aes(x=Source_Year, y=Number_of_Calls)) +
  geom_col(fill="#B66F84") +
  scale_fill_manual(values = custom_colours_long) +
  scale_color_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Number of Calls** Annual Trend",
    #subtitle="Perpetrators under the category of the Unknown age group were unrelated or unidentified persons, or where the age could not be determined.",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  ylim(0,850) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="right",
    plot.title = element_text(family = "special", size = 18),
  )

graph_ecsaf_cases <- ggplot(ecsaf_data_total) +
  geom_point(aes(x=Source_Year, y=Number_of_Cases, color="Number of Cases"), size = 3) +
  geom_line(aes(x=Source_Year, y=Number_of_Cases, group = 1, color="Number of Cases"), size = 1.5) +
  geom_area(aes(x=Source_Year, y=Number_of_Cases, group = 1, color="Number of Cases"), fill = "#8C254D", alpha = 0.3) +
  geom_line(aes(x=Source_Year, y=Number_of_Cases_Referred, group = 1, color="Number of Cases Referred"), size = 1.5) +
  geom_point(aes(x=Source_Year, y=Number_of_Cases_Referred, color="Number of Cases Referred"), size = 3) +
  geom_area(aes(x=Source_Year, y=Number_of_Cases_Referred, group = 1, color="Number of Cases Referred"), fill = "#dfd012", alpha = 0.3) +  
  scale_fill_manual(values = custom_colours_long) +
  scale_color_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Number of Cases** Annual Trend",
    #subtitle="Perpetrators under the category of the Unknown age group were unrelated or unidentified persons, or where the age could not be determined.",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="right",
    legend.title=element_blank(),
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

graph_ecsaf_calls + graph_ecsaf_cases + plot_layout(nrow = 2)

ecsaf_data_type %>%
  mutate(Type_2 = str_wrap(Type_2, width = 20)) %>%
  ggplot(aes(fill=Type_2, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Types of CSA** Annual Trend",
    subtitle="Some cases involve more than one type of abuse",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  guides(fill=guide_legend(title="")) +
  #scale_x_continuous(n.breaks = 12) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# ECSAF Victim Gender and Age Graph

graph_ecsaf_data_victim_gender <- ecsaf_data_victim_gender %>%
  group_by(Source_Year) %>%
  ggplot(aes(x = Source_Year, y = Number_of_Victims, colour=Gender, group=Gender)) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                            nudge_x = 0.2,
                            segment.colour = NA,
                            nudge_y = 5,
                            size = 4,
                            direction = "y",
                            show.legend = F) +
  
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Victims by Gender** Annual Trend",
    subtitle="(One case refers to one child)",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  scale_color_manual(values = female_male_colours) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

graph_ecsaf_data_victim_age <- ecsaf_data_victim_age %>%
  ggplot(aes(fill=Age, y=Number_of_Victims, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Victims by Age** Annual Trend",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
 # scale_x_continuous(n.breaks = 12) +
  ylim(0,120) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

graph_ecsaf_data_victim_gender + graph_ecsaf_data_victim_age + plot_layout(nrow = 2)

# ECSAF Perpetrator

graph_ecsaf_data_perp_gender <- ecsaf_data_perpetrator_gender %>%
  group_by(Source_Year) %>%
  ggplot(aes(x = Source_Year, y = Number_of_Perpetrators, colour=Gender, group=Gender)) +
  geom_line(size = 1.5) +
  geom_point(size = 3) +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                            nudge_x = 0.2,
                            segment.colour = NA,
                            nudge_y = 5,
                            size = 4,
                            direction = "y",
                            show.legend = F) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Perpetrators by Gender** Annual Trend",
    subtitle="One perpetrator might have harmed/abused more than one victim, and one victim could be harmed/abused by more than one perpetrator",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  scale_color_manual(values = female_male_colours) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

graph_ecsaf_data_perp_age <- ecsaf_data_perpetrator_age %>%
  ggplot(aes(fill=Age, y=Number_of_Perpetrators, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Perpetrators by Age** Annual Trend",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  guides(fill = guide_legend(reverse=TRUE)) +
  # scale_x_continuous(n.breaks = 12) +
  ylim(0,120) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

graph_ecsaf_data_perp_gender + graph_ecsaf_data_perp_age + plot_layout(nrow = 2)

ecsaf_data_perpetrator_relationship %>%
  mutate(Type_2 = str_wrap(Relationship_1, width = 20)) %>%
  ggplot(aes(fill=Relationship_1, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Victim-Perpetrator Relationship** Annual Trend",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  guides(fill=guide_legend(title="")) +
  #scale_x_continuous(n.breaks = 12) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

ecsaf_data_location %>%
  mutate(Type_2 = str_wrap(Location_1, width = 20)) %>%
  ggplot(aes(fill=Location_1, y=Number_of_Cases, x=Source_Year)) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_manual(values = custom_colours_long) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Location of Abuse** Annual Trend",
    subtitle="Locations have been classified into broader categories to facilitate interpretation. Some cases involved more than one location.",
    caption="Source: End Child Sexual Abuse Foundation"
  ) +
  guides(fill=guide_legend(title="")) +
  #scale_x_continuous(n.breaks = 12) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

aca_combined %>%
  group_by(Source_Year) %>%
  ggplot() +
  geom_line(aes(x = Source_Year, y = Number_of_Cases, colour="Cases reported to ACA", group = 1), size = 1.5) +
  geom_point(aes(x = Source_Year, y = Number_of_Cases, colour="Cases reported to ACA", group = 1), size = 3) +
  geom_area(aes(x = Source_Year, y = Number_of_Cases, colour="Cases reported to ACA", group = 1), fill = "#bcbcbc", alpha = 0.3, show.legend =F) +
  geom_line(aes(x = Source_Year, y = Investigation, colour="Cases investigated", group = 1), size = 1.5) +
  geom_point(aes(x = Source_Year, y = Investigation, colour="Cases investigated", group = 1), size = 3) +
  geom_area(aes(x = Source_Year, y = Investigation, colour="Cases investigated", group = 1), fill = "#10576A", alpha = 0.3, show.legend =F) +
  geom_line(aes(x = Source_Year, y = Casework, colour="Cases followed up \npost investigation", group = 1), size = 1.5) +
  geom_point(aes(x = Source_Year, y = Casework, colour="Cases followed up \npost investigation", group = 1), size = 3) +
  geom_area(aes(x = Source_Year, y = Casework, colour="Cases followed up \npost investigation", group = 1), fill = "#8C254D", alpha = 0.3, show.legend =F) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="**Number of CSA Cases** Annual Trend",
    caption="Source: Against Child Abuse"
  ) +
  scale_color_manual(values = female_male_colours) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    legend.position="top",
    legend.title=element_blank(),
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# CSD

csd_data %>%
  #mutate(Action = str_wrap(Action, width = 20)) %>%
  ggplot(aes(y=Number_of_Persons, x=Source_Year)) +
  geom_col(fill = "#8C254D") +
  scale_fill_manual(values = "#8C254D") +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Persons in Custody for CSA-related offences - Annual Trend",
    subtitle="Treatment at the Evaluation Treatment Unit",
    caption="Source: Correctional Services Department"
  ) +
  guides(fill=guide_legend(title="")) +
  #scale_x_continuous(n.breaks = 12) +
  #  scale_y_continuous(breaks = waiver(), n.breaks = 10) +
  geom_text(aes(label = after_stat(y), group = Source_Year), stat = 'summary', fun = sum, vjust = -0.7) +
  theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle=element_text(color=c_burgundy)
  )

# Further extra graphs - SWD all types of abuse compared

swd_data_total %>%
  select(-Department, -Data_Source, -Page) %>%
  group_by(Abuse_Type, Source_Year) %>%
  group_modify(~ .x %>% adorn_totals()) %>%
  filter(Gender == "Total") %>%
  ggplot(aes(x=Source_Year, y=Number_of_Cases, color=Abuse_Type)) +
  #geom_area(alpha = 0.3) +
  geom_point(size=3) +
  geom_line(size=1.5) +
  scale_x_continuous(n.breaks = 10) +
  guides(fill=guide_legend(title="")) +
  guides(color=guide_legend(title="")) +
  scale_fill_manual(values = custom_colours2) +
  scale_color_manual(values = custom_colours2) +
  ggrepel::geom_label_repel(aes(label = scales::comma(after_stat(y))),
                            nudge_x = 0.4,
                            segment.colour = NA,
                            nudge_y = 15,
                            size = 4,
                            direction = "y",
                            show.legend = F) +
  labs(
    y = "Population Size",
    x = "Year",
    #title="Persons in Custody for CSA-related offences - Annual Trend",
    #subtitle="Treatment at the Evaluation Treatment Unit",
    caption="Source: Social Welfare Department"
  ) +
    theme(
    panel.background = element_rect(fill = "#ffffffff"),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(color = "#DBD5CD", size = 0.3),
    axis.ticks.length.y = unit(0, "mm"),
    axis.ticks.length.x = unit(2, "mm"),
    axis.title = element_blank(),
    legend.position="top",
    #axis.text.y = element_blank(),
    text = element_text(family="special"),
    axis.line.x.bottom = element_line(color = "black"),
    plot.title = element_text(family = "special", size = 18, color=c_burgundy),
    plot.subtitle = element_text(color=c_burgundy)
  )
