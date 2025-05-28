SELECT
	u.id AS owner_id,
    concat(u.first_name,' ',u.last_name) name,
    coalesce(sa.savings_count, 0) savings_count,
    coalesce(inv.investment_count, 0) investment_count,
    round((coalesce(sa.total_savings, 0) + coalesce(inv.total_investment, 0)) /100, 2) total_deposit
FROM users_customuser u
JOIN (
	SELECT
		p.owner_id,
        count(*) savings_count,
        sum(p.amount) total_savings
	FROM plans_plan p
    JOIN savings_savingsaccount sav
    ON p.id = sav.plan_id
    WHERE is_regular_savings = 1 AND sav.confirmed_amount > 0
    GROUP BY owner_id
    ) sa ON sa.owner_id = u.id
JOIN (
	SELECT
		p.owner_id,
        count(*) investment_count,
        sum(p.amount) total_investment
	FROM plans_plan p
    JOIN savings_savingsaccount sav
    ON p.id = sav.plan_id
    WHERE is_a_fund = 1 AND sav.confirmed_amount > 0
    GROUP BY owner_id
    ) inv ON inv.owner_id = u.id