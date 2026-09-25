-- ==================================================
-- QUESTION 1
-- Which product categories generate the most revenue?
-- Rank categories by total sales amount.
-- ==================================================

SELECT
    c.category_name,
    SUM(si.quantity * si.price_sold) AS total_sales_amount
FROM sale_items si
JOIN products p
    ON si.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales_amount DESC;

-- ==================================================
-- QUESTION 2
-- Identify the top 5 most frequently purchased
-- products along with their total quantity sold.
-- ==================================================

SELECT
    p.product_name,
    SUM(si.quantity) AS total_quantity_sold
FROM sale_items si
JOIN products p
    ON si.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- ==================================================
-- QUESTION 3
-- For each customer, list their name, email,
-- number of purchases, and most recent purchase date.
-- ==================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(s.sale_id) AS number_of_purchases,
    MAX(s.sale_date) AS most_recent_purchase
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
ORDER BY number_of_purchases DESC;

-- ==================================================
-- QUESTION 4
-- Calculate the total amount spent by each customer.
-- Sort by total spend in descending order.
-- ==================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    SUM(si.quantity * si.price_sold) AS total_spent
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
JOIN sale_items si
    ON s.sale_id = si.sale_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
ORDER BY total_spent DESC;

-- ==================================================
-- QUESTION 5
-- Calculate the average rating given by customers
-- in each loyalty tier.
-- ==================================================

SELECT
    c.loyalty_tier,
    ROUND(AVG(pr.rating), 2) AS average_rating
FROM customers c
JOIN product_reviews pr
    ON c.customer_id = pr.customer_id
GROUP BY c.loyalty_tier
ORDER BY average_rating DESC;

-- ==================================================
-- QUESTION 6
-- Identify customers who have made purchases
-- but have never left a product review.
-- ==================================================

SELECT DISTINCT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
LEFT JOIN product_reviews pr
    ON c.customer_id = pr.customer_id
WHERE pr.customer_id IS NULL
ORDER BY c.customer_id;

-- ==================================================
-- QUESTION 7
-- Identify customers who increased their spending
-- in Q2 2023 compared to Q1 2023.
-- ==================================================

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COALESCE(SUM(
        CASE
            WHEN s.sale_date >= '2023-01-01'
             AND s.sale_date < '2023-04-01'
            THEN si.quantity * si.price_sold
            ELSE 0
        END
    ), 0) AS q1_spending,
    COALESCE(SUM(
        CASE
            WHEN s.sale_date >= '2023-04-01'
             AND s.sale_date < '2023-07-01'
            THEN si.quantity * si.price_sold
            ELSE 0
        END
    ), 0) AS q2_spending
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
JOIN sale_items si
    ON s.sale_id = si.sale_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING
    SUM(
        CASE
            WHEN s.sale_date >= '2023-04-01'
             AND s.sale_date < '2023-07-01'
            THEN si.quantity * si.price_sold
            ELSE 0
        END
    )
    >
    SUM(
        CASE
            WHEN s.sale_date >= '2023-01-01'
             AND s.sale_date < '2023-04-01'
            THEN si.quantity * si.price_sold
            ELSE 0
        END
    )
ORDER BY q2_spending DESC;


-- ==================================================
-- QUESTION 8
-- Find the favorite product categories for
-- Gold tier customers based on purchase history.
-- ==================================================

SELECT
    c.loyalty_tier,
    cat.category_name,
    SUM(si.quantity) AS total_quantity_purchased
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
JOIN sale_items si
    ON s.sale_id = si.sale_id
JOIN products p
    ON si.product_id = p.product_id
JOIN categories cat
    ON p.category_id = cat.category_id
WHERE c.loyalty_tier = 'Gold'
GROUP BY
    c.loyalty_tier,
    cat.category_name
ORDER BY total_quantity_purchased DESC;


-- ==================================================
-- QUESTION 9
-- Calculate total sales amount and number of
-- transactions for each employee.
-- ==================================================

SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(si.quantity * si.price_sold) AS total_sales_amount,
    COUNT(DISTINCT s.sale_id) AS number_of_transactions
FROM employees e
JOIN sales s
    ON e.employee_id = s.employee_id
JOIN sale_items si
    ON s.sale_id = si.sale_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name
ORDER BY total_sales_amount DESC;


-- ==================================================
-- QUESTION 10
-- Identify the top 5 employees based on
-- total sales amount.
-- ==================================================

SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(si.quantity * si.price_sold) AS total_sales_amount,
    COUNT(DISTINCT s.sale_id) AS number_of_transactions
FROM employees e
JOIN sales s
    ON e.employee_id = s.employee_id
JOIN sale_items si
    ON s.sale_id = si.sale_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name
ORDER BY total_sales_amount DESC
LIMIT 5;

-- ==================================================
-- QUESTION 11
-- Calculate the total sales amount for each store.
-- Rank stores by total sales amount.
-- ==================================================

SELECT
    st.store_id,
    st.store_name,
    SUM(si.quantity * si.price_sold) AS total_sales_amount,
    COUNT(DISTINCT s.sale_id) AS number_of_transactions
FROM stores st
JOIN sales s
    ON st.store_id = s.store_id
JOIN sale_items si
    ON s.sale_id = si.sale_id
GROUP BY
    st.store_id,
    st.store_name
ORDER BY total_sales_amount DESC;

-- ==================================================
-- QUESTION 12
-- Identify the top-selling product category
-- by total sales amount.
-- ==================================================

SELECT
    cat.category_id,
    cat.category_name,
    SUM(si.quantity * si.price_sold) AS total_sales_amount,
    SUM(si.quantity) AS total_quantity_sold
FROM categories cat
JOIN products p
    ON cat.category_id = p.category_id
JOIN sale_items si
    ON p.product_id = si.product_id
GROUP BY
    cat.category_id,
    cat.category_name
ORDER BY total_sales_amount DESC
LIMIT 1;

-- ==================================================
-- QUESTION 13
-- Find the average transaction value for each employee.
-- Identify the employee with the highest average
-- sale amount.
-- ==================================================

SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(si.quantity * si.price_sold) /
        COUNT(DISTINCT s.sale_id) AS average_transaction_value,
    COUNT(DISTINCT s.sale_id) AS number_of_transactions
FROM employees e
JOIN sales s
    ON e.employee_id = s.employee_id
JOIN sale_items si
    ON s.sale_id = si.sale_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name
ORDER BY average_transaction_value DESC;


-- ==================================================
-- QUESTION 14
-- Create a report showing each store's name,
-- manager's name, number of employees,
-- and total sales amount.
-- ==================================================

SELECT
    st.store_name,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    COUNT(DISTINCT e.employee_id) AS number_of_employees,
    COALESCE(SUM(si.quantity * si.price_sold), 0) AS total_sales_amount
FROM stores st
JOIN employees m
    ON st.store_id = m.store_id
    AND m.position = 'Store Manager'
LEFT JOIN employees e
    ON st.store_id = e.store_id
LEFT JOIN sales s
    ON e.employee_id = s.employee_id
LEFT JOIN sale_items si
    ON s.sale_id = si.sale_id
GROUP BY
    st.store_id,
    st.store_name,
    m.employee_id,
    m.first_name,
    m.last_name
ORDER BY total_sales_amount DESC;

-- ==================================================
-- QUESTION 15
-- Identify stores where the average employee salary
-- is higher than the company-wide average.
-- ==================================================

SELECT
    st.store_id,
    st.store_name,
    AVG(e.salary) AS average_employee_salary
FROM stores st
JOIN employees e
    ON st.store_id = e.store_id
GROUP BY
    st.store_id,
    st.store_name
HAVING AVG(e.salary) > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY average_employee_salary DESC;


-- ==================================================
-- QUESTION 16
-- Create a product performance matrix that
-- categorizes products into four groups based on
-- sales volume and profit margin.
--
-- Stars: High sales, high margin
-- Volume Drivers: High sales, low margin
-- Opportunities: Low sales, high margin
-- Problems: Low sales, low margin
-- ==================================================

