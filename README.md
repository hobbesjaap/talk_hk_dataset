# talk_hk

This is the readme to accompany the dataset & r-script component on osf.io: URL here

This component consists of a number of CSV files and R scripts. This file breaks down what is included in this component, how it can be used

## CSV files information

They are kept in the "data" folder.

These are manually compiled from publicly available sources from:

List agencies / NGOs

and additionally

custom data requests, available here: X

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

They are kept one section lower.

Make note of which R packages are required.

## License for R scripts

MIT License for the scripts themselves.

## References

R references again here.