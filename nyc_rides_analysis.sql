--NYC Uber & Lyft Ride Analysis--

---JOIN QUERIES---

-- Top 10 busiest pickup zones in January 2026
SELECT taxi_zones.zone,COUNT(*) AS total_trips
FROM rides_clean
JOIN taxi_zones
	ON taxi_zones.locationid = rides_clean.pulocationid
GROUP BY 
	taxi_zones.zone
ORDER BY total_trips DESC
LIMIT 10
;

-- Busiest pickup zones by company
SELECT company, zone, COUNT(*) AS total_trips
FROM rides_clean
JOIN taxi_zones
	ON taxi_zones.locationid = rides_clean.pulocationid
WHERE company = 'Uber'
GROUP BY company, zone
ORDER BY total_trips DESC
LIMIT 10
;

SELECT company, zone, COUNT(*) AS total_trips
FROM rides_clean
JOIN taxi_zones
	ON taxi_zones.locationid = rides_clean.pulocationid
WHERE company = 'Lyft'
GROUP BY company, zone
ORDER BY total_trips DESC
LIMIT 10
;

-- Busiest boroughs
SELECT borough, COUNT(*) AS total_trips
FROM rides_clean
JOIN taxi_zones
	ON taxi_zones.locationid = rides_clean.pulocationid
GROUP BY borough
ORDER BY total_trips DESC
;



-- Top 10 most common pickup → drop-off routes

SELECT
    pickup.zone AS pickup_zone,
    dropoff.zone AS dropoff_zone,
    COUNT(*) AS total_trips
FROM rides_clean AS r
JOIN taxi_zones AS pickup
    ON r.pulocationid = pickup.locationid
JOIN taxi_zones AS dropoff
    ON r.dolocationid = dropoff.locationid
GROUP BY
    pickup.zone,
    dropoff.zone
ORDER BY total_trips DESC
LIMIT 10;



---OTHER QUERIES---

-- Which company had more trips?
SELECT
    company,
    COUNT(*) AS total_trips
FROM rides_clean
GROUP BY company
ORDER BY total_trips DESC;


-- What was the average trip distance by company?'
SELECT
    company,
    ROUND(AVG(trip_miles)::NUMERIC, 2) AS avg_trip_miles
FROM rides_clean
GROUP BY company;



-- What was the average passenger fare by company?
SELECT
    company,
    ROUND(AVG(base_passenger_fare), 2) AS avg_fare
FROM rides_clean
GROUP BY company;



-- Uber vs Lyft by hour
SELECT
    EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,
    company,
    COUNT(*) AS total_trips
FROM rides_clean
GROUP BY pickup_hour, company
ORDER BY pickup_hour, company;




-- Busiest day of the week
SELECT
    TO_CHAR(pickup_datetime, 'Day') AS day_of_week,
    COUNT(*) AS total_trips
FROM rides_clean
GROUP BY
    TO_CHAR(pickup_datetime, 'Day'),
    EXTRACT(DOW FROM pickup_datetime)
ORDER BY EXTRACT(DOW FROM pickup_datetime);




-- Average fare per mile
SELECT
    company,
    ROUND(
        AVG(base_passenger_fare / NULLIF(trip_miles, 0))::NUMERIC,
        2
    ) AS avg_fare_per_mile
FROM rides_clean
GROUP BY company;


-- Percentage of rides receiving a tip
SELECT
    company,
    ROUND(
        100.0 * SUM(CASE WHEN tips > 0 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS tipped_trip_pct
FROM rides_clean
GROUP BY company;

