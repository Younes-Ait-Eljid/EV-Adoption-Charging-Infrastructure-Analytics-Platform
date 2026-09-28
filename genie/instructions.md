# Databricks Genie Instructions

The following instructions were provided to Databricks Genie to establish the business context, metric definitions, and analytical rules for the project.

## Business Context

- The EV population dataset primarily represents vehicle registrations in Washington State.
- It must **not** be interpreted as national U.S. EV market data.
- The EV population grain is one registered EV record, identified by DOL Vehicle ID.
- BEV and PHEV are the two EV types in the EV population data.

## Table Guidance

- `gold_ev_market`: manufacturer-level EV population and dataset-share analysis.
- `gold_ev_models`: model-level EV population analysis.
- `gold_ev_growth`: monthly EV population history and growth metrics.
- `gold_ev_geography`: EV population by state/region and EV type.
- `gold_charging_infrastructure`: currently available charging stations and reported EV charging ports by state/region.
- `gold_ev_charging_ratio`: combined EV population and charging infrastructure metrics for Washington.

## Important Metric Definitions

- **Total EVs** means the number of registered EV records in the EV population dataset.
- **BEV Share** and **PHEV Share** are percentages of the EV population dataset.
- **Available charging stations** means stations with status code `E`.
- **EVs per charging port** is a screening ratio calculated as registered EVs divided by reported available charging ports.
- EVs per charging port must **not** be interpreted as proof of charging demand, congestion, or infrastructure shortage.

## Analytical Rules

- Prefer Gold tables for business analysis.
- Clearly state the geographic scope and time period when answering questions.
- Do not describe dataset shares as U.S. national market shares.
- Do not assume that "growth" means a particular metric if the question is ambiguous. Distinguish between absolute growth, month-over-month growth, and year-over-year growth.
- If a question is ambiguous, explain the ambiguity or ask for clarification.
- Preserve the definitions and grain of the Gold tables when generating SQL.
- When possible, provide the metric, geographic scope, and time period used to produce the answer.