WITH product_performance AS (
    SELECT
        p.product_id,
        p.product_name,
        p.price,
        p.cost,
        COALESCE(SUM(si.quantity), 0) AS sales_volume,
        ((p.price - p.cost) / NULLIF(p.price, 0)) * 100
            AS profit_margin
    FROM products p
    LEFT JOIN sale_items si
        ON p.product_id = si.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.price,
        p.cost
),

benchmarks AS (
    SELECT
        AVG(sales_volume) AS average_sales_volume,
        AVG(profit_margin) AS average_profit_margin
    FROM product_performance
)

SELECT
    pp.product_id,
    pp.product_name,
    pp.sales_volume,
    ROUND(pp.profit_margin, 2) AS profit_margin,
    CASE
        WHEN pp.sales_volume >= b.average_sales_volume
             AND pp.profit_margin >= b.average_profit_margin
            THEN 'Stars'

        WHEN pp.sales_volume >= b.average_sales_volume
             AND pp.profit_margin < b.average_profit_margin
            THEN 'Volume Drivers'

        WHEN pp.sales_volume < b.average_sales_volume
             AND pp.profit_margin >= b.average_profit_margin
            THEN 'Opportunities'

        ELSE 'Problems'
    END AS performance_category
FROM product_performance pp
CROSS JOIN benchmarks b
ORDER BY
    performance_category,
    pp.sales_volume DESC;

-- ==================================================
-- QUESTION 17
-- Generate a management hierarchy report showing
-- the structure from store managers down to
-- sales associates for each store.
-- ==================================================

WITH RECURSIVE employee_hierarchy AS (

    -- Start with the store managers
    SELECT
        e.employee_id,
        e.store_id,
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        e.position,
        e.manager_id,
        1 AS hierarchy_level,
        CONCAT(e.first_name, ' ', e.last_name) AS hierarchy_path
    FROM employees e
    WHERE e.manager_id IS NULL

    UNION ALL

    -- Find employees who report to each manager
    SELECT
        e.employee_id,
        e.store_id,
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        e.position,
        e.manager_id,
        eh.hierarchy_level + 1 AS hierarchy_level,
        CONCAT(
            eh.hierarchy_path,
            ' → ',
            e.first_name,
            ' ',
            e.last_name
        ) AS hierarchy_path
    FROM employees e
    JOIN employee_hierarchy eh
        ON e.manager_id = eh.employee_id
)

SELECT
    st.store_name,
    eh.employee_id,
    eh.employee_name,
    eh.position,
    eh.manager_id,
    eh.hierarchy_level,
    eh.hierarchy_path
FROM employee_hierarchy eh
JOIN stores st
    ON eh.store_id = st.store_id
ORDER BY
    st.store_id,
    eh.hierarchy_path;

-- ============================================================
-- QUESTION 18
-- Create a comprehensive customer analysis showing purchasing
-- patterns of customers in different loyalty tiers, including
-- average transaction value, most purchased categories,
-- and number of products reviewed.
-- ============================================================

WITH customer_transactions AS (
    SELECT
        c.customer_id,
        c.loyalty_tier,
        COUNT(DISTINCT s.sale_id) AS number_of_transactions,
        COALESCE(SUM(s.total_amount), 0) AS total_spent,
        COALESCE(
            SUM(s.total_amount) / NULLIF(COUNT(DISTINCT s.sale_id), 0),
            0
        ) AS average_transaction_value
    FROM customers c
    LEFT JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.loyalty_tier
),

category_purchases AS (
    SELECT
        c.customer_id,
        c.loyalty_tier,
        cat.category_name,
        SUM(si.quantity) AS products_purchased
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    JOIN sale_items si
        ON s.sale_id = si.sale_id
    JOIN products p
        ON si.product_id = p.product_id
    JOIN categories cat
        ON p.category_id = cat.category_id
    GROUP BY
        c.customer_id,
        c.loyalty_tier,
        cat.category_name
),

