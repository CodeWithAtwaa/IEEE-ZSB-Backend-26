-- SQL Practice Problems

/*
Recyclable and Low Fat Products
*/

SELECT product_id
FROM Products
WHERE
    low_fats = 'Y'
    and recyclable = 'Y';

/*
Big Countries
*/

select name, population, area
from World
where
    area >= 3000000
    or population >= 25000000;

/*
Find Customer Referee
*/

SELECT name
from Customer
where
    referee_id != 2
    or referee_id is null;