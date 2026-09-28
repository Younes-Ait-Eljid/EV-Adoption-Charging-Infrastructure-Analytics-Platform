# ⚡ EV Adoption & Charging Infrastructure Analytics Platform

An end-to-end **Databricks analytics project** analyzing electric vehicle adoption, historical growth, market composition, and charging infrastructure using public EV and charging-station datasets.

The project demonstrates a complete analytical workflow:

**Raw Data → Data Quality → Bronze/Silver/Gold → SQL Analysis → Databricks Dashboard → Genie AI → AI Validation**

---

## 🎯 Project Objective

The goal was to build a trusted analytical environment for exploring EV adoption and charging infrastructure while demonstrating how traditional analytics and AI-assisted self-service analytics can work together.

The project answers six core business questions:

1. Which manufacturers have the largest EV populations?
2. What is the BEV vs PHEV composition?
3. Which EV models have the largest registered populations?
4. How has the EV population changed over time?
5. How is available charging infrastructure distributed across regions?
6. What is the current EV-to-charging-port picture in Washington?

---

## 🏗️ Architecture

```text
                    PUBLIC DATA SOURCES
                            │
          ┌─────────────────┼─────────────────┐
          ↓                 ↓                 ↓
    EV Population      EV History      Charging Stations
          │                 │                 │
          └─────────────────┼─────────────────┘
                            ↓
                         BRONZE
                        Raw Data
                            ↓
                    Data Quality Checks
                            ↓
                         SILVER
                  Cleaned & Validated
                            ↓
                          GOLD
                 Business-Ready Tables
                            │
              ┌─────────────┼─────────────┐
              ↓             ↓             ↓
             SQL        Dashboard       Genie AI
              │                           │
              └─────────────┬─────────────┘
                            ↓
                     Validated Insights
```

The project follows the principle:

> **Bronze = what we received**  
> **Silver = what we trust**  
> **Gold = what the business uses**

---

## 🛠️ Technologies

- Databricks
- Databricks SQL
- Delta / Lakehouse architecture
- SQL
- Databricks Dashboards
- Databricks Genie
- Git
- GitHub

---

## 📊 Data Sources

Three public datasets were integrated.

### Electric Vehicle Population Data

Current registered Battery Electric Vehicles (BEVs) and Plug-in Hybrid Electric Vehicles (PHEVs) from the Washington State Department of Licensing.

**299,705 EV records**

### Electric Vehicle Population Size History

Monthly historical EV population observations.

**116 monthly observations — January 2017 to August 2026**

### Alternative Fueling Stations

Alternative fueling infrastructure data from the U.S. Department of Energy Alternative Fuels Data Center.

The analytical pipeline filters the source to electric charging infrastructure.

**104,815 validated electric charging station records**

---

## ⚠️ Geographic Scope

The EV population dataset primarily represents **Washington State vehicle registrations**.

Washington accounts for approximately **99.74% of the EV population records** in the dataset.

Therefore, manufacturer shares and other EV population metrics in this project should **not** be interpreted as national U.S. EV market statistics.

The charging infrastructure dataset has broader geographic coverage, including U.S. states, Canadian provinces, and other regions.

For this reason, combined EV population and charging infrastructure analysis is restricted to **Washington State**.

---

## 🥉 Bronze Layer

The Bronze layer preserves the source datasets:

```text
bronze_ev_population
bronze_ev_history
bronze_charging_stations
```

Initial exploration and quality checks were performed before applying transformations.

---

## 🥈 Silver Layer

The Silver layer contains cleaned and validated analytical data:

```text
silver_ev_population
silver_ev_history
silver_charging_stations
```

Important cleaning decisions included:

- Validating unique vehicle and charging-station identifiers
- Standardizing EV types
- Converting unresearched zero electric-range values to `NULL`
- Validating historical BEV + PHEV totals
- Filtering charging data to electric stations
- Excluding charging records without valid station identifiers
- Preserving unknown charging-port counts instead of automatically treating them as zero

---

## 🥇 Gold Layer

Six business-ready analytical tables were created:

```text
gold_ev_market
gold_ev_models
gold_ev_growth
gold_ev_geography
gold_charging_infrastructure
gold_ev_charging_ratio
```

These tables provide the analytical foundation for SQL queries, dashboard metrics, and Genie.

---

## 🔎 Key Findings

### EV Population

The dataset contains:

- **299,705 EVs**
- **241,724 BEVs**
- **57,981 PHEVs**

EV composition:

- **80.65% BEV**
- **19.35% PHEV**

---

### EV Market

Tesla has the largest registered EV population in the dataset:

**122,981 vehicles — approximately 41.03% of dataset records**

The largest individual models include:

