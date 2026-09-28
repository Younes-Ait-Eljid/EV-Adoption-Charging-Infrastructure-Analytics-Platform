# KPI Definitions

This document defines the analytical metrics used across SQL analysis, dashboards, and Databricks Genie.

Consistent KPI definitions are important because AI tools, dashboards, and analysts should calculate the same business concepts using the same logic.

---

# EV Population KPIs

## Total EVs

**Definition**

Total number of registered EV records in the EV population dataset.

**Calculation**

```text
COUNT(EV records)
```

Current dataset:

**299,705 EVs**

---

## BEV Count

Number of records classified as Battery Electric Vehicles.

Current dataset:

**241,724 BEVs**

---

## PHEV Count

Number of records classified as Plug-in Hybrid Electric Vehicles.

Current dataset:

**57,981 PHEVs**

---

## BEV Share

Percentage of registered EV records classified as BEVs.

**Calculation**

```text
BEV Count / Total EVs × 100
```

Current value:

**80.65%**

---

## PHEV Share

Percentage of registered EV records classified as PHEVs.

**Calculation**

```text
PHEV Count / Total EVs × 100
```

Current value:

**19.35%**

---

# Growth KPIs

## Month-over-Month Growth

Measures the percentage change in total EV population compared with the previous monthly observation.

**Calculation**

```text
(Current EV Total - Previous Month EV Total)
------------------------------------------------ × 100
              Previous Month EV Total
```

---

## Year-over-Year Growth

Measures the percentage change in EV population compared with the observation 12 months earlier.

**Calculation**

```text
(Current EV Total - Previous Year EV Total)
------------------------------------------------ × 100
              Previous Year EV Total
```

For August 2026:

**11.92% YoY growth**

A negative monthly value should not automatically be interpreted as a long-term decline. Monthly changes should be considered together with YoY growth and the broader historical trend.

---

# EV Market KPIs

## Manufacturer Dataset Share

Percentage of EV records associated with a manufacturer.

**Calculation**

```text
Manufacturer EV Count / Total EV Records × 100
```

This metric describes the manufacturer's share **within the project dataset**.

It is not equivalent to U.S. national EV market share.

---

## Model Population

Number of registered EV records associated with a manufacturer/model combination.

Example:

**Tesla Model Y — 66,545 records**

---

# Charging Infrastructure KPIs

## Available Charging Stations

Number of electric charging stations with:

```text
status_code = 'E'
```

Current charging dataset:

**102,393 available stations**

---

## Total Available Charging Ports

Sum of reported:

```text
Level 1 ports
+
Level 2 ports
+
DC fast ports
```

for currently available charging stations.

Current value:

**330,146 ports**

---

## Average Ports per Station

Average number of reported charging ports per currently available charging station within a geography.

**Calculation**

```text
AVG(total_ev_ports)
```

---

# Washington Combined KPIs

Because the EV population dataset primarily represents Washington registrations, combined EV and charging infrastructure metrics are calculated for Washington rather than treating the EV dataset as nationally representative.

## EVs per Charging Station

**Calculation**

```text
Registered EV Population
-------------------------
Available Charging Stations
```

Washington:

```text
298,916 / 3,375
```

**88.57 EVs per station**

---

## EVs per Charging Port

**Calculation**

```text
Registered EV Population
-------------------------
Available Charging Ports
```

Washington:

```text
298,916 / 9,846
```

**30.36 EVs per charging port**

### Interpretation Limitation

EVs per charging port is a **screening indicator**.

It must not be interpreted by itself as proof of:

- Charging congestion
- Infrastructure shortage
- Charger utilization
- Public charging demand
- Required future charger investment

The metric does not account for factors such as:

- Home charging
- Charger utilization
- Geographic distribution within Washington
- Charging speed
- Vehicle travel patterns
- Traffic
- Station accessibility
- Driver behavior

Additional data would be required to evaluate charging infrastructure adequacy.

---

# KPI Governance

These definitions are shared across:

- SQL analysis
- Databricks Dashboards
- Databricks Genie

The Gold analytical layer serves as the primary source for these metrics.

This reduces the risk that different analytical interfaces calculate the same KPI differently.