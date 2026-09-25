-- =====================================================
-- QUESTION 1
-- Which products have less than 20 items in stock?
-- Sort the results by stock quantity in ascending order.
-- =====================================================

SELECT
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity < 20
ORDER BY stock_quantity ASC;


-- =====================================================
-- QUESTION 2
-- What products are currently out of stock?
-- =====================================================

SELECT
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity = 0;


-- =====================================================
-- QUESTION 3
-- Calculate the profit margin percentage for each product.
-- Which products have the highest profit margins?
-- =====================================================

SELECT
    product_name,
    price,
    cost,
    ROUND(((price - cost) / price) * 100, 2) AS profit_margin_percentage
FROM products
ORDER BY profit_margin_percentage DESC;

-- =====================================================
-- QUESTION 4
-- Find all products that have no assigned category
-- or supplier.
-- =====================================================

SELECT
    product_id,
    product_name,
    category_id,
    supplier_id
FROM products
WHERE category_id IS NULL
   OR supplier_id IS NULL;

-- =====================================================
-- QUESTION 5
-- List all products along with their category name
-- and supplier name.
-- Include products without a category or supplier.
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    s.supplier_name
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.category_id
LEFT JOIN suppliers s
    ON p.supplier_id = s.supplier_id;


    -- =====================================================
-- QUESTION 6
-- Find all products with their category and supplier,
-- but only show products that have a category assigned.
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    s.supplier_name
FROM products p
INNER JOIN categories c
    ON p.category_id = c.category_id
LEFT JOIN suppliers s
    ON p.supplier_id = s.supplier_id;

    -- =====================================================
-- QUESTION 7
-- Find all products that belong to the Camping department.
-- =====================================================

SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    c.department
FROM products p
INNER JOIN categories c
    ON p.category_id = c.category_id
WHERE c.department = 'Camping';