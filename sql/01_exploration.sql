-- ============================================================
-- EV Adoption & Charging Infrastructure Analytics Platform
-- File: 01_exploration.sql
-- Purpose: Initial exploration of the Bronze/raw datasets
-- ============================================================


-- ============================================================
-- 1. EV POPULATION DATA
-- ============================================================

-- Total number of EV records
SELECT COUNT(*) AS total_ev_records
FROM bronze_ev_population;


-- Preview raw data
SELECT *
FROM bronze_ev_population
LIMIT 20;


-- EV type distribution
SELECT
    `Electric Vehicle Type`,
    COUNT(*) AS vehicle_count
FROM bronze_ev_population
GROUP BY `Electric Vehicle Type`
ORDER BY vehicle_count DESC;


-- Manufacturer distribution
SELECT
    Make,
    COUNT(*) AS vehicle_count
FROM bronze_ev_population
GROUP BY Make
ORDER BY vehicle_count DESC;


-- Geographic distribution
SELECT
    State,
    COUNT(*) AS vehicle_count
FROM bronze_ev_population
GROUP BY State
ORDER BY vehicle_count DESC;


-- Electric range distribution
SELECT
    MIN(`Electric Range`) AS min_range,
    MAX(`Electric Range`) AS max_range,
    AVG(`Electric Range`) AS avg_range,
    SUM(CASE WHEN `Electric Range` = 0 THEN 1 ELSE 0 END)
        AS zero_range_records,
    SUM(CASE WHEN `Electric Range` IS NULL THEN 1 ELSE 0 END)
        AS null_range_records
FROM bronze_ev_population;



-- ============================================================
-- 2. EV POPULATION HISTORY
-- ============================================================

-- Total historical observations
SELECT COUNT(*) AS total_history_records
FROM bronze_ev_history;


-- Preview historical data
SELECT *
FROM bronze_ev_history
ORDER BY Date
LIMIT 20;


-- Inspect date coverage
SELECT
    MIN(TO_DATE(Date, 'MMMM d, yyyy')) AS first_date,
    MAX(TO_DATE(Date, 'MMMM d, yyyy')) AS last_date,
    COUNT(DISTINCT Date) AS unique_dates
FROM bronze_ev_history;



-- ============================================================
-- 3. ALTERNATIVE FUELING / CHARGING STATIONS
-- ============================================================

-- Total raw station records
SELECT COUNT(*) AS total_station_records
FROM bronze_charging_stations;


-- Preview raw station data
SELECT *
FROM bronze_charging_stations
LIMIT 20;


-- Fuel type distribution
SELECT
    `Fuel Type Code`,
    COUNT(*) AS record_count
FROM bronze_charging_stations
GROUP BY `Fuel Type Code`
ORDER BY record_count DESC;


-- EV charging station status distribution
SELECT
    `Status Code`,
    COUNT(*) AS station_count
FROM bronze_charging_stations
WHERE `Fuel Type Code` = 'ELEC'
GROUP BY `Status Code`
ORDER BY station_count DESC;


-- Geographic distribution of EV charging records
SELECT
    State,
    COUNT(*) AS station_records
FROM bronze_charging_stations
WHERE `Fuel Type Code` = 'ELEC'
GROUP BY State
ORDER BY station_records DESC;


-- Inspect reported EV charging ports
SELECT
    SUM(`EV Level1 EVSE Num`) AS level1_ports,
    SUM(`EV Level2 EVSE Num`) AS level2_ports,
    SUM(`EV DC Fast Count`) AS dc_fast_ports
FROM bronze_charging_stations
WHERE `Fuel Type Code` = 'ELEC';