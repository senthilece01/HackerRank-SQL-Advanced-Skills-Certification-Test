WITH hours_worked AS (
    SELECT
        emp_id,
        CASE
            WHEN MINUTE(TIMESTAMP) >= MINUTE(LAG(TIMESTAMP) OVER(PARTITION BY DATE(TIMESTAMP), emp_id ORDER BY TIMESTAMP)) THEN HOUR(TIMESTAMP) - HOUR(LAG(TIMESTAMP) OVER(PARTITION BY DATE(TIMESTAMP), emp_id ORDER BY TIMESTAMP))
            ELSE HOUR(TIMESTAMP) - HOUR(LAG(TIMESTAMP) OVER(PARTITION BY DATE(TIMESTAMP), emp_id ORDER BY TIMESTAMP)) - 1
        END AS hours_worked
    FROM attendance
    -- only weekends
    WHERE DAYOFWEEK(TIMESTAMP) IN (1, 7)
)
SELECT
    emp_id,
    SUM(hours_worked) AS hours_worked
FROM hours_worked
GROUP BY emp_id
ORDER BY hours_worked DESC;