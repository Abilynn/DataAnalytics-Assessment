# DataAnalytics-Assessment
## Q1: High-Value Customers with Multiple Products

### Objective:
Identify customers who have at least one funded savings plan and one funded investment plan, and rank them by total deposits.

### Approach:
- Joined the users_customuser, plans_plan, and savings_savingsaccount tables.
- Defined:
  - **Savings plan**: is_regular_savings = 1
  - **Investment plan**: is_a_fund = 1
- Filtered for customers with both types of plans where deposits (confirmed_amount) exist.
- Aggregated total deposits (in kobo) and converted to Naira.

### Output:
- Customer name
- Count of savings and investment plans
- Total deposits (in Naira)

### Challenges:
Ensuring only valid deposits and customers with both plan types were selected.

---

## Q2: Transaction Frequency Analysis

### Objective:
Categorize customers based on their average monthly transaction frequency.

### Approach:
- Used the savings_savingsaccount table to count inflow transactions (confirmed_amount > 0).
- Grouped by customer and month, then averaged the count per customer.
- Applied case conditions to classify customers into:
  - **High Frequency**: ≥10/month
  - **Medium Frequency**: 3–9/month
  - **Low Frequency**: ≤2/month

### Output:
- Frequency category
- Customer count
- Average transactions per month

### Challenges:
Choosing the correct granularity for monthly aggregation and accounting for months with no transactions.

---

## Q3: Account Inactivity Alert

### Objective:
Find all active accounts (savings or investments) with no inflow transactions in the last 365 days.

### Approach:
- Extracted the most recent transaction date per plan from both savings_savingsaccount and plans_plan (linked via plan_id).
- Filtered for inflow transactions (confirmed_amount > 0).
- Identified accounts where the last transaction date is older than 365 days from today.
- Determined account type based on plan attributes:
  - **Savings**: is_regular_savings = 1
  - **Investment**: is_a_fund = 1

### Output:
- Plan ID, Owner ID, Type, Last transaction date, Inactivity days

### Challenges:
Correctly mapping the account type and avoiding false positives (e.g., accounts that never had a transaction).

---

## Q4: Customer Lifetime Value (CLV) Estimation

### Objective:
Estimate the CLV for each customer based on account tenure and the number of confirmed transactions.

### Approach:
1. **Tenure Calculation**:
   - Used date_joined from users_customuser.
   - Tenure = months between join date and today.

2. **Transaction Data Extraction**:
   - Joined users_customuser → plans_plan → savings_savingsaccount.
   - Filtered to regular savings (is_regular_savings = 1) and inflow transactions (confirmed_amount > 0).

3. **Profit Calculation**:
   - avg_profit_per_transaction = AVG(confirmed_amount) * 0.001 / 100 to convert kobo to Naira.

4. **CLV Formula**:
   - CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

5. **Sorting**:
   - Ordered customers by estimated_clv in descending order.

### Output:
- Customer ID, Name, Tenure (months), Total transactions, Estimated CLV (in Naira)

### Challenges:
- Conversion from kobo to Naira required attention to units throughout the query.

---

##  Notes
- All monetary values were stored in **kobo**, and properly converted to **Naira** in outputs.
- SQL queries include clear comments and formatting for readability.
- All queries were tested for correctness and performance.

---

**Thank you for the opportunity!**
