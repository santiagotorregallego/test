WITH customers AS (
  SELECT
    id AS customer_id,  -- Use the actual column name 'id' instead of 'custoner-1d'
    first_name,
    last_name
  FROM raw.jaffle_shop.customers
),
orders AS (
  SELECT
    id AS order_id,  -- Use the actual column name 'id' instead of 'order_1d'
    user_id AS customer_id,  -- Match the column name from the 'customers' CTE
    order_date,
    status
  FROM raw.jaffle_shop.orders  -- Assuming the table name is 'orders' (corrected typo)
),
-- No semicolon (;) needed at the end
customer_orders AS (
  SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS most_recent_order_date,
    COUNT(order_id) AS number_of_orders
  FROM orders
  GROUP BY customer_id
),
final AS (
  SELECT
    co.customer_id,
    c.first_name,  -- Assuming 'first_name' exists in the 'customers' table
    c.last_name,
    co.first_order_date,
    co.most_recent_order_date,
    COALESCE(co.number_of_orders, 0) AS number_of_orders  -- Use 0 for missing values
  FROM customers AS c
  LEFT JOIN customer_orders AS co ON c.customer_id = co.customer_id
) 
select * from final