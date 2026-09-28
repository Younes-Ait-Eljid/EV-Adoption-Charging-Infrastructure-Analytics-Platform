-- ============================================================
-- EV Adoption & Charging Infrastructure Analytics Platform
-- File: 04_gold_transformations.sql
-- Purpose: Create business-ready analytical Gold tables
-- ============================================================


-- ============================================================
-- 1. EV MARKET BY MANUFACTURER AND EV TYPE
-- ============================================================

CREATE OR REPLACE TABLE gold_ev_market AS

WITH market_summary AS (

    SELECT
        make,
        ev_type_short,
        COUNT(*) AS vehicle_count,
        AVG(electric_range) AS avg_electric_range

    FROM silver_ev_population

    GROUP BY
        make,
        ev_type_short
),

total_market AS (

    SELECT
        SUM(vehicle_count) AS total_vehicles
    FROM market_summary
)

SELECT
    m.make,
    m.ev_type_short,
    m.vehicle_count,

    ROUND(
        m.vehicle_count * 100.0 / t.total_vehicles,
        2
    ) AS market_share_pct,

    ROUND(
        m.avg_electric_range,
        1
    ) AS avg_electric_range

FROM market_summary m
CROSS JOIN total_market t;



-- ============================================================
-- 2. EV MODELS
-- ============================================================

CREATE OR REPLACE TABLE gold_ev_models AS

SELECT
    make,
    model,
    model_year,
    ev_type_short,

    COUNT(*) AS vehicle_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS dataset_share_pct,

    ROUND(
        AVG(electric_range),
        1
    ) AS avg_electric_range

FROM silver_ev_population

GROUP BY
    make,
    model,
    model_year,
    ev_type_short;



-- ============================================================
-- 3. EV POPULATION GROWTH
-- ============================================================

CREATE OR REPLACE TABLE gold_ev_growth AS

WITH growth_base AS (

    SELECT
        date,
        ev_total,
        bev_count,
        phev_count,

        LAG(ev_total)
            OVER (ORDER BY date)
            AS previous_month_ev,

        LAG(ev_total, 12)
            OVER (ORDER BY date)
            AS previous_year_ev

    FROM silver_ev_history
)

SELECT
    date,
    ev_total,
    bev_count,
    phev_count,
    previous_month_ev,
    previous_year_ev,

    ROUND(
        (ev_total - previous_month_ev)
        * 100.0
        / NULLIF(previous_month_ev, 0),
        2
    ) AS mom_growth_pct,

    ROUND(
        (ev_total - previous_year_ev)
        * 100.0
        / NULLIF(previous_year_ev, 0),
        2
    ) AS yoy_growth_pct

FROM growth_base;



-- ============================================================
-- 4. EV GEOGRAPHY
-- ============================================================

CREATE OR REPLACE TABLE gold_ev_geography AS

WITH state_summary AS (

    SELECT
        state,
        ev_type_short,
        COUNT(*) AS vehicle_count

    FROM silver_ev_population

    GROUP BY
        state,
        ev_type_short
),

state_totals AS (

    SELECT
        state,
        SUM(vehicle_count) AS state_total

    FROM state_summary

    GROUP BY state
),

dataset_total AS (

    SELECT
        SUM(vehicle_count) AS total_vehicles
    FROM state_summary
)

SELECT
    s.state,
    s.ev_type_short,
    s.vehicle_count,
    st.state_total,

    ROUND(
        s.vehicle_count * 100.0 / st.state_total,
        2
    ) AS state_ev_type_share_pct,

    ROUND(
        st.state_total * 100.0 / dt.total_vehicles,
        2
    ) AS dataset_ev_share_pct

FROM state_summary s

JOIN state_totals st
    ON s.state = st.state

CROSS JOIN dataset_total dt;



-- ============================================================
-- 5. CHARGING INFRASTRUCTURE
-- ============================================================

CREATE OR REPLACE TABLE gold_charging_infrastructure AS

SELECT
    state,

    COUNT(*) AS available_station_count,

    SUM(total_ev_ports) AS total_ev_ports,
    SUM(level1_ports) AS level1_ports,
    SUM(level2_ports) AS level2_ports,
    SUM(dc_fast_ports) AS dc_fast_ports,

    ROUND(
        AVG(total_ev_ports),
        2
    ) AS avg_ports_per_station

FROM silver_charging_stations

-- E = currently available station
WHERE status_code = 'E'

GROUP BY state;



-- ============================================================
-- 6. WASHINGTON EV / CHARGING RATIO
-- ============================================================

CREATE OR REPLACE TABLE gold_ev_charging_ratio AS

WITH ev_summary AS (

    SELECT
        state,

        SUM(vehicle_count) AS ev_count,

        SUM(
            CASE
                WHEN ev_type_short = 'BEV'
                THEN vehicle_count
                ELSE 0
            END
        ) AS bev_count,

        SUM(
            CASE
                WHEN ev_type_short = 'PHEV'
                THEN vehicle_count
                ELSE 0
            END
        ) AS phev_count

    FROM gold_ev_geography

    WHERE state = 'WA'

    GROUP BY state
),

charging_summary AS (

    SELECT
        state,
        available_station_count,
        total_ev_ports

    FROM gold_charging_infrastructure

    WHERE state = 'WA'
)

SELECT
    e.state,
    e.ev_count,
    e.bev_count,
    e.phev_count,

    c.available_station_count,
    c.total_ev_ports,

    ROUND(
        e.ev_count * 1.0 /
        NULLIF(c.available_station_count, 0),
        2
    ) AS evs_per_station,

    ROUND(
        e.ev_count * 1.0 /
        NULLIF(c.total_ev_ports, 0),
        2
    ) AS evs_per_port

FROM ev_summary e

JOIN charging_summary c
    ON e.state = c.state;