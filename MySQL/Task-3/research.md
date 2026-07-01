# Research 

## WHERE vs HAVING
* `WHERE` is used to make any filter recorders on any data, but you cann't use it with aggregate functions.

```sql
SELECT * 
FROM users
WHERE user_id > 10
```

* `HAVING` is used to make filtering with aggregate functions

```sql
SELECT name , SUM(price) as "Total"
FROM orders
GROUP BY name
HAVING COUNT(order_id) > 10; 
```

----
## DELETE vs TRUNCATE vs DROP

* `DELETE` : TO delete Rows by specific condition.
    -  DML
    - you can rollback

```sql
    DELETE FROM users
    WHERE id = 1;
```

* `DROP` : To delete Tables itslef => [ data (actual) and meta data (Structure) ].
    - DDL 
    - cann't be make rollback

```sql
    DROP TABLE users;
```

* `TRUNCATE` : TO all delete values from inside table (DDL)
```sql
    TRUNCATE table users;
```

--------
## Order of Execution
1- FROM 

2- JOIN

3- WHERE

4- GROUP

5- HAVING

6- SELECT 

7- DISTINCT 

8- ORDER BY

9- LIMIT

----------------
## COUNT(*) vs COUNT(Column_Name) 

* `COUNT(*)` : count all rows 

```sql
    SELECT COUNT(*) 
    FROM users;
```

* `COUNT(col_name)` : count all data without null values
```sql
    SELECT COUNT(name) 
    FROM users;
```

------
## CHAR vs VARCHAR
* `CHAR` : 
    -  fixed size of chars
    -  faster than varchar 
    -  static memory

* `VARCHAR` :
    -   variable size of chars
    -   slower than char
    -   dynamic memory

