-- High-Value Customers with Multiple Products
-- This query identifies customers who have both a funded savings plan and a funded investment plan.
-- It outputs their user ID, full name, the count of each plan type, and total deposits (converted from kobo to Naira).

SELECT
    us.id AS owner_id,
    CONCAT(us.first_name, ' ', us.last_name) AS name,
    COALESCE(sa.savings_count, 0) AS savings_count,
    COALESCE(inv.investment_count, 0) AS investment_count,
    ROUND((COALESCE(sa.total_savings, 0) + COALESCE(inv.total_investments, 0)) / 100, 2) AS total_deposits
FROM users_customuser us
JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count,
        SUM(amount) AS total_savings
    FROM plans_plan
    WHERE is_regular_savings = 1 AND amount > 0
    GROUP BY owner_id
) sa ON us.id = sa.owner_id
JOIN (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count,
        SUM(amount) AS total_investments
    FROM plans_plan
    WHERE is_a_fund = 1 AND amount > 0
    GROUP BY owner_id
) inv ON us.id = inv.owner_id
ORDER BY total_deposits DESC;