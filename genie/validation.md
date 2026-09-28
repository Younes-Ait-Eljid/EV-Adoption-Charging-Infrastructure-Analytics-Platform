# Genie Validation

## Purpose

This document records the validation of Databricks Genie responses
against trusted SQL logic and the analytical definitions established in
the Gold layer.

The objective is not to assume that AI-generated answers are
automatically correct, but to verify that Genie:

* selects the appropriate Gold table
* respects table grain
* applies the correct metric definitions
* understands the geographic scope
* handles ambiguous questions appropriately
* produces results consistent with trusted SQL
* does not overstate what the available data can support

---

## Validation Summary

| # | Business Question | Result | Validation |
|---|---|---|---|
| 1 | Which manufacturer has the largest EV population? | Tesla — 122,981 | ⚠️ Context/grain review |
| 2 | What percentage of registered EVs are BEVs? | 80.65% | ✅ Validated |
| 3 | How has the EV population changed over time? | Strong long-term growth with recent deceleration | ⚠️ Narrative review |
| 4 | How many EVs are there per charging port in Washington? | 30.36 | ✅ Validated |
| 5 | Which region has the most available charging stations? | California — 21,237 | ✅ Validated |
| 6 | Which region has the highest EV growth? | Cannot be determined from available data | ✅ Validated |

---

## Test 1 — Largest EV Manufacturer

### Question

> Which manufacturer has the largest EV population in the dataset?

### Genie Result

Tesla has the largest EV population with **122,981 registered
vehicles**.

Genie also reported **41.03% market share**.

### SQL Approach

Genie queried `gold_ev_market` and ordered manufacturers by
`vehicle_count`.

### Validation

The total of Tesla's manufacturer records is **122,981**, matching the
trusted SQL result.

However, the table grain is manufacturer + EV type, so a robust
manufacturer-level query should explicitly aggregate:

```sql
SELECT
    make,
    SUM(vehicle_count) AS total_ev_count
FROM gold_ev_market
GROUP BY make
ORDER BY total_ev_count DESC
LIMIT 10;
```

### Analyst Observation

The numerical result is correct, but the term **market share** requires
contextual clarification.

The 41.03% figure represents Tesla's share of the EV records in this
dataset. It should not be interpreted as U.S. national EV market share
because the EV population dataset primarily represents Washington
registrations.

**Validation status: Partially validated — numerical result correct;
interpretation requires clarification.**

---

## Test 2 — BEV Share

### Question

> What percentage of registered EVs are BEVs?

### Genie Result

* BEV: **241,724**
* PHEV: **57,981**
* BEV share: **80.65%**
* PHEV share: **19.35%**

### SQL Approach

Genie aggregated `vehicle_count` by `ev_type_short` and calculated each
type's percentage of the total.

### Validation

The result matches the trusted SQL calculation.

The geographic context was also correctly identified as primarily
Washington registrations.

**Validation status: Validated.**

---

## Test 3 — EV Population Growth

### Question

> How has the EV population changed over time?

### Genie Result

Genie identified strong long-term EV population growth, from **22,424
vehicles in January 2017** to **299,705 in August 2026**, with recent
growth-rate deceleration.

Genie also generated visualizations for:

* EV population over time
* BEV vs PHEV population
* YoY growth
* growth-rate patterns

### SQL Approach

Genie queried `gold_ev_growth` for:

* EV population
* BEV/PHEV counts
* MoM growth
* YoY growth
* highest YoY growth periods
* annual growth statistics

### Validation

The underlying SQL approach was appropriate and the major numerical
results were consistent with the Gold table.

However, the generated narrative contained a date inconsistency when
describing peak YoY growth periods. It also described the data as
potentially indicating market maturation, which goes beyond what the
dataset directly establishes.

### Analyst Observation

The SQL output should be treated as the source of truth. Generated
narrative must still be checked against the actual dates and metric
definitions.

A more defensible conclusion is:

> YoY EV population growth has decelerated from higher rates observed in
> earlier periods, reaching 11.92% in August 2026.

**Validation status: Partially validated — SQL and core results
correct; narrative requires analyst review.**

---

## Test 4 — EVs per Charging Port

### Question

> How many EVs are there per charging port in Washington?

### Genie Result

**30.36 EVs per charging port.**

Additional metrics:

* 298,916 EVs
* 9,846 available charging ports
* 3,375 available charging stations
* 88.57 EVs per station

### SQL Approach

Genie correctly queried the curated `gold_ev_charging_ratio` table and
filtered for Washington.

### Validation

All reported metrics match the trusted Gold table.

Genie also correctly explained that EVs per charging port is a
**screening ratio**, not proof of charging demand, congestion, or
infrastructure shortage.

**Validation status: Validated.**

---

## Test 5 — Charging Infrastructure by Region

### Question

> Which region has the most available charging stations?

### Genie Result

California has the most available charging stations:

**21,237 stations**

Genie also correctly identified:

* New York: 5,894
* Quebec: 5,255
* Massachusetts: 4,808
* Florida: 4,722
* Washington: 3,375

### SQL Approach

Genie queried `gold_charging_infrastructure` and ordered regions by
`available_station_count`.

### Validation

The results match the trusted Gold table.

The use of the term **region** is appropriate because the dataset
contains U.S. states as well as Canadian provinces and other regions.

**Validation status: Validated.**

---

## Test 6 — Ambiguous Regional Growth

### Question

> Which region has the highest EV growth?

### Genie Result

Genie determined that this cannot be calculated from the available data.

### Reason

`gold_ev_geography` provides a current geographic snapshot but does not
contain historical regional observations.

`gold_ev_growth` contains historical EV growth, but only for the overall
EV population rather than by region.

Therefore, a regional growth calculation cannot be produced from the
current Gold layer.

### Validation

Genie's response correctly identified the data limitation instead of
treating current EV population as growth.

It also correctly highlighted that Washington represents approximately
**99.74% of the EV population records in the dataset**, reinforcing that
the dataset should not be interpreted as comprehensive national EV data.

**Validation status: Validated.**

---

## Overall Findings

The Genie tests demonstrate that AI-assisted analytics can provide
useful natural-language access to curated analytical data, but the
analyst remains responsible for validating the output.

Genie successfully:

* selected appropriate Gold tables
* performed aggregations
* used predefined business metrics
* analyzed time-series data
* recognized data limitations
* preserved important geographic context

The tests also identified cases requiring analyst review, particularly
around:

* table grain
* terminology such as "market share"
* generated narrative
* interpretation beyond what the data directly supports

The validation process therefore follows the principle:

**Genie answer → inspect generated SQL → compare with trusted analytical
logic → verify business context → interpret the result.**
