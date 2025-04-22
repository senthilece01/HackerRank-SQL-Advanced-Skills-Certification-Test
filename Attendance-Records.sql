/*
Enter your query below.
Please append a semicolon ";" at the end of the query.
*/

WITH weekend_data AS (
    SELECT 
        emp_id, 
        STR_TO_DATE(`timestamp`, '%Y-%m-%d %H:%i:%s') AS datetime,
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY STR_TO_DATE(`timestamp`, '%Y-%m-%d %H:%i:%s')) AS rn
    FROM attendance
    WHERE WEEKDAY(STR_TO_DATE(`timestamp`, '%Y-%m-%d %H:%i:%s')) IN (5, 6) -- Saturday (5) & Sunday (6)
),
paired_data AS (
    SELECT 
        w1.emp_id,
        TIMESTAMPDIFF(HOUR, w1.datetime, w2.datetime) AS hours_worked
    FROM weekend_data w1
    JOIN weekend_data w2 
        ON w1.emp_id = w2.emp_id 
        AND w1.rn % 2 = 1 -- Take only odd rows as IN times
        AND w2.rn = w1.rn + 1 -- Match with the next timestamp (OUT time)
)
SELECT emp_id, SUM(hours_worked) AS work_hours
FROM paired_data
GROUP BY emp_id
ORDER BY work_hours DESC;
