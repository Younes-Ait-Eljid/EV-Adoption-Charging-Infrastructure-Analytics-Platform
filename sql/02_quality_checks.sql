-- ============================================================
-- EV Adoption & Charging Infrastructure Analytics Platform
-- File: 02_quality_checks.sql
-- Purpose: Data quality assessment of Bronze/raw datasets
-- ============================================================


-- ============================================================
-- 1. EV POPULATION QUALITY CHECKS
-- ============================================================

-- Overall row count and identifier uniqueness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT `DOL Vehicle ID`) AS unique_vehicle_ids
FROM bronze_ev_population;


-- Missing values in important analytical fields
SELECT
    SUM(CASE WHEN County IS NULL THEN 1 ELSE 0 END) AS missing_county,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS missing_city,
    SUM(CASE WHEN `Model Year` IS NULL THEN 1 ELSE 0 END) AS missing_model_year,
    SUM(CASE WHEN Make IS NULL THEN 1 ELSE 0 END) AS missing_make,
    SUM(CASE WHEN Model IS NULL THEN 1 ELSE 0 END) AS missing_model,
    SUM(CASE WHEN `Electric Vehicle Type` IS NULL THEN 1 ELSE 0 END) AS missing_ev_type,
    SUM(CASE WHEN `Electric Range` IS NULL THEN 1 ELSE 0 END) AS missing_range,
    SUM(CASE WHEN `DOL Vehicle ID` IS NULL THEN 1 ELSE 0 END) AS missing_vehicle_id
FROM bronze_ev_population;


-- Check duplicate vehicle identifiers
SELECT
    `DOL Vehicle ID`,
    COUNT(*) AS row_count
FROM bronze_ev_population
GROUP BY `DOL Vehicle ID`
HAVING COUNT(*) > 1
ORDER BY row_count DESC;


-- Investigate records with missing geography
SELECT
    State,
    COUNT(*) AS record_count
FROM bronze_ev_population
WHERE County IS NULL
   OR City IS NULL
GROUP BY State
ORDER BY record_count DESC;


-- Investigate NULL electric range by EV type
SELECT
    `Electric Vehicle Type`,
    COUNT(*) AS null_range_records
FROM bronze_ev_population
WHERE `Electric Range` IS NULL
GROUP BY `Electric Vehicle Type`;


-- Investigate zero electric range
SELECT
    `Electric Vehicle Type`,
    `Clean Alternative Fuel Vehicle (CAFV) Eligibility`,
    COUNT(*) AS record_count
FROM bronze_ev_population
WHERE `Electric Range` = 0
GROUP BY
    `Electric Vehicle Type`,
    `Clean Alternative Fuel Vehicle (CAFV) Eligibility`
ORDER BY record_count DESC;



-- ============================================================
-- 2. EV HISTORY QUALITY CHECKS
-- ============================================================

-- Row count, date uniqueness and coverage
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Date) AS unique_dates,
    MIN(TO_DATE(Date, 'MMMM d, yyyy')) AS first_date,
    MAX(TO_DATE(Date, 'MMMM d, yyyy')) AS last_date
FROM bronze_ev_history;


-- Missing values
SELECT
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(
        CASE
            WHEN `Plug-In Hybrid Electric Vehicle (PHEV) Count` IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_phev_count,
    SUM(
        CASE
            WHEN `Battery Electric Vehicle (BEV) Count` IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_bev_count,
    SUM(
        CASE
            WHEN `Electric Vehicle (EV Total)` IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_ev_total
FROM bronze_ev_history;


-- Validate BEV + PHEV = EV Total
SELECT
    Date,
    `Battery Electric Vehicle (BEV) Count`,
    `Plug-In Hybrid Electric Vehicle (PHEV) Count`,
    `Electric Vehicle (EV Total)`
FROM bronze_ev_history
WHERE
    CAST(`Battery Electric Vehicle (BEV) Count` AS BIGINT)
    +
    CAST(`Plug-In Hybrid Electric Vehicle (PHEV) Count` AS BIGINT)
    !=
    CAST(`Electric Vehicle (EV Total)` AS BIGINT);



-- ============================================================
-- 3. CHARGING STATION QUALITY CHECKS
-- ============================================================

-- Overall row count and ID uniqueness
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ID) AS unique_station_ids
FROM bronze_charging_stations;


-- Inspect fuel type values
-- This check revealed malformed/misaligned source records.
SELECT
    `Fuel Type Code`,
    COUNT(*) AS record_count
FROM bronze_charging_stations
GROUP BY `Fuel Type Code`
ORDER BY record_count DESC;


-- Count electric charging records
SELECT
    COUNT(*) AS electric_station_records
FROM bronze_charging_stations
WHERE `Fuel Type Code` = 'ELEC';


-- Check missing station IDs among electric records
SELECT
    COUNT(*) AS electric_records_without_id
FROM bronze_charging_stations
WHERE `Fuel Type Code` = 'ELEC'
  AND ID IS NULL;


-- Inspect incomplete electric records without station IDs
SELECT
    `Station Name`,
    City,
    State,
    `Status Code`,
    `EV Level1 EVSE Num`,
    `EV Level2 EVSE Num`,
    `EV DC Fast Count`,
    `EV Network`
FROM bronze_charging_stations
WHERE `Fuel Type Code` = 'ELEC'
  AND ID IS NULL;


-- Check duplicate station IDs
SELECT
    ID,
    COUNT(*) AS row_count
FROM bronze_charging_stations
GROUP BY ID
HAVING COUNT(*) > 1
ORDER BY row_count DESC;


-- EV charging status distribution
SELECT
    `Status Code`,
    COUNT(*) AS station_count
FROM bronze_charging_stations
WHERE `Fuel Type Code` = 'ELEC'
GROUP BY `Status Code`
ORDER BY station_count DESC;


-- Check availability of port information
SELECT
    COUNT(*) AS electric_records,
    SUM(
        CASE
            WHEN `EV Level1 EVSE Num` IS NULL
             AND `EV Level2 EVSE Num` IS NULL
             AND `EV DC Fast Count` IS NULL
            THEN 1 ELSE 0
        END
    ) AS records_without_port_data
FROM bronze_charging_stations
WHERE `Fuel Type Code` = 'ELEC'
  AND ID IS NOT NULL;