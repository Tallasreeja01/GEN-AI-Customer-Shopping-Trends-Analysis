/*==============================================================
 AI-Augmented Customer Shopping Trends Analysis
 SQL Analysis Script

 Database : PostgreSQL
 Dataset  : Shopping Trends Dataset
 Records  : 3,900

==============================================================*/


/*==============================================================
SECTION 1 : DATA VALIDATION
==============================================================*/

-- 1. Total number of records
SELECT COUNT(*) AS total_records
FROM customer_shopping_trends;


-- 2. Check duplicate Customer IDs
SELECT customer_id,
       COUNT(*) AS duplicate_count
FROM customer_shopping_trends
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 3. Check NULL values
SELECT
COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
COUNT(*) FILTER (WHERE age IS NULL) AS null_age,
COUNT(*) FILTER (WHERE gender IS NULL) AS null_gender,
COUNT(*) FILTER (WHERE item_purchased IS NULL) AS null_item_purchased,
COUNT(*) FILTER (WHERE category IS NULL) AS null_category,
COUNT(*) FILTER (WHERE purchase_amount_usd IS NULL) AS null_purchase_amount_usd,
COUNT(*) FILTER (WHERE location IS NULL) AS null_location,
COUNT(*) FILTER (WHERE size IS NULL) AS null_size,
COUNT(*) FILTER (WHERE color IS NULL) AS null_color,
COUNT(*) FILTER (WHERE season IS NULL) AS null_season,
COUNT(*) FILTER (WHERE review_rating IS NULL) AS null_review_rating,
COUNT(*) FILTER (WHERE subscription_status IS NULL) AS null_subscription_status,
COUNT(*) FILTER (WHERE shipping_type IS NULL) AS null_shipping_type,
COUNT(*) FILTER (WHERE discount_applied IS NULL) AS null_discount_applied,
COUNT(*) FILTER (WHERE promo_code_used IS NULL) AS null_promo_code_used,
COUNT(*) FILTER (WHERE previous_purchases IS NULL) AS null_previous_purchases,
COUNT(*) FILTER (WHERE payment_method IS NULL) AS null_payment_method,
COUNT(*) FILTER (WHERE frequency_of_purchases IS NULL) AS null_frequency_of_purchases
FROM customer_shopping_trends;


-- 4. Distinct Gender
SELECT COUNT(DISTINCT gender) AS distinct_gender_count
FROM customer_shopping_trends;


-- 5. Distinct Category
SELECT COUNT(DISTINCT category) AS distinct_category_count
FROM customer_shopping_trends;


-- 6. Distinct Season
SELECT COUNT(DISTINCT season) AS distinct_season_count
FROM customer_shopping_trends;


-- 7. Distinct Payment Methods
SELECT COUNT(DISTINCT payment_method) AS distinct_payment_method_count
FROM customer_shopping_trends;


-- 8. Preview Dataset
SELECT *
FROM customer_shopping_trends
LIMIT 10;



/*==============================================================
SECTION 2 : SALES ANALYSIS
==============================================================*/

-- Total Purchase Amount
SELECT SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends;


-- Average Purchase Amount
SELECT AVG(purchase_amount_usd) AS average_purchase_amount
FROM customer_shopping_trends;


-- Highest Purchase Amount
SELECT MAX(purchase_amount_usd) AS highest_purchase_amount
FROM customer_shopping_trends;


-- Lowest Purchase Amount
SELECT MIN(purchase_amount_usd) AS lowest_purchase_amount
FROM customer_shopping_trends;


-- Purchase Amount by Category
SELECT category,
       SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends
GROUP BY category
ORDER BY total_purchase_amount DESC;


-- Average Purchase Amount by Category
SELECT category,
       AVG(purchase_amount_usd) AS average_purchase_amount
FROM customer_shopping_trends
GROUP BY category
ORDER BY average_purchase_amount DESC;


-- Purchase Amount by Gender
SELECT gender,
       SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends
GROUP BY gender
ORDER BY total_purchase_amount DESC;


-- Average Purchase Amount by Gender
SELECT gender,
       AVG(purchase_amount_usd) AS average_purchase_amount
FROM customer_shopping_trends
GROUP BY gender
ORDER BY average_purchase_amount DESC;


-- Purchase Amount by Season
SELECT season,
       SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends
GROUP BY season
ORDER BY total_purchase_amount DESC;


-- Top 10 Locations
SELECT location,
       SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends
GROUP BY location
ORDER BY total_purchase_amount DESC
LIMIT 10;



/*==============================================================
SECTION 3 : CUSTOMER ANALYSIS
==============================================================*/

-- Customers by Gender
SELECT gender,
       COUNT(customer_id) AS total_customers
FROM customer_shopping_trends
GROUP BY gender
ORDER BY total_customers DESC;


