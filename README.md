# ugacooq_data_pipeline 
Automated data pipeline for collecting, storing, and processing community member data from Google Sheets into a structured MSSQL database.

<p align="center">
  <img src="images/ugacooq_pic.png" alt="Ugandan Flag" width="250"/>
</p>

## Project Overview
This project implements an **automated data pipeline** for managing community member registrations stored in Google Sheets. As the community grows, the Google Sheet has become increasingly difficult to maintain, leading to **duplicate entries, inconsistent contact information, and outdated records**.  

The pipeline solves these issues by ingesting raw data into a **Bronze-Silver-Gold architecture**:

- **Bronze Layer:** Stores raw data as-is for audit and traceability.  
- **Silver Layer:** Cleans, standardizes, and deduplicates records.  
- **Gold Layer:** Aggregated, analysis-ready tables that feed business intelligence tools like **Power BI**.  

This ensures a **single source of truth** for member data, enabling more accurate reporting and timely updates.



## Business Problem
Currently, the Google Sheet faces multiple operational challenges:  

- **Duplicate Registrations:** Members registering more than once with different emails or contact details.  
- **Outdated Information:** Inability to easily identify members who need to update their details.  
- **Scalability:** Manual updates are time-consuming as the number of members grows.  

Without a structured data pipeline, reporting and analytics become unreliable, slowing decision-making for community management.


## Solution & Business Impact
The pipeline enables:  

- **Accurate member tracking:** Deduplication and standardization of member records.  
- **Updated reporting:** Power BI dashboards fed by clean and aggregated data.  
- **Automation:** Reduces manual intervention and errors in data handling.  
- **Scalable architecture:** Ready to handle increasing volume of registrations and updates.  

This approach ensures community management has **reliable, actionable insights**, allowing for better decision-making and improved member engagement.


## Tools & Technologies
- **Python**: Google Sheets API integration and data ingestion  
- **MSSQL Server**: Bronze, Silver, Gold schemas  
- **SSIS**: ETL automation for pipeline scheduling  
- **Power BI**: Dashboarding and reporting  
- **GitHub**: Version control and Agile project management  


## Agile Management
The project follows **Scrum methodology**, with tasks tracked using **GitHub Project boards**. Each sprint delivers a small, testable increment, allowing continuous feedback and iterative improvement.


