-- Combine Two Tables
SElECT p.firstName, p.lastName, a.city, a.state
FROM Person p
    left join Address a on p.personId = a.personId;

-- Replace Employee ID With The Unique Identifier
select u.unique_id, e.name
from Employees e
    left join EmployeeUNI u on e.id = u.id;

-- Customer Who Visited but Did Not Make Any Transactions
SELECT v.customer_id, count(*) AS count_no_trans
FROM Visits v
    left join Transactions t on v.visit_id = t.visit_id
where
    t.transaction_id is null
group by
    v.customer_id;

-- Project Employees I
SELECT p.project_id, round(avg(experience_years), 2) as average_years
FROM Project p
    join Employee e on e.employee_id = p.employee_id
group by
    p.project_id;

-- Sales Person
SELECT s.name
FROM SalesPerson s
WHERE
    sales_id not in(
        SELECT o.sales_id
        FROM Orders o
            inner join Company c on c.com_id = o.com_id
        where
            c.name = 'RED'
    );

-- Rising Temperature
SELECT w1.id as 'Id'
from Weather w1, Weather w2
where
    w2.recordDate = date_sub(w1.recordDate, interval 1 day)
    and w2.temperature < w1.temperature;

-- Average Time of Process per Machine
SELECT a.machine_id, ROUND(
        AVG(b.timestamp - a.timestamp), 3
    ) as processing_time
FROM Activity a
    join Activity b on a.process_id = b.process_id
    and a.machine_id = b.machine_id
where
    a.activity_type = 'start'
    and b.activity_type = 'end'
group by
    a.machine_id
order by a.machine_id asc;

-- Students and Examinations
SELECT s.student_id, s.student_name, j.subject_name, count(e.subject_name) as attended_exams
FROM
    Students s
    cross join Subjects j
    left join Examinations e on s.student_id = e.student_id
    and j.subject_name = e.subject_name
group by
    s.student_id,
    s.student_name,
    j.subject_name
order by s.student_id, j.subject_name;

-- Managers with at Least 5 Direct Reports
SELECT e.name
from Employee e
where
    e.id in (
        SELECT m.managerId
        FROM Employee m
            join employee e on e.id = m.managerId
        group by
            m.managerId
        having
            count(m.managerId) >= 5
    );

-- Confirmation Rate

-- Product Sales Analysis III

-- Market Analysis I
SELECT u.user_id as buyer_id, u.join_date, count(o.buyer_id) as orders_in_2019
FROM Users u
    left join Orders o on u.user_id = o.buyer_id
    and year(o.order_date) = 2019
group by
    u.user_id,
    u.join_date;