-- Average Age by Gender
SELECT gender,
       AVG(age) AS average_age
FROM customer_shopping_trends
GROUP BY gender
ORDER BY average_age DESC;


-- Average Review Rating by Category
SELECT category,
       AVG(review_rating) AS average_review_rating
FROM customer_shopping_trends
GROUP BY category
ORDER BY average_review_rating DESC;


-- Subscription Status
SELECT subscription_status,
       COUNT(customer_id) AS total_customers
FROM customer_shopping_trends
GROUP BY subscription_status
ORDER BY total_customers DESC;


-- Previous Purchases by Subscription
SELECT subscription_status,
       AVG(previous_purchases) AS average_previous_purchases
FROM customer_shopping_trends
GROUP BY subscription_status
ORDER BY average_previous_purchases DESC;


-- Purchase Amount by Payment Method
SELECT payment_method,
       SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends
GROUP BY payment_method
ORDER BY total_purchase_amount DESC;


-- Purchase Amount by Shipping Type
SELECT shipping_type,
       SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends
GROUP BY shipping_type
ORDER BY total_purchase_amount DESC;


-- Purchase Amount by Discount
SELECT discount_applied,
       SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends
GROUP BY discount_applied
ORDER BY total_purchase_amount DESC;


-- Purchase Amount by Promo Code
SELECT promo_code_used,
       SUM(purchase_amount_usd) AS total_purchase_amount
FROM customer_shopping_trends
GROUP BY promo_code_used
ORDER BY total_purchase_amount DESC;


-- Purchase Frequency Distribution
SELECT frequency_of_purchases,
       COUNT(customer_id) AS total_customers
FROM customer_shopping_trends
GROUP BY frequency_of_purchases
ORDER BY total_customers DESC;



/*==============================================================
SECTION 4 : ADVANCED SQL
==============================================================*/

-- Customer Spending Classification
SELECT customer_id,
       purchase_amount_usd,
CASE
WHEN purchase_amount_usd < 50 THEN 'Low Spender'
WHEN purchase_amount_usd BETWEEN 50 AND 200 THEN 'Medium Spender'
ELSE 'High Spender'
END AS spender_category
FROM customer_shopping_trends
ORDER BY purchase_amount_usd DESC;


-- Rank Customers
SELECT customer_id,
purchase_amount_usd,
RANK() OVER(ORDER BY purchase_amount_usd DESC) AS rank_position
FROM customer_shopping_trends
ORDER BY rank_position
LIMIT 10;


-- Top Customer in Each Category
SELECT category,
customer_id,
purchase_amount_usd
FROM
(
SELECT category,
customer_id,
purchase_amount_usd,
ROW_NUMBER() OVER(PARTITION BY category
ORDER BY purchase_amount_usd DESC) AS row_num
FROM customer_shopping_trends
) ranked
WHERE row_num=1
ORDER BY category;


-- Running Total
SELECT customer_id,
purchase_amount_usd,
SUM(purchase_amount_usd)
OVER(ORDER BY customer_id) AS running_total
FROM customer_shopping_trends
ORDER BY customer_id;


-- Average Purchase by Category using CTE
WITH category_avg AS
(
SELECT category,
AVG(purchase_amount_usd) AS avg_purchase_amount
FROM customer_shopping_trends
GROUP BY category
)
SELECT *
FROM category_avg
ORDER BY avg_purchase_amount DESC;


-- Above Average Purchase
SELECT customer_id,
purchase_amount_usd
FROM customer_shopping_trends
WHERE purchase_amount_usd >
(
SELECT AVG(purchase_amount_usd)
FROM customer_shopping_trends
)
ORDER BY purchase_amount_usd DESC;


-- Top 5 Locations
SELECT location,
AVG(purchase_amount_usd) AS avg_purchase_amount
FROM customer_shopping_trends
GROUP BY location
ORDER BY avg_purchase_amount DESC
LIMIT 5;


-- Highest Purchase by Gender
SELECT gender,
MAX(purchase_amount_usd) AS highest_purchase_amount
FROM customer_shopping_trends
GROUP BY gender
ORDER BY highest_purchase_amount DESC;


-- Category Contribution
SELECT
category,
SUM(purchase_amount_usd) AS category_total,
(
SUM(purchase_amount_usd)*100.0/
(
SELECT SUM(purchase_amount_usd)
FROM customer_shopping_trends
)
) AS percentage_contribution
FROM customer_shopping_trends
GROUP BY category
ORDER BY percentage_contribution DESC;


-- Customers Above Average Previous Purchases
SELECT customer_id,
previous_purchases
FROM customer_shopping_trends
WHERE previous_purchases >
(
SELECT AVG(previous_purchases)
FROM customer_shopping_trends
)
ORDER BY previous_purchases DESC;
