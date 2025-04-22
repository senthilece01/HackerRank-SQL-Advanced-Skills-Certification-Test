/*
Enter your query below.
Please append a semicolon ";" at the end of the query.
*/

SELECT 
    MONTH(STR_TO_DATE(record_date, '%Y-%m-%d')) AS month,
    MAX(CASE WHEN data_type = 'max' THEN data_value END) AS max,
    MIN(CASE WHEN data_type = 'min' THEN data_value END) AS min,
    ROUND(AVG(CASE WHEN data_type = 'avg' THEN data_value END)) AS avg
FROM temperature_records
GROUP BY MONTH(STR_TO_DATE(record_date, '%Y-%m-%d'))
ORDER BY month;
