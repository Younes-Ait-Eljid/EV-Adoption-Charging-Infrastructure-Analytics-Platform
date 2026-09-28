# Data Quality

## Overview

Data quality checks were performed before creating the Silver analytical layer.

The objective was not simply to remove incomplete records, but to understand what missing, zero, duplicated, or malformed values represented before deciding how they should be handled.

---

# 1. EV Population Data

## Record Validation

Raw EV population:

**299,705 records**

`DOL Vehicle ID` was validated as the unique identifier for registered EV records.

The truncated `VIN (1-10)` field was not treated as a unique identifier.

## Missing Geography

The dataset contained:

- 11 records with missing county
- 11 records with missing city

These records were associated with geographic codes such as `BC` and `AE` and also contained missing values in several additional geographic fields.

The records were preserved rather than deleted because missing geography does not invalidate the vehicle registration itself.

Geographic analyses can exclude or separately categorize these records when necessary.

---

## Electric Range

Initial exploration identified:

- 26 records with NULL electric range
- 196,235 records with electric range equal to zero

A zero value initially appears to indicate a vehicle with no electric range. Further investigation showed that almost all zero-range records were associated with:

> Eligibility unknown as battery range has not been researched

Therefore, zero did not reliably represent an actual driving range of zero.

### Cleaning Decision

When:

```text
Electric Range = 0
AND
CAFV Eligibility indicates that battery range has not been researched
```

the Silver layer converts the electric range to:

```text
NULL
```

This preserves the distinction between:

**known zero** and **unknown/unresearched value**.

After transformation:

| EV Type | Range Available | Range Missing |
|---|---:|---:|
| BEV | 45,492 | 196,232 |
| PHEV | 57,952 | 29 |

The 29 missing PHEV ranges consist of the original NULL records plus zero-range records identified as unknown.

---

# 2. EV Population History

The historical dataset contained:

**116 monthly observations**

Coverage:

**January 2017 – August 2026**

Checks confirmed:

- 116 rows
- 116 unique dates
- No duplicate monthly observations
- No invalid EV totals

The following relationship was validated for every record:

```text
BEV Count + PHEV Count = EV Total
```

The August 2026 historical EV total was:

**299,705**

This exactly reconciled with the current EV population dataset containing:

**299,705 records**

This provided an additional cross-dataset validation.

---

# 3. Charging Infrastructure Data

## Raw Dataset

The raw alternative fueling station dataset contained:

**118,898 records**

The dataset includes multiple alternative fuel technologies, not only electric charging.

Major fuel categories included:

- ELEC
- E85
- LPG
- Biodiesel
- CNG
- Renewable Diesel
- LNG
- Hydrogen

The Silver analytical layer therefore explicitly filters:

```text
Fuel Type Code = ELEC
```

---

## Malformed Records

Exploration identified 27 anomalous values appearing in the fuel-type field.

Examples included text that appeared to belong to unrelated source columns rather than legitimate fuel-type codes.

These records indicated structurally malformed or misaligned source rows.

They were not forced into the analytical EV charging dataset.

---

## Missing Station IDs

The source contained:

**104,825 electric charging records**

Ten electric records had no valid station ID and also contained incomplete analytical information.

No artificial station identifiers were created.

Instead, the Silver layer requires:

```text
Fuel Type Code = ELEC
AND
ID IS NOT NULL
```

Result:

**104,815 validated electric charging station records**

Validation confirmed:

- 104,815 rows
- 104,815 unique station IDs
- 0 duplicate station IDs

---

## Charging Port Data

Of the 104,815 validated electric station records:

- 104,801 contained reported charging-port information
- 14 contained no Level 1, Level 2, or DC fast port information

When all three charging-port fields are missing, `total_ev_ports` remains NULL rather than being converted to zero.

When at least one port field is available, missing port categories are treated as zero for the purpose of calculating the station's reported total.

The Silver layer contained:

**337,456 reported EV charging ports**

---

# 4. Available Charging Infrastructure

Charging stations have different operating statuses.

The Gold infrastructure layer uses only stations with:

```text
status_code = 'E'
```

representing currently available stations.

This produced:

- **102,393 available stations**
- **330,146 reported ports at available stations**

The difference between Silver and Gold charging-port totals is expected because Silver retains electric stations with other statuses while Gold infrastructure metrics are restricted to currently available stations.

---

# 5. Geographic Scope

The EV population data is heavily concentrated in Washington.

Washington contains:

**298,916 of 299,705 EV records**

or approximately:

**99.74% of the dataset**

Therefore, the EV registration dataset should not be treated as representative of national U.S. EV adoption.

The charging infrastructure dataset has broader geographic coverage and includes U.S. states, Canadian provinces, and other regions.

This difference in geographic scope is explicitly considered when combining EV population and charging infrastructure data.

The combined EV-to-charging analysis is therefore restricted to **Washington State**.

---

# Data Quality Principle

The project follows the principle:

> Data cleaning should preserve meaning, not simply eliminate missing or unusual values.

Records were investigated before transformations were applied, and uncertainty was retained where the source data did not support a reliable replacement value.