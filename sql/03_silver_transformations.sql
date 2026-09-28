-- ============================================================
-- EV Adoption & Charging Infrastructure Analytics Platform
-- File: 03_silver_transformations.sql
-- Purpose: Create cleaned and validated Silver tables
-- ============================================================


-- ============================================================
-- 1. EV POPULATION
-- ============================================================

CREATE OR REPLACE TABLE silver_ev_population AS
SELECT
    CAST(`DOL Vehicle ID` AS BIGINT) AS vehicle_id,
    `VIN (1-10)` AS vin_prefix,
    County AS county,
    City AS city,
    State AS state,
    `Postal Code` AS postal_code,
    CAST(`Model Year` AS INT) AS model_year,
    UPPER(TRIM(Make)) AS make,
    UPPER(TRIM(Model)) AS model,

    `Electric Vehicle Type` AS ev_type,

    CASE
        WHEN `Electric Vehicle Type`
             = 'Battery Electric Vehicle (BEV)'
        THEN 'BEV'

        WHEN `Electric Vehicle Type`
             = 'Plug-in Hybrid Electric Vehicle (PHEV)'
        THEN 'PHEV'

        ELSE 'OTHER'
    END AS ev_type_short,

    `Clean Alternative Fuel Vehicle (CAFV) Eligibility`
        AS cafv_eligibility,

    -- Zero range combined with "range not researched"
    -- represents unknown range rather than a genuine zero.
    CASE
        WHEN `Electric Range` = 0
         AND `Clean Alternative Fuel Vehicle (CAFV) Eligibility`
             = 'Eligibility unknown as battery range has not been researched'
        THEN NULL

        ELSE `Electric Range`
    END AS electric_range,

    `Legislative District` AS legislative_district,
    `Vehicle Location` AS vehicle_location,
    `Electric Utility` AS electric_utility,
    `2020 GEOID` AS geoid_2020

FROM bronze_ev_population;



-- ============================================================
-- 2. EV POPULATION HISTORY
-- ============================================================

CREATE OR REPLACE TABLE silver_ev_history AS
SELECT
    TO_DATE(Date, 'MMMM d, yyyy') AS date,

    CAST(
        `Plug-In Hybrid Electric Vehicle (PHEV) Count`
        AS BIGINT
    ) AS phev_count,

    CAST(
        `Battery Electric Vehicle (BEV) Count`
        AS BIGINT
    ) AS bev_count,

    CAST(
        `Electric Vehicle (EV Total)`
        AS BIGINT
    ) AS ev_total,

    CASE
        WHEN
            CAST(
                `Plug-In Hybrid Electric Vehicle (PHEV) Count`
                AS BIGINT
            )
            +
            CAST(
                `Battery Electric Vehicle (BEV) Count`
                AS BIGINT
            )
            =
            CAST(
                `Electric Vehicle (EV Total)`
                AS BIGINT
            )
        THEN TRUE
        ELSE FALSE
    END AS total_check

FROM bronze_ev_history;



-- ============================================================
-- 3. EV CHARGING STATIONS
-- ============================================================

CREATE OR REPLACE TABLE silver_charging_stations AS
SELECT
    CAST(ID AS BIGINT) AS station_id,
    `Station Name` AS station_name,
    City AS city,
    State AS state,
    ZIP AS zip_code,
    `Status Code` AS status_code,
    `EV Network` AS ev_network,

    `EV Level1 EVSE Num` AS level1_ports,
    `EV Level2 EVSE Num` AS level2_ports,
    `EV DC Fast Count` AS dc_fast_ports,

    CASE
        WHEN
            `EV Level1 EVSE Num` IS NULL
            AND `EV Level2 EVSE Num` IS NULL
            AND `EV DC Fast Count` IS NULL
        THEN NULL

        ELSE
            COALESCE(`EV Level1 EVSE Num`, 0)
            +
            COALESCE(`EV Level2 EVSE Num`, 0)
            +
            COALESCE(`EV DC Fast Count`, 0)
    END AS total_ev_ports,

    Latitude AS latitude,
    Longitude AS longitude,
    `Access Code` AS access_code,
    `Facility Type` AS facility_type,
    `EV Workplace Charging` AS workplace_charging,
    `Restricted Access` AS restricted_access

FROM bronze_charging_stations

-- Keep only electric charging infrastructure.
WHERE `Fuel Type Code` = 'ELEC'

-- Records without valid station IDs are excluded rather than
-- assigning artificial identifiers.
AND ID IS NOT NULL;