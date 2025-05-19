-- Transaction Frequency Analysis
-- This query segments customers based on their average number of transactions per month.
-- Frequency categories are defined as:
--   High Frequency: >= 10 transactions/month
--   Medium Frequency: 3–9 transactions/month
--   Low Frequency: <= 2 transactions/month

WITH customer_activity AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(created_on), MAX(created_on)) + 1 AS active_months,
        COUNT(*) / (TIMESTAMPDIFF(MONTH, MIN(created_on), MAX(created_on)) + 1) AS avg_transactions_per_month
    FROM savings_savingsaccount
    GROUP BY owner_id
),
categorized AS (
    SELECT 
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_activity
)
SELECT 
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');