# TALK Hong Kong Prevalence Report - Data and script files

This is the readme to accompany the dataset & R-Scripts, which are stored as a component of the project on osf.io: <https://osf.io/axy69/>

This component consists of a number of CSV files and R scripts. This file breaks down what is included in this component, and how it can be used.

## CSV files information

They are kept in the "data" folder. These are manually compiled from publicly available sources from:

- Hong Kong Social Welfare Department: <https://www.swd.gov.hk/en/pubsvc/family/fcw_info/fcwdocument/cprstat/index.html>
- Against Child Abuse (ACA, NGO): <https://aca.org.hk/en/quarterly>
- End Child Sexual Abuse Foundation (ECSAF, NGO): <https://www.ecsaf.org.hk/en-hk/annual_reports/>

Additionally, custom data requests were made to a number of governmental departments, available here: <https://accessinfo.hk/en/user/taura_edgar/requests>

These CSV files contain information described in the codebook below.

## Codebook

All CSV files have a similar breakdown and contain the following values:

| Column                        | Description                                                                                                                                |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Case, Case_Nature, etc.       | What kind of abuse is listed, as some datasets contain four types, whilst others only contain CSA or a subsection of CSA-type of offences. |
| CSA_Type, Type_of_Abuse, etc. | The type of Child Sexual Abuse (or other types of abuse)                                                                                   |
| Number_of_Cases, Number, etc. | Numerical data on how many registered or reported cases there were in the timespan.                                                        |
| Source_Year, Year, etc.       | The year or year-range (e.g. 2024 or 2024-2025)                                                                                            |
| Department, NGO, etc.         | The governmental department or NGO from which the data was obtained.                                                                       |
| Data_Source, Source, etc.     | For internal reference, these are the downloaded PDF files or compiled TXT files from which the data was obtained.                         |
| Page, etc.                    | The page number of the downloaded PDF files, where available.                                                                              |

## R scripts information

The R scripts (the .R and .Rmd files) are kept in the main component/repository folder. These scripts require the following packages to function:

- tidyverse
- ggtext
- showtext
- patchwork
- janitor
- htmlwidgets (for the web-based scripts)
- plotly (for the web-based scripts)

## License for R scripts

The scripts and CSV files are made available using the permissive MIT License (see LICENSE.md).

## References

  Firke S (2024). _janitor: Simple Tools for Examining and Cleaning Dirty Data_.
  doi:10.32614/CRAN.package.janitor <https://doi.org/10.32614/CRAN.package.janitor>, R package
  version 2.2.1, <https://CRAN.R-project.org/package=janitor>.

  Pedersen T (2025). _patchwork: The Composer of Plots_. doi:10.32614/CRAN.package.patchwork
  <https://doi.org/10.32614/CRAN.package.patchwork>, R package version 1.3.2,
  <https://CRAN.R-project.org/package=patchwork>.

  Posit team (2025). RStudio: Integrated Development Environment for R. Posit Software, PBC, Boston,
  MA. URL http://www.posit.co/.

  R Core Team (2025). _R: A Language and Environment for Statistical Computing_. R Foundation for
  Statistical Computing, Vienna, Austria. <https://www.R-project.org/>.

  Sievert, C.. Interactive Web-Based Data Visualization with R, plotly, and shiny. Chapman and
  Hall/CRC Florida, 2020.

  Qiu Y, details. aotisSfAf (2024). _showtext: Using Fonts More Easily in R Graphs_.
  doi:10.32614/CRAN.package.showtext <https://doi.org/10.32614/CRAN.package.showtext>, R package
  version 0.9-7, <https://CRAN.R-project.org/package=showtext>.

  Vaidyanathan R, Xie Y, Allaire J, Cheng J, Sievert C, Russell K (2023). _htmlwidgets: HTML Widgets
  for R_. doi:10.32614/CRAN.package.htmlwidgets <https://doi.org/10.32614/CRAN.package.htmlwidgets>,
  R package version 1.6.4, <https://CRAN.R-project.org/package=htmlwidgets>.

  Wickham H, Averick M, Bryan J, Chang W, McGowan LD, François R, Grolemund G, Hayes A, Henry L,
  Hester J, Kuhn M, Pedersen TL, Miller E, Bache SM, Müller K, Ooms J, Robinson D, Seidel DP, Spinu
  V, Takahashi K, Vaughan D, Wilke C, Woo K, Yutani H (2019). “Welcome to the tidyverse.” _Journal
  of Open Source Software_, *4*(43), 1686. doi:10.21105/joss.01686
  <https://doi.org/10.21105/joss.01686>.

  Wilke C, Wiernik B (2022). _ggtext: Improved Text Rendering Support for 'ggplot2'_.
  doi:10.32614/CRAN.package.ggtext <https://doi.org/10.32614/CRAN.package.ggtext>, R package version
  0.1.2, <https://CRAN.R-project.org/package=ggtext>.