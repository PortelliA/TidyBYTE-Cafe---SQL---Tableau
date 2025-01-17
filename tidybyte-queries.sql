-- Query to calculate total orders, total items, total sales, and average order value
SELECT
    COUNT(DISTINCT id) AS Count_of_Sales,
    (SELECT COUNT(id) FROM transaction_items) Count_of_items,
    CONCAT('$', SUM(amount)) AS Total_Sales,
    CONCAT('$', ROUND(AVG(amount), 2)) AS Average_order
FROM
    transactions;


-- Query to count sales by item category
SELECT 
    i.item_name, COUNT(i.item_name) AS Count
FROM 
    item i
JOIN 
    transaction_items te ON te.item_id = i.id
GROUP BY i.item_name
ORDER BY Count DESC;



-- Sales By Hour
SELECT
	CONCAT(HOUR(date_time), ':00') AS Hour,
    SUM(amount) AS total_sales,
    COUNT(amount) AS Count_of_Sales
FROM 
	transactions
GROUP BY Hour;


-- Sales by Day
SELECT 
	date_format(date_time, "%W") AS Day,
    SUM(amount)AS total_sales,
    COUNT(amount) AS Count_of_Sales
FROM 
	transactions
GROUP BY Day;

-- Sales by Month
SELECT
	DATE_FORMAT(date_time, "%M") AS Month,
    SUM(amount) AS total_sales,
    COUNT(amount) AS Count_of_Sales
FROM
	transactions
GROUP BY Month;



-- Sales by hour with cost per hour
WITH recipesummary AS (
	SELECT  r.recipe_id, SUM(r.amount / i.volume) AS `usage`, i.cost
	FROM recipe r
	JOIN ingredients i ON r.ingredient_id = i.id
	GROUP BY r.recipe_id, i.cost
),
recipecalculation AS (
	SELECT it.id, item_name, price, SUM(rs.usage * rs.cost) AS cost
	FROM item it
	JOIN recipesummary rs ON rs.recipe_id = it.recipe_id
	GROUP BY it.id, item_name
),
ordercalculation AS (
SELECT
	ti.transaction_id, date_time, SUM(price) AS order_price, SUM(cost) AS order_cost
FROM
	(SELECT tt.*, t.date_time FROM transaction_items tt JOIN transactions t on t.id = tt.transaction_id)ti
JOIN
	recipecalculation rc ON rc.id = ti.item_id
GROUP BY transaction_id, date_time
)
SELECT
    DATE_FORMAT(date_time, '%Y-%m-%d %H:00') AS formatted_date_time,
    SUM(order_price) AS sales_per_hour,
    ROUND(SUM(order_cost), 2) AS cost_per_hour
FROM
	ordercalculation
GROUP BY formatted_date_time;
    



-- Number of hours worked by each staff member per month
WITH EmployeeHours AS (
	SELECT DISTINCT
		HOUR(date_time) AS Hour,
		DATE(date_time) AS date,
		on_shift1 AS employee_id
	FROM transactions
	UNION ALL
	SELECT DISTINCT 
		HOUR(date_time) AS Hour,
		DATE(date_time) AS date,
		on_shift2 AS employee_id
	FROM transactions
    )
    SELECT 
		employee_id,
        CONCAT(first_name, ' ', last_name) AS employee_name,
        DATE_FORMAT(date, '%M') AS month,
		COUNT(employee_id) AS total_hours
	FROM EmployeeHours eh
    JOIN staff s ON eh.employee_id = s.id
    GROUP BY employee_id, month;



-- Ranking articles sold by Category
-- SELECT
-- 	category,
--     item_name,
--     count
-- FROM (
	SELECT
		i.id,
        i.category,
        i.item_name,
        COUNT(te.item_id) AS count,
        RANK() OVER (PARTITION BY i.category ORDER BY COUNT(te.item_id) DESC) AS ranking
	FROM
		item i
	JOIN
		transaction_items te ON te.item_id = i.id
	GROUP BY i.id, i.category, i.item_name
--     ) AS ranked_items
-- WHERE ranking = 1
;
# using subquery you can find rank 1 from each category


