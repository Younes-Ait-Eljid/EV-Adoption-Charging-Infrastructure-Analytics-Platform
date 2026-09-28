# Business Problem

## Project Overview

The **EV Adoption & Charging Infrastructure Analytics Platform** is an end-to-end Databricks analytics project designed to analyze electric vehicle adoption, market composition, historical growth, and charging infrastructure.

The project combines multiple public datasets and transforms them through a Bronze, Silver, and Gold architecture before making the resulting analytical data available through SQL, Databricks Dashboards, and Databricks Genie.

## Business Objective

The objective is to create a trusted analytical environment that can help stakeholders understand:

- How the registered EV population has changed over time.
- The composition of Battery Electric Vehicles (BEVs) and Plug-in Hybrid Electric Vehicles (PHEVs).
- Which manufacturers and vehicle models have the largest registered populations.
- How currently available charging infrastructure is distributed geographically.
- The relationship between registered EV population and available charging infrastructure in Washington.
- Which analytical questions cannot reliably be answered with the available data.

## Core Business Questions

The project focuses on six representative questions:

1. Which manufacturers have the largest EV populations?
2. What is the BEV vs PHEV composition?
3. Which EV models have the largest registered populations?
4. How has the EV population changed over time?
5. How is available charging infrastructure distributed across regions?
6. What is the current EV-to-charging-port picture in Washington?

## Data Sources

The project uses three public datasets:

### Electric Vehicle Population Data

Current registered Battery Electric Vehicles and Plug-in Hybrid Electric Vehicles from the Washington State Department of Licensing.

### Electric Vehicle Population Size History

Monthly historical EV population counts used to analyze changes in BEV, PHEV, and total EV registrations over time.

### Alternative Fueling Stations

Alternative fueling infrastructure data from the U.S. Department of Energy's Alternative Fuels Data Center. The analytical layer filters this dataset to electric charging stations.

## Geographic Scope

An important limitation of the analysis is that the EV population dataset primarily represents **Washington State vehicle registrations**.

Washington accounts for approximately **99.74% of the EV population records** in the dataset.

Therefore, metrics derived from this dataset must not be interpreted as comprehensive U.S. EV market statistics.

For example, Tesla representing approximately 41% of the EV records describes its share **within this dataset**, not Tesla's national U.S. EV market share.

The charging infrastructure dataset has a broader geographic scope and includes U.S. states, Canadian provinces, and other regions.

## Analytical Approach

The project follows a layered Lakehouse architecture:

**Bronze → Silver → Gold**

**Bronze** preserves the source data.

**Silver** contains cleaned, standardized, and validated records.

**Gold** contains business-ready analytical tables designed for SQL analysis, dashboards, and AI-assisted analytics.

The resulting Gold layer is used by:

- SQL business analysis
- Databricks Dashboards
- Databricks Genie

## AI-Assisted Analytics

Databricks Genie is included to demonstrate natural-language self-service analytics.

However, AI-generated answers are not assumed to be correct automatically.

The validation process follows:

**Business question → Genie answer → Generated SQL → Trusted analytical logic → Context validation → Business interpretation**

This demonstrates that AI can make analytical data more accessible while the analyst remains responsible for data quality, metric definitions, analytical context, and validation.