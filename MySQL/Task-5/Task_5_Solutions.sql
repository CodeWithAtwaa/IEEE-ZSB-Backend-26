-- Duplicate Emails
SELECT email as Email
FROM Person
group by
    email
having
    count(email) >= 2;

-- Delete Duplicate Emails
DELETE FROM Person
WHERE
    id NOT IN(
        SELECT MIN(id)
        FROM Person
        GROUP BY
            email
    );

-- Nth Highest Salary

-- Rank Scores
SELECT score, DENSE_RANK() OVER (
        ORDER BY score DESC
    ) AS rank
FROM Scores
ORDER BY score DESC;
-- Department Highest Salary
/* Write your T-SQL query statement below */
SELECT
    d.name AS Department,
    e.name AS Employee,
    e.salary AS Salary
FROM (
        SELECT *, DENSE_RANK() OVER (
                PARTITION BY
                    departmentId
                ORDER BY salary DESC
            ) AS rnk
        FROM Employee
    ) e
    JOIN Department d ON e.departmentId = d.id
WHERE
    e.rnk = 1;