-- Query to find usage of ingredients per day, desplaying the total units used
SELECT
	i.id AS ingredient_id,
    COUNT(*) AS times_was_used,
    i.i_name AS Product_name,
    DATE_FORMAT(t.date_time, '%Y-%m-%d') AS date,
    ROUND(SUM(r.amount / i.volume), 2) AS total_usage
FROM
	recipe r
JOIN
	ingredients i ON r.ingredient_id = i.id
JOIN 
	transaction_items te ON r.recipe_id = te.item_id
JOIN
	transactions t ON te.transaction_id = t.id
GROUP BY i.id, i.i_name, date
ORDER BY date, total_usage DESC;






# The queries above were just to trial how to go about using these functions and get my head around the dataset
# Below are the queries I will use in Tableau





-- Introduction dashboard
SELECT 
	ROW_NUMBER() OVER() AS `Rank`,
    t.*
FROM
    (SELECT 
        CASE
            WHEN i.item_name LIKE '%Cappuccino' THEN 'Cappuccino'
            WHEN i.item_name LIKE '%Flat White' THEN 'Flat White'
            WHEN i.item_name LIKE '%Latte' THEN 'Latte'
            WHEN i.item_name LIKE '%Espresso' THEN 'Espresso'
            WHEN i.item_name LIKE '%Long Black' THEN 'Long Black'
            ELSE 'x' END AS Coffee_Style,
            COUNT(*) AS Count
    FROM 
        item i
    JOIN transaction_items te ON te.item_id = i.id
    GROUP BY Coffee_Style
    ORDER BY Count DESC) AS t
WHERE
    Coffee_Style != 'x';



-- Sales Dashboard  part 1
WITH recipesummary AS (
	SELECT
		r.recipe_id, 
        SUM(r.amount / i.volume) AS `usage`,
        i.cost
	FROM
		recipe r
	JOIN 
		ingredients i ON r.ingredient_id = i.id
	GROUP BY r.recipe_id, i.cost
),
recipecalucation AS (
	SELECT 
		it.id,
        item_name,
        price, 
        SUM(rs.usage * rs.cost) AS cost
	FROM
		item it
	JOIN 
		recipesummary rs ON rs.recipe_id = it.recipe_id
	GROUP BY it.id, item_name
),
ordercalculation AS (
	SELECT
        DATE_FORMAT(date_time, '%Y-%m-%d %H:00') AS date_hour, 
        SUM(price) AS sales_per_hour, 
        SUM(cost) AS cost_per_hour
	FROM 
		(SELECT tt.*, t.date_time FROM transaction_items tt JOIN transactions t on t.id = tt.transaction_id)ti
	JOIN 
		recipecalucation rc ON rc.id = ti.item_id
    GROUP BY date_hour
    ),
ItemsSoldCalculation AS(
SELECT
    DATE_FORMAT(t.date_time, '%Y-%m-%d %H:00') AS date_hour,
    COUNT(ti.id) AS count_of_items
FROM
    transaction_items ti
JOIN
    transactions t ON t.id = ti.transaction_id
GROUP BY
    date_hour
ORDER BY
    date_hour
),
SalesCalculation AS(
SELECT
    DATE_FORMAT(date_time, '%Y-%m-%d %H:00') AS date_hour,
    SUM(amount) AS sales_per_hour,
    AVG(amount) AS avg_per_hour,
    COUNT(*) AS count_of_sales
FROM 
	transactions
GROUP BY date_hour
)
SELECT 
	ROW_NUMBER() OVER() AS row_id, 
	sc.*, 
	count_of_items, 
	cost_per_hour
FROM
	SalesCalculation sc
JOIN
	ordercalculation oc ON sc.date_hour = oc.date_hour
Join
	itemsSoldCalculation isc ON isc.date_hour = sc.date_hour;



