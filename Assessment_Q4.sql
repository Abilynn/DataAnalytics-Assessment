-- Customer Lifetime Value (CLV) Estimation

-- This query estimates CLV based on account tenure and transaction volume for each customer based on:
-- - Account tenure (in months)
-- - Total number of savings transactions (excluding investment plans)
-- - Average transaction value (only confirmed inflows)
-- - Profit per transaction = 0.1% of transaction value

WITH tenure AS (
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
),

transactions AS (
    SELECT 
        us.id AS customer_id,
        COUNT(sa.id) AS total_transactions,
        (AVG(sa.confirmed_amount) * 0.001) / 100 AS avg_profit_per_transaction  -- convert kobo to Naira
    FROM users_customuser us
    JOIN plans_plan pl ON us.id = pl.owner_id
    JOIN savings_savingsaccount sa ON pl.id = sa.plan_id
    WHERE pl.is_regular_savings = 1 AND sa.confirmed_amount > 0
    GROUP BY us.id
)

SELECT 
    tr.customer_id,
    te.name,
    te.tenure_months,
    tr.total_transactions,
    ROUND((tr.total_transactions / NULLIF(te.tenure_months, 0)) * 12 * tr.avg_profit_per_transaction, 2) AS estimated_clv
FROM transactions tr
JOIN tenure te ON tr.customer_id = te.customer_id
ORDER BY estimated_clv DESC;