| Model | Registered EVs |
|---|---:|
| Tesla Model Y | 66,545 |
| Tesla Model 3 | 39,391 |
| Nissan Leaf | 13,453 |
| Tesla Model S | 7,873 |
| Chevrolet Bolt EV | 7,642 |

These figures describe the project dataset and should not be interpreted as national U.S. market share.

---

### EV Growth

EV population increased from:

**22,424 in January 2017**

to:

**299,705 in August 2026**

representing more than a **13× increase** over the historical period.

Recent YoY growth remained positive but decelerated:

- January 2026: **20.63%**
- June 2026: **15.71%**
- August 2026: **11.92%**

August 2026 recorded a **-0.31% MoM change**, illustrating why short-term movement should be evaluated alongside longer-term trends.

---

### Charging Infrastructure

The Gold analytical layer contains:

**102,393 currently available charging stations**

with:

**330,146 reported charging ports**

California contains the largest number of available charging stations in the charging infrastructure dataset.

---

### Washington EV / Charging Ratio

Washington contains:

- **298,916 registered EVs**
- **3,375 available charging stations**
- **9,846 reported available charging ports**

Resulting screening metrics:

**88.57 EVs per available station**

**30.36 EVs per available charging port**

These ratios are screening indicators and should not be interpreted as direct evidence of charging congestion or infrastructure shortage.

---

## 📈 Databricks Dashboard

An interactive three-page dashboard was built on the Gold analytical layer.

### Executive Overview

- Total EVs
- BEV Share
- PHEV Share
- EV Population Growth
- Top EV Manufacturers

### EV Market

- Top EV Models
- BEV vs PHEV Composition
- EV Model Details

### Charging Infrastructure

- Available Charging Stations
- Total Charging Ports
- EVs per Charging Port
- Charging Infrastructure by Region

Dashboard screenshots are available in [`dashboard/screenshots/`](dashboard/screenshots/).

---

## 🤖 Databricks Genie

Databricks Genie was connected to the Gold analytical layer to provide natural-language access to the project's analytical data.

Genie was provided with explicit instructions covering:

- Geographic scope
- Table grain
- KPI definitions
- Dataset limitations
- Growth definitions
- Charging infrastructure interpretation

Six representative business questions were tested.

---

## 🧪 Validating AI-Generated Analytics

AI-generated answers were **not assumed to be correct automatically**.

Each response was evaluated using:

> **Business Question → Genie Answer → Generated SQL → Trusted SQL → Business Context → Analyst Validation**

Most tested questions produced correct results.

The validation process also identified cases where analyst review remained necessary.

For example:

- A numerically correct manufacturer result still required clarification that the percentage represented **dataset share**, not national market share.
- A historical-growth answer used appropriate SQL but included narrative interpretation that went beyond what the data directly established.
- When asked which region had the highest EV growth, Genie correctly recognized that the available data could **not support regional historical growth analysis** rather than inventing an answer.

This demonstrates an important principle of AI-assisted analytics:

> AI can make analytical data more accessible, but trusted analytics still requires well-designed data models, clear metric definitions, business context, and human validation.

---

## 📁 Repository Structure

```text
ev-databricks-analytics/
│
├── README.md
│
├── docs/
│   ├── business_problem.md
│   ├── architecture.md
│   ├── data_dictionary.md
│   ├── data_quality.md
│   └── kpi_definitions.md
│
├── sql/
│   ├── 01_exploration.sql
│   ├── 02_quality_checks.sql
│   ├── 03_silver_transformations.sql
│   ├── 04_gold_transformations.sql
│   ├── 05_business_analysis.sql
│   └── 06_validation.sql
│
├── dashboard/
│   ├── README.md
│   └── screenshots/
│       ├── executive_overview.png
│       ├── ev_market.png
│       └── charging_infrastructure.png
│
└── genie/
    ├── instructions.md
    ├── questions.md
    ├── validation.md
    └── screenshots/
```

---

## 📚 Documentation

Detailed project documentation is available in:

- [`Business Problem`](docs/business_problem.md)
- [`Architecture`](docs/architecture.md)
- [`Data Dictionary`](docs/data_dictionary.md)
- [`Data Quality`](docs/data_quality.md)
- [`KPI Definitions`](docs/kpi_definitions.md)

---

## 💡 What This Project Demonstrates

This project demonstrates hands-on experience with:

- Databricks analytics workflows
- Bronze / Silver / Gold Lakehouse architecture
- SQL data exploration
- Data-quality validation
- Data cleaning and transformation
- Analytical data modeling
- Window functions and time-series analysis
- KPI definition and governance
- Dashboard development
- Self-service analytics
- Databricks Genie
- AI-generated SQL validation
- Translating analytical results into business context

Most importantly, the project demonstrates the full analytical workflow from **raw data to validated business insight**.