# Sales Dashboard part 2
WITH EmployeeShifts AS (
	SELECT
		DATE_FORMAT(date_time, '%Y-%m-%d %H:00') AS date_hour,
        DATE(date_time) AS date,
        DATE_FORMAT(date_time, '%W') AS Day,
        on_shift1 AS employee_id,
        hourly_rate,
        position
	FROM 
		transactions
	JOIN 	
		staff s ON s.id = on_shift1	
	GROUP BY date_hour, date, day, employee_id, hourly_rate, position
UNION ALL
	SELECT
		DATE_FORMAT(date_time, '%Y-%m-%d %H:00') AS date_hour,
        DATE(date_time) AS date,
        DATE_FORMAT(date_time, '%W') AS Day,
        on_shift2 AS employee_id,
        hourly_rate,
        position
	FROM
		transactions
	JOIN
		staff s ON s.id = on_shift2
	GROUP BY date_hour, date, day, employee_id, hourly_rate, position
),
Holidays AS ( -- I saw someone on YouTube do this, I was waiting for a chance to try this out. 
	SELECT
		'2024-03-29' AS date UNION
        SELECT '2024-03-30' UNION
        SELECT '2024-03-31' UNION
        SELECT '2024-04-01' UNION
        SELECT '2024-04-25' UNION
        SELECT '2024-06-10'
),
HourlyRates AS ( 
	SELECT 
		date_hour,
        day,
		CASE
			WHEN holiday = 'Yes' AND position != 'Manager' THEN hourly_rate * 2.5
            WHEN holiday = 'No' AND day = 'Saturday' AND (position = 'Part-time' OR position = 'Casual') THEN hourly_rate * 1.5 
			ELSE hourly_rate 
		END AS adjusted_hourly_rate
    FROM
		(SELECT
			es.date_hour,
			es.date,
				CASE 
					WHEN h.date IS NOT NULL THEN 'Yes' ELSE 'No' 
                END AS holiday,
			es.day,
			es.employee_id,
			es.position,
			hourly_rate
		FROM
			employeeShifts es
		LEFT JOIN
			Holidays h ON es.date = h.date) t
)
SELECT
	ROW_NUMBER() OVER() as row_id,
    date_hour,
    day,
    SUM(adjusted_hourly_rate) AS hourly_wage_cost
FROM 
	HourlyRates 
GROUP BY date_hour, day;



# Inventory Dashboard  part 1
WITH TransactionSummary AS (
    SELECT
        t.id AS transaction_id,
        te.item_id,
        r.recipe_id,
        it.item_name AS menu_product,
        it.category,
        DATE_FORMAT(t.date_time, '%Y-%m-%d') AS date
    FROM
        transactions t 
    JOIN
        transaction_items te ON t.id = te.transaction_id
    JOIN
        item it ON te.item_id = it.id
    JOIN 
        recipe r ON it.recipe_id = r.recipe_id
),
IngredientUsage AS (
    SELECT
        r.ingredient_id,
        r.recipe_id,
        COUNT(*) AS times_was_used,
        SUM(r.amount / i.volume) AS total_usage
    FROM
        recipe r
    JOIN 
        ingredients i ON r.ingredient_id = i.id
    GROUP BY 
        r.recipe_id, r.ingredient_id
)
SELECT
    ts.transaction_id,
    iu.ingredient_id,
    iu.recipe_id,
    iu.times_was_used,
    ing.i_name AS product_name,
    ts.menu_product,
    ts.category,
    ts.date,
    iu.total_usage AS total_usage
FROM
    TransactionSummary ts
JOIN 
    IngredientUsage iu ON ts.recipe_id = iu.recipe_id
JOIN 
    ingredients ing ON iu.ingredient_id = ing.id
GROUP BY 
	ts.transaction_id, iu.ingredient_id, iu.recipe_id, 
    iu.times_was_used, ing.i_name, ts.menu_product,
    ts.category, ts.date, iu.total_usage
ORDER BY  ts.date, product_name, iu.total_usage DESC;



# Inventory Dashboard part 2
WITH recipesummary AS (
SELECT  
	r.recipe_id, 
    SUM(r.amount / i.volume) AS `usage`, 
    i.cost
FROM 
	recipe r
JOIN 
	ingredients i ON r.ingredient_id = i.id
GROUP BY r.recipe_id, i.cost
)
SELECT 
	it.id,
    COUNT(DISTINCT ti.id) AS count,
    item_name, 
    price, 
    SUM(DISTINCT rs.usage * rs.cost) AS cost
FROM 
	item it
JOIN 
	recipesummary rs ON rs.recipe_id = it.recipe_id
JOIN 
	transaction_items ti ON ti.item_id = it.id
GROUP BY it.id, item_name;