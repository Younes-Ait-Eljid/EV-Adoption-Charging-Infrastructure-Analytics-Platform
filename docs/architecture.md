# Architecture

## Overview

The project uses a layered Databricks Lakehouse architecture to separate raw source data, validated data, and business-ready analytical data.

```text
                         PUBLIC DATA SOURCES
                                  |
             +--------------------+--------------------+
             |                    |                    |
             v                    v                    v
      EV Population         EV History        Charging Stations
             |                    |                    |
             +--------------------+--------------------+
                                  |
                                  v
                              BRONZE
                       Raw source datasets
                                  |
                                  v
                       DATA QUALITY CHECKS
                                  |
                                  v
                              SILVER
                    Cleaned / standardized /
                         validated datasets
                                  |
                                  v
                               GOLD
                     Business-ready analytical
                              tables
                                  |
                  +---------------+---------------+
                  |               |               |
                  v               v               v
                 SQL          Dashboard         Genie
                  |                               |
                  +---------------+---------------+
                                  |
                                  v
                         Business Insights
```

## Architecture Principle

The project uses a simple principle:

> **Bronze = what we received**  
> **Silver = what we trust**  
> **Gold = what the business uses**

---

## Bronze Layer

The Bronze layer preserves the original source datasets with minimal transformation.

Tables:

- `bronze_ev_population`
- `bronze_ev_history`
- `bronze_charging_stations`

The purpose of Bronze is to maintain source fidelity and provide a reproducible starting point for downstream processing.

---

## Data Quality Layer

Before creating Silver tables, the raw datasets are inspected for:

- Missing values
- Duplicate identifiers
- Unexpected categories
- Invalid or malformed records
- Data-type problems
- Geographic anomalies
- Inconsistent totals
- Missing charging-port information
- Potentially misleading zero values

These checks determine how records should be handled rather than applying cleaning rules blindly.

---

## Silver Layer

The Silver layer contains cleaned and validated data suitable for downstream analytical processing.

### `silver_ev_population`

Standardizes EV registration data, including:

- Vehicle identifiers
- Manufacturer and model
- Model year
- EV type
- Geography
- Electric range

Electric-range values of zero associated with records whose battery range had not been researched are converted to `NULL` to represent unknown values accurately.

### `silver_ev_history`

Transforms historical monthly counts into analytical data types and validates:

**BEV Count + PHEV Count = EV Total**

### `silver_charging_stations`

Filters the alternative fueling dataset to electric charging infrastructure and excludes records without valid station identifiers.

Charging-port counts are standardized into Level 1, Level 2, DC Fast, and total reported EV ports.

---

## Gold Layer

The Gold layer contains business-ready analytical tables.

### `gold_ev_market`

Manufacturer and EV-type analysis.

### `gold_ev_models`

Vehicle model, model year, EV type, population, dataset share, and electric-range analysis.

### `gold_ev_growth`

Monthly EV population with month-over-month and year-over-year growth metrics.

### `gold_ev_geography`

EV population and EV-type composition by geography.

### `gold_charging_infrastructure`

Currently available charging stations and reported charging ports by region.

### `gold_ev_charging_ratio`

Combines Washington EV population with currently available charging infrastructure to calculate screening metrics such as EVs per station and EVs per charging port.

---

## Consumption Layer

### SQL

Gold tables provide the source of truth for business analysis and validation.

### Databricks Dashboard

The dashboard contains three analytical pages:

1. Executive Overview
2. EV Market
3. Charging Infrastructure

### Databricks Genie

Genie provides natural-language access to the Gold layer.

Genie is supplied with business definitions and analytical rules so that questions are interpreted using the correct geographic scope and metric definitions.

Its answers are validated against trusted SQL before being accepted as analytical conclusions.

---

## Design Benefits

The layered architecture provides:

- Separation between raw and analytical data
- Reproducible transformations
- Explicit data-quality decisions
- Reusable business metrics
- Consistent dashboard calculations
- A trusted semantic foundation for AI-assisted analytics
- Easier validation and troubleshooting