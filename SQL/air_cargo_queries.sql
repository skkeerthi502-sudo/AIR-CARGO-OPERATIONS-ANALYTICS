/*
PROJECT: AIR CARGO DATA INTELLIGENCE
Purpose: SQL analysis queries for the Air Cargo Operations & Performance Analytics project
Database: SQL
Table: air_cargo_dataset
Platform: MySQL 8.0 / MySQL Workbench

Dataset note:
This project uses a generated/synthetic dataset. Results describe this dataset
and should not be presented as official airport statistics.

*/

CREATE DATABASE air_cargo_analytics;
USE air_cargo_analytics;


-- 1. table structure and first look at the data
DESCRIBE air_cargo_dataset;

SELECT * 
FROM air_cargo_dataset 
LIMIT 10;


-- 2. how big is the dataset
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT `Operating Airline`) AS total_airlines,
    MIN(`Activity Period Start Date`) AS first_date,
    MAX(`Activity Period Start Date`) AS last_date
FROM air_cargo_dataset;


-- 3. null check for every column
SELECT
    SUM(`Activity Period` IS NULL) AS null_activity_period,
    SUM(`Activity Period Start Date` IS NULL) AS null_start_date,
    SUM(`Operating Airline` IS NULL) AS null_op_airline,
    SUM(`Operating Airline IATA Code` IS NULL) AS null_op_iata,
    SUM(`Published Airline` IS NULL) AS null_pub_airline,
    SUM(`Published Airline IATA Code` IS NULL) AS null_pub_iata,
    SUM(`GEO Summary` IS NULL) AS null_geo_summary,
    SUM(`GEO Region` IS NULL) AS null_geo_region,
    SUM(`Activity Type Code` IS NULL) AS null_activity_type,
    SUM(`Cargo Type Code` IS NULL) AS null_cargo_type,
    SUM(`Cargo Aircraft Type` IS NULL) AS null_aircraft_type,
    SUM(`Cargo Weight LBS` IS NULL) AS null_weight_lbs,
    SUM(`Cargo Metric TONS` IS NULL) AS null_metric_tons,
    SUM(`data_as_of` IS NULL) AS null_data_as_of,
    SUM(`data_loaded_at` IS NULL) AS null_data_loaded_at
FROM air_cargo_dataset;


-- 4. overall KPIs
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT `Operating Airline`) AS total_airlines,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt,
    ROUND(SUM(`Cargo Weight LBS`), 2) AS total_cargo_lbs,
    ROUND(AVG(`Cargo Metric TONS`), 2) AS avg_cargo_mt,
    ROUND(MIN(`Cargo Metric TONS`), 2) AS min_cargo_mt,
    ROUND(MAX(`Cargo Metric TONS`), 2) AS max_cargo_mt,
    ROUND(STDDEV_POP(`Cargo Metric TONS`), 2) AS std_dev_mt
FROM air_cargo_dataset;


-- 5. yearly trend
SELECT
    YEAR(`Activity Period Start Date`) AS year,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt,
    ROUND(SUM(`Cargo Weight LBS`), 2) AS total_cargo_lbs
FROM air_cargo_dataset
GROUP BY YEAR(`Activity Period Start Date`)
ORDER BY year;


-- 6. top 10 airlines by cargo
SELECT
    `Operating Airline`,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt,
    ROUND(SUM(`Cargo Weight LBS`), 2) AS total_cargo_lbs
FROM air_cargo_dataset
GROUP BY `Operating Airline`
ORDER BY total_cargo_mt DESC
LIMIT 10;


-- 7. domestic vs international (with % share)
SELECT
    `GEO Summary`,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt,
    ROUND(100 * SUM(`Cargo Metric TONS`) /
          NULLIF((SELECT SUM(`Cargo Metric TONS`) FROM air_cargo_dataset), 0), 2) AS share_percent
FROM air_cargo_dataset
GROUP BY `GEO Summary`
ORDER BY total_cargo_mt DESC;


-- 8. cargo vs mail
SELECT
    `Cargo Type Code`,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt,
    ROUND(SUM(`Cargo Weight LBS`), 2) AS total_cargo_lbs
FROM air_cargo_dataset
GROUP BY `Cargo Type Code`
ORDER BY total_cargo_mt DESC;

-- same thing year wise
SELECT
    YEAR(`Activity Period Start Date`) AS year,
    `Cargo Type Code`,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt
FROM air_cargo_dataset
GROUP BY YEAR(`Activity Period Start Date`), `Cargo Type Code`
ORDER BY year, `Cargo Type Code`;


-- 9. enplaned vs deplaned
SELECT
    `Activity Type Code`,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt,
    ROUND(SUM(`Cargo Weight LBS`), 2) AS total_cargo_lbs
FROM air_cargo_dataset
GROUP BY `Activity Type Code`
ORDER BY total_cargo_mt DESC;

-- year wise
SELECT
    YEAR(`Activity Period Start Date`) AS year,
    `Activity Type Code`,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt
FROM air_cargo_dataset
GROUP BY YEAR(`Activity Period Start Date`), `Activity Type Code`
ORDER BY year, `Activity Type Code`;


-- 10. cargo by aircraft type
SELECT
    `Cargo Aircraft Type`,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt
FROM air_cargo_dataset
GROUP BY `Cargo Aircraft Type`
ORDER BY total_cargo_mt DESC;


-- 11. cargo by region
SELECT
    `GEO Region`,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt,
    ROUND(SUM(`Cargo Weight LBS`), 2) AS total_cargo_lbs
FROM air_cargo_dataset
GROUP BY `GEO Region`
ORDER BY total_cargo_mt DESC;


-- 12. international only
SELECT
    COUNT(*) AS intl_records,
    COUNT(DISTINCT `Operating Airline`) AS intl_airlines,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS intl_cargo_mt
FROM air_cargo_dataset
WHERE `GEO Summary` = 'International';


-- 13. airline performance per year
SELECT
    YEAR(`Activity Period Start Date`) AS year,
    `Operating Airline`,
    COUNT(*) AS total_records,
    ROUND(SUM(`Cargo Metric TONS`), 2) AS total_cargo_mt
FROM air_cargo_dataset
GROUP BY YEAR(`Activity Period Start Date`), `Operating Airline`
ORDER BY year, total_cargo_mt DESC;


-- 14. distinct values (to validate the categories)
SELECT DISTINCT `GEO Summary` FROM air_cargo_dataset ORDER BY `GEO Summary`;
SELECT DISTINCT `GEO Region` FROM air_cargo_dataset ORDER BY `GEO Region`;
SELECT DISTINCT `Cargo Type Code` FROM air_cargo_dataset ORDER BY `Cargo Type Code`;
SELECT DISTINCT `Activity Type Code` FROM air_cargo_dataset ORDER BY `Activity Type Code`;
SELECT DISTINCT `Cargo Aircraft Type` FROM air_cargo_dataset ORDER BY `Cargo Aircraft Type`;

-------------------- ****** --------------------