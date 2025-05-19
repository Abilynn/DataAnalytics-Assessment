-- Account Inactivity Alert
-- This query identifies all active savings/investment accounts with transactions in the last 365 days.

-- Savings accounts
WITH savings_acc AS (
    SELECT 
        pl.id AS plan_id,
        pl.owner_id,
        'Savings' AS type,
        MAX(sa.created_on) AS last_transaction_date
    FROM plans_plan pl
    JOIN savings_savingsaccount sa ON pl.id = sa.plan_id
    WHERE pl.is_regular_savings = 1 AND sa.confirmed_amount > 0
    GROUP BY pl.id, pl.owner_id
),

-- Investment accounts
investment_acc AS (
    SELECT 
        pl.id AS plan_id,
        pl.owner_id,
        'Investment' AS type,
        MAX(pl.created_on) AS last_transaction_date
    FROM plans_plan pl
    WHERE pl.is_a_fund = 1 AND pl.amount > 0
    GROUP BY pl.id, pl.owner_id
),

-- Combining both account types
accounts AS (
    SELECT * FROM savings_acc
    UNION ALL
    SELECT * FROM investment_acc
)

-- Filtering for inactive accounts
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM accounts
WHERE DATEDIFF(CURDATE(), last_transaction_date) > 365
ORDER BY inactivity_days DESC;