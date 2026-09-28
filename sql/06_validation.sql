-- ============================================================
-- EV Adoption & Charging Infrastructure Analytics Platform
-- File: 06_validation.sql
-- Purpose: Validate Silver and Gold analytical outputs
-- ============================================================


-- ============================================================
-- 1. SILVER EV POPULATION VALIDATION
-- ============================================================

-- Row count and unique vehicle identifiers
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT vehicle_id) AS unique_vehicle_ids

FROM silver_ev_population;


-- EV type totals and electric range availability
SELECT
    ev_type_short,

    COUNT(*) AS vehicle_count,

    SUM(
        CASE
            WHEN electric_range IS NOT NULL
            THEN 1 ELSE 0
        END
    ) AS range_available,

    SUM(
        CASE
            WHEN electric_range IS NULL
            THEN 1 ELSE 0
        END
    ) AS range_missing

FROM silver_ev_population

GROUP BY ev_type_short;



-- ============================================================
-- 2. EV HISTORY VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT date) AS unique_dates,
    MIN(date) AS first_date,
    MAX(date) AS last_date,

    SUM(
        CASE
            WHEN total_check = FALSE
            THEN 1 ELSE 0
        END
    ) AS invalid_totals

FROM silver_ev_history;


-- Confirm latest history total against current EV population
WITH latest_history AS (

    SELECT
        date,
        ev_total

    FROM silver_ev_history

    ORDER BY date DESC

    LIMIT 1
),

current_population AS (

    SELECT
        COUNT(*) AS current_ev_total

    FROM silver_ev_population
)

SELECT
    h.date AS latest_history_date,
    h.ev_total AS historical_ev_total,
    p.current_ev_total,

    h.ev_total - p.current_ev_total
        AS difference

FROM latest_history h

CROSS JOIN current_population p;



-- ============================================================
-- 3. GOLD EV MARKET VALIDATION
-- ============================================================

SELECT
    SUM(vehicle_count) AS gold_vehicle_count,

    (
        SELECT COUNT(*)
        FROM silver_ev_population
    ) AS silver_vehicle_count,

    SUM(vehicle_count)
    -
    (
        SELECT COUNT(*)
        FROM silver_ev_population
    ) AS difference

FROM gold_ev_market;


-- Rounded percentages may not equal exactly 100
-- because each group is rounded independently.
SELECT
    ROUND(SUM(market_share_pct), 2)
        AS rounded_market_share_total

FROM gold_ev_market;



-- ============================================================
-- 4. GOLD MODEL VALIDATION
-- ============================================================

SELECT
    SUM(vehicle_count) AS model_vehicle_count,

    (
        SELECT COUNT(*)
        FROM silver_ev_population
    ) AS silver_vehicle_count,

    SUM(vehicle_count)
    -
    (
        SELECT COUNT(*)
        FROM silver_ev_population
    ) AS difference

FROM gold_ev_models;



-- ============================================================
-- 5. EV GROWTH VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT date) AS unique_dates,

    SUM(
        CASE
            WHEN previous_month_ev IS NOT NULL
             AND mom_growth_pct IS NULL
            THEN 1 ELSE 0
        END
    ) AS invalid_mom,

    SUM(
        CASE
            WHEN previous_year_ev IS NOT NULL
             AND yoy_growth_pct IS NULL
            THEN 1 ELSE 0
        END
    ) AS invalid_yoy

FROM gold_ev_growth;



-- ============================================================
-- 6. SILVER CHARGING VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_stations,
    COUNT(DISTINCT station_id) AS unique_station_ids,

    COUNT(*) - COUNT(DISTINCT station_id)
        AS duplicate_station_ids,

    SUM(
        CASE
            WHEN total_ev_ports IS NOT NULL
            THEN 1 ELSE 0
        END
    ) AS stations_with_port_data,

    SUM(
        CASE
            WHEN total_ev_ports IS NULL
            THEN 1 ELSE 0
        END
    ) AS stations_without_port_data,

    SUM(total_ev_ports)
        AS total_reported_ev_ports

FROM silver_charging_stations;



-- ============================================================
-- 7. GOLD CHARGING VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS regions,

    SUM(available_station_count)
        AS total_available_stations,

    SUM(total_ev_ports)
        AS total_available_ports

FROM gold_charging_infrastructure;


-- Compare all reported ports with ports at available stations.
-- The difference represents stations excluded from Gold because
-- Gold only includes currently available status ('E').
SELECT

    (
        SELECT SUM(total_ev_ports)
        FROM silver_charging_stations
    ) AS all_reported_ports,

    (
        SELECT SUM(total_ev_ports)
        FROM gold_charging_infrastructure
    ) AS available_station_ports,

    (
        SELECT SUM(total_ev_ports)
        FROM silver_charging_stations
    )
    -
    (
        SELECT SUM(total_ev_ports)
        FROM gold_charging_infrastructure
    ) AS excluded_station_ports;



-- ============================================================
-- 8. WASHINGTON COMBINED METRIC VALIDATION
-- ============================================================

SELECT
    state,
    ev_count,
    bev_count,
    phev_count,

    ev_count - (bev_count + phev_count)
        AS ev_type_difference,

    available_station_count,
    total_ev_ports,

    evs_per_station,
    evs_per_port

FROM gold_ev_charging_ratio

WHERE state = 'WA';