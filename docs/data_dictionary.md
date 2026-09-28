# Data Dictionary

This document describes the main analytical fields used throughout the project. It intentionally focuses on fields relevant to the analytical workflow rather than reproducing every source column.

## EV Population

### `silver_ev_population`

**Grain:** One row represents one registered EV record identified by `vehicle_id`.

| Column | Description |
|---|---|
| `vehicle_id` | Unique vehicle record identifier derived from DOL Vehicle ID |
| `vin_prefix` | First 10 characters of the vehicle VIN |
| `county` | Registered county |
| `city` | Registered city |
| `state` | State or geographic code |
| `postal_code` | Registered postal code |
| `model_year` | Vehicle model year |
| `make` | Vehicle manufacturer |
| `model` | Vehicle model |
| `ev_type` | Full electric vehicle type description |
| `ev_type_short` | Standardized EV type: BEV or PHEV |
| `cafv_eligibility` | Clean Alternative Fuel Vehicle eligibility classification |
| `electric_range` | Reported electric driving range; unknown/unresearched values are represented as NULL |

---

## EV Population History

### `silver_ev_history`

**Grain:** One row represents one monthly EV population observation.

| Column | Description |
|---|---|
| `date` | Monthly observation date |
| `phev_count` | Registered Plug-in Hybrid Electric Vehicle population |
| `bev_count` | Registered Battery Electric Vehicle population |
| `ev_total` | Total registered EV population |
| `total_check` | Validation flag confirming BEV + PHEV = EV Total |

---

## Charging Stations

### `silver_charging_stations`

**Grain:** One row represents one electric charging station record identified by `station_id`.

| Column | Description |
|---|---|
| `station_id` | Unique charging station identifier |
| `station_name` | Charging station name |
| `city` | Station city |
| `state` | Station state/province/region code |
| `zip_code` | Station postal code |
| `status_code` | Station operating status |
| `ev_network` | Charging network |
| `level1_ports` | Reported Level 1 charging ports |
| `level2_ports` | Reported Level 2 charging ports |
| `dc_fast_ports` | Reported DC fast charging ports |
| `total_ev_ports` | Sum of reported Level 1, Level 2, and DC fast ports |
| `latitude` | Station latitude |
| `longitude` | Station longitude |
| `access_code` | Station access classification |
| `facility_type` | Facility classification |
| `workplace_charging` | Workplace charging indicator |
| `restricted_access` | Restricted-access indicator |

---

# Gold Tables

## `gold_ev_market`

**Grain:** Manufacturer + EV type.

| Column | Description |
|---|---|
| `make` | Vehicle manufacturer |
| `ev_type_short` | BEV or PHEV |
| `vehicle_count` | Number of registered vehicle records |
| `market_share_pct` | Percentage of EV records represented by the group within this dataset |
| `avg_electric_range` | Average known electric range |

> `market_share_pct` represents dataset share and must not be interpreted as national U.S. EV market share.

---

## `gold_ev_models`

**Grain:** Manufacturer + model + model year + EV type.

| Column | Description |
|---|---|
| `make` | Manufacturer |
| `model` | Vehicle model |
| `model_year` | Model year |
| `ev_type_short` | BEV or PHEV |
| `vehicle_count` | Registered population for the group |
| `dataset_share_pct` | Group's percentage of all EV records in the dataset |
| `avg_electric_range` | Average known electric range |

---

## `gold_ev_growth`

**Grain:** One monthly observation.

| Column | Description |
|---|---|
| `date` | Observation month |
| `ev_total` | Total EV population |
| `bev_count` | BEV population |
| `phev_count` | PHEV population |
| `previous_month_ev` | Previous monthly EV population |
| `previous_year_ev` | EV population 12 observations earlier |
| `mom_growth_pct` | Month-over-month EV population growth |
| `yoy_growth_pct` | Year-over-year EV population growth |

---

## `gold_ev_geography`

**Grain:** Geography + EV type.

| Column | Description |
|---|---|
| `state` | State/region code |
| `ev_type_short` | BEV or PHEV |
| `vehicle_count` | EV population for the group |
| `state_total` | Total EV population for the geography |
| `state_ev_type_share_pct` | EV type's share within the geography |
| `dataset_ev_share_pct` | Geography's share of the complete EV population dataset |

---

## `gold_charging_infrastructure`

**Grain:** One state/province/region.

| Column | Description |
|---|---|
| `state` | State/province/region code |
| `available_station_count` | Number of currently available charging stations |
| `total_ev_ports` | Total reported ports at available stations |
| `level1_ports` | Reported Level 1 ports |
| `level2_ports` | Reported Level 2 ports |
| `dc_fast_ports` | Reported DC fast ports |
| `avg_ports_per_station` | Average reported ports per available station |

---

## `gold_ev_charging_ratio`

**Grain:** Washington State summary.

| Column | Description |
|---|---|
| `state` | Geographic code |
| `ev_count` | Registered EV population |
| `bev_count` | Registered BEV population |
| `phev_count` | Registered PHEV population |
| `available_station_count` | Available charging stations |
| `total_ev_ports` | Reported ports at available stations |
| `evs_per_station` | Registered EVs divided by available stations |
| `evs_per_port` | Registered EVs divided by reported available charging ports |