most_purchased_category AS (
    SELECT
        customer_id,
        category_name,
        products_purchased,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY products_purchased DESC
        ) AS category_rank
    FROM category_purchases
),

customer_reviews AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT pr.review_id) AS products_reviewed
    FROM customers c
    LEFT JOIN product_reviews pr
        ON c.customer_id = pr.customer_id
    GROUP BY
        c.customer_id
)

SELECT
    ct.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ct.loyalty_tier,
    ct.number_of_transactions,
    ROUND(ct.total_spent, 2) AS total_spent,
    ROUND(ct.average_transaction_value, 2) AS average_transaction_value,
    mpc.category_name AS most_purchased_category,
    COALESCE(cr.products_reviewed, 0) AS products_reviewed
FROM customer_transactions ct
JOIN customers c
    ON ct.customer_id = c.customer_id
LEFT JOIN most_purchased_category mpc
    ON ct.customer_id = mpc.customer_id
    AND mpc.category_rank = 1
LEFT JOIN customer_reviews cr
    ON ct.customer_id = cr.customer_id
ORDER BY
    ct.loyalty_tier,
    ct.total_spent DESC;

    -- ============================================================
-- QUESTION 19
-- Identify stores where the average employee salary is higher
-- than the company-wide average salary.
-- ============================================================

SELECT
    s.store_name,
    ROUND(AVG(e.salary), 2) AS average_store_salary,
    ROUND(
        (SELECT AVG(salary) FROM employees),
        2
    ) AS company_wide_average_salary
FROM employees e
JOIN stores s
    ON e.store_id = s.store_id
GROUP BY
    s.store_id,
    s.store_name
HAVING AVG(e.salary) > (
    SELECT AVG(salary)
    FROM employees
)
ORDER BY average_store_salary DESC;


-- ============================================================
-- QUESTION 20
-- Create a product performance matrix based on sales volume
-- and profit margin.
--
-- Stars: High sales, high margin
-- Volume Drivers: High sales, low margin
-- Opportunities: Low sales, high margin
-- Problems: Low sales, low margin
-- ============================================================

WITH product_performance AS (
    SELECT
        p.product_id,
        p.product_name,
        p.price,
        p.cost,
        COALESCE(SUM(si.quantity), 0) AS sales_volume,
        COALESCE(SUM(si.quantity * si.price_sold), 0) AS total_revenue,
        COALESCE(SUM(si.quantity * p.cost), 0) AS total_cost
    FROM products p
    LEFT JOIN sale_items si
        ON p.product_id = si.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.price,
        p.cost
),

product_metrics AS (
    SELECT
        product_id,
        product_name,
        sales_volume,
        total_revenue,
        total_cost,
        CASE
            WHEN total_revenue = 0 THEN 0
            ELSE (total_revenue - total_cost) / total_revenue * 100
        END AS profit_margin
    FROM product_performance
),

thresholds AS (
    SELECT
        AVG(sales_volume) AS average_sales_volume,
        AVG(profit_margin) AS average_profit_margin
    FROM product_metrics
)

SELECT
    pm.product_id,
    pm.product_name,
    pm.sales_volume,
    ROUND(pm.profit_margin, 2) AS profit_margin,
    CASE
        WHEN pm.sales_volume >= t.average_sales_volume
             AND pm.profit_margin >= t.average_profit_margin
            THEN 'Stars'

        WHEN pm.sales_volume >= t.average_sales_volume
             AND pm.profit_margin < t.average_profit_margin
            THEN 'Volume Drivers'

        WHEN pm.sales_volume < t.average_sales_volume
             AND pm.profit_margin >= t.average_profit_margin
            THEN 'Opportunities'

        ELSE 'Problems'
    END AS performance_group
FROM product_metrics pm
CROSS JOIN thresholds t
ORDER BY
    performance_group,
    pm.sales_volume DESC;

