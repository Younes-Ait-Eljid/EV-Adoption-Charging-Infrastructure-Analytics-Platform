# Genie Test Questions

Databricks Genie was tested using six representative business questions.

The questions were selected to test numerical accuracy, aggregation logic, business context, time-series analysis, cross-domain metrics, and the ability to recognize data limitations.

## Test 1 — Manufacturer Analysis

> Which manufacturer has the largest EV population in the dataset?

**Purpose:** Test manufacturer aggregation and dataset-share interpretation.

---

## Test 2 — EV Composition

> What percentage of registered EVs are BEVs?

**Purpose:** Test KPI calculation and BEV/PHEV composition.

---

## Test 3 — Historical Growth

> How has the EV population changed over time?

**Purpose:** Test time-series analysis, MoM/YoY metrics, and narrative interpretation.

---

## Test 4 — EV / Charging Ratio

> How many EVs are there per charging port in Washington?

**Purpose:** Test whether Genie uses the curated cross-domain Gold table and preserves the screening-metric definition.

---

## Test 5 — Charging Infrastructure

> Which region has the most available charging stations?

**Purpose:** Test geographic charging infrastructure analysis.

---

## Test 6 — Data Limitation

> Which region has the highest EV growth?

**Purpose:** Test whether Genie recognizes that the available data does not contain historical EV observations by region.

A correct response should not confuse current EV population with EV growth.

---

# Validation Approach

Each response was evaluated using:

**Business Question → Genie Answer → Generated SQL → Trusted SQL → Business Context → Analyst Validation**

Detailed results are documented in [`validation.md`](validation.md).