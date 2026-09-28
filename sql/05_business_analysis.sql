-- ============================================================
-- EV Adoption & Charging Infrastructure Analytics Platform
-- File: 05_business_analysis.sql
-- Purpose: Answer the project's core business questions
-- ============================================================


-- ============================================================
-- Q1. Which manufacturers have the largest EV populations?
-- ============================================================

SELECT
    make,
    SUM(vehicle_count) AS total_ev_count,

    ROUND(
        SUM(vehicle_count) * 100.0 /
        SUM(SUM(vehicle_count)) OVER (),
        2
    ) AS dataset_share_pct

FROM gold_ev_market

GROUP BY make

ORDER BY total_ev_count DESC

LIMIT 10;



-- ============================================================
-- Q2. What is the BEV vs PHEV composition?
-- ============================================================

SELECT
    ev_type_short,
    SUM(vehicle_count) AS vehicle_count,

    ROUND(
        SUM(vehicle_count) * 100.0 /
        SUM(SUM(vehicle_count)) OVER (),
        2
    ) AS share_pct

FROM gold_ev_market

GROUP BY ev_type_short

ORDER BY vehicle_count DESC;



-- ============================================================
-- Q3. Which EV models have the largest populations?
-- ============================================================

SELECT
    make,
    model,
    SUM(vehicle_count) AS total_ev_count

FROM gold_ev_models

GROUP BY
    make,
    model

ORDER BY total_ev_count DESC

LIMIT 10;



-- ============================================================
-- Q4. How has EV adoption changed over time?
-- ============================================================

SELECT
    date,
    ev_total,
    bev_count,
    phev_count,
    mom_growth_pct,
    yoy_growth_pct

FROM gold_ev_growth

ORDER BY date;



-- Recent growth trend
SELECT
    date,
    ev_total,
    mom_growth_pct,
    yoy_growth_pct

FROM gold_ev_growth

ORDER BY date DESC

LIMIT 12;



-- ============================================================
-- Q5. How is available charging infrastructure distributed?
-- ============================================================

SELECT
    state,
    available_station_count,
    total_ev_ports,
    level1_ports,
    level2_ports,
    dc_fast_ports,
    avg_ports_per_station

FROM gold_charging_infrastructure

ORDER BY available_station_count DESC

LIMIT 10;



-- ============================================================
-- Q6. What is the current EV-to-charging-port picture
--     in Washington?
-- ============================================================

SELECT
    state,
    ev_count,
    bev_count,
    phev_count,
    available_station_count,
    total_ev_ports,
    evs_per_station,
    evs_per_port

FROM gold_ev_charging_ratio

WHERE state = 'WA';