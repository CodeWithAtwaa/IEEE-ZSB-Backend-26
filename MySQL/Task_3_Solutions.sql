--  Invalid Tweets
select tweet_id from Tweets where LENGTH(content) > 15;

--  Fix Names in a Table
SELECT user_id, TRIM(
        CONCAT(
            left(upper(name), 1), lower(SUBSTR(name, 2, length(name)))
        )
    ) as name
FROM Users
ORDER BY user_id asc;

-- Calculate Special Bonus
SELECT
    employee_id,
    case
        when (
            (employee_id % 2 != 0)
            AND (left(name, 1)) != 'M'
        ) then salary
        else 0
    END as "bonus"
FROM Employees
order by employee_id asc;

-- Patients With a Condition
SELECT
    patient_id,
    patient_name,
    conditions
FROM Patients
WHERE
    conditions like "DIAB1%"
    or conditions like "% DIAB1%"
order by patient_id asc;

-- Find Total Time Spent by Each Employee
SELECT
    event_day as day,
    emp_id,
    sum(out_time - in_time) as total_time
from Employees
group by
    event_day,
    emp_id;

-- Find Followers Count
SELECT user_id, count(follower_id) as followers_count
FROM Followers
group by
    user_id
order by user_id asc;

-- Daily Leads and Partners
SELECT
    date_id,
    make_name,
    count(distinct lead_id) as unique_leads,
    count(distinct partner_id) as unique_partners
FROM DailySales
group by
    date_id,
    make_name

-- Actors and Directors Who Cooperated At Least Three Times
SELECT actor_id, director_id
FROM ActorDirector
group by
    actor_id,
    director_id
having
    count(director_id) >= 3;

-- Classes With at Least 5 Students
SELECT class FROM Courses group by class having count(class) >= 5;

-- Game Play Analysis I
SELECT player_id, min(event_date) as first_login
FROM Activity
group by
    player_id;

-- Capital Gain/Loss
SELECT stock_name, sum(
        case
            when operation = 'Sell' then price
            else - price
        end
    ) as capital_gain_loss
from Stocks
group by
    stock_name;

-- Second Highest Salary

SELECT max(salary) as SecondHighestSalary
FROM Employee
where
    salary < (
        select max(salary)
        from Employee
    );