-- ============================================================
-- QUESTION 21
-- Generate a management hierarchy report showing the structure
-- from store managers down to sales associates for each store.
-- ============================================================

WITH RECURSIVE employee_hierarchy AS (

    -- Start with store managers
    SELECT
        e.employee_id,
        e.store_id,
        e.first_name,
        e.last_name,
        e.position,
        e.manager_id,
        1 AS hierarchy_level,
        CONCAT(e.first_name, ' ', e.last_name) AS hierarchy_path
    FROM employees e
    WHERE LOWER(e.position) LIKE '%manager%'
      AND e.manager_id IS NULL

    UNION ALL

    -- Find employees reporting to each manager
    SELECT
        e.employee_id,
        e.store_id,
        e.first_name,
        e.last_name,
        e.position,
        e.manager_id,
        eh.hierarchy_level + 1 AS hierarchy_level,
        CONCAT(
            eh.hierarchy_path,
            ' -> ',
            e.first_name,
            ' ',
            e.last_name
        ) AS hierarchy_path
    FROM employees e
    JOIN employee_hierarchy eh
        ON e.manager_id = eh.employee_id
)

SELECT
    s.store_name,
    eh.employee_id,
    CONCAT(eh.first_name, ' ', eh.last_name) AS employee_name,
    eh.position,
    eh.manager_id,
    eh.hierarchy_level,
    eh.hierarchy_path
FROM employee_hierarchy eh
JOIN stores s
    ON eh.store_id = s.store_id
ORDER BY
    s.store_id,
    eh.hierarchy_path;


    -- ============================================================
-- QUESTION 22
-- Create a comprehensive customer analysis showing purchasing
-- patterns of customers in different loyalty tiers, including
-- average transaction value, most purchased categories,
-- and number of products reviewed.
-- ============================================================

WITH customer_transactions AS (
    SELECT
        c.customer_id,
        c.loyalty_tier,
        COUNT(DISTINCT s.sale_id) AS number_of_transactions,
        COALESCE(SUM(s.total_amount), 0) AS total_spent,
        COALESCE(
            SUM(s.total_amount)
            / NULLIF(COUNT(DISTINCT s.sale_id), 0),
            0
        ) AS average_transaction_value
    FROM customers c
    LEFT JOIN sales s
        ON c.customer_id = s.customer_id
    GROUP BY
        c.customer_id,
        c.loyalty_tier
),

category_purchases AS (
    SELECT
        c.customer_id,
        c.loyalty_tier,
        cat.category_name,
        SUM(si.quantity) AS products_purchased
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
    JOIN sale_items si
        ON s.sale_id = si.sale_id
    JOIN products p
        ON si.product_id = p.product_id
    JOIN categories cat
        ON p.category_id = cat.category_id
    GROUP BY
        c.customer_id,
        c.loyalty_tier,
        cat.category_name
),

most_purchased_category AS (
    SELECT
        customer_id,
        category_name,
        products_purchased,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY products_purchased DESC
        ) AS category_rank
    FROM category_purchases
),

customer_reviews AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT pr.review_id) AS products_reviewed
    FROM customers c
    LEFT JOIN product_reviews pr
        ON c.customer_id = pr.customer_id
    GROUP BY
        c.customer_id
)

SELECT
    ct.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ct.loyalty_tier,
    ct.number_of_transactions,
    ROUND(ct.total_spent, 2) AS total_spent,
    ROUND(ct.average_transaction_value, 2)
        AS average_transaction_value,
    mpc.category_name AS most_purchased_category,
    COALESCE(cr.products_reviewed, 0) AS products_reviewed
FROM customer_transactions ct
JOIN customers c
    ON ct.customer_id = c.customer_id
LEFT JOIN most_purchased_category mpc
    ON ct.customer_id = mpc.customer_id
    AND mpc.category_rank = 1
LEFT JOIN customer_reviews cr
    ON ct.customer_id = cr.customer_id
ORDER BY
    ct.loyalty_tier,
    ct.total_spent DESC;