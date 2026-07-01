# Research Questions

---- 

## Window Functions vs GROUP BY

- Group by : Returns a single row for each group
   - Changes the granularity (التفاصيل)
   - simple aggregations
   - has aggregates functions only

- Window : Returns a result for each row.
   -  the granularity  stays the same
   - simple aggregations + keep details
   - have more functions 
   

---


## Clustered vs Non-Clustered Indexes

|                        | Cluster                                                                     | Non-Cluster                                                                    |
| ---------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **Deifination**        | Physically sorts and store rows                                             | Separate structure with pointer to the data                                    |
| **Number of indexs**   | `one` index per table                                                       | `mutilple` indexes are allowed                                                 |
| **Read performance**   | `Fater`                                                                     | `Slower`                                                                       |
| **Write performance**  | `Slower` , due to potential data row recording                              | `Faster`, since physical data order is unaffected                              |
| **Storage Efficiency** | more storage `Efficient`                                                    | Requires `addational` storage space                                            |
| **Use case**           | - Unique column , Not frequently modified , improve range query performance | -  Column frequently used in search conditions and joins , Exact match queries |




```sql
 -- Create Index
--     [      optional        ]
Create [Clusered | non-cluster] INDEX index_name on table_name (col1,col2,....)
create index ix7_customers on Customers (name, id)

-- Drop index
DROP INDEX index_name ON table_name

-- USE ALTER to Drop index
ALTER TABLE table_name  
DROP INDEX index_name;
```



-------------------

## Filtered & Unique Indexes


| Unique Index                                             | Filtered index                                                   |
| -------------------------------------------------------- | ---------------------------------------------------------------- |
| Ensure no duplicate values exist in specific solumn      | An index that includes only rows meeting the specified condtions |
| `Enforce uniqueness`                                     | `Targeted Optimization`                                          |
| Slightly increase query performance                      | `Reduce Storage`: less data in the index                         |
| Writing to an unique is `slower` than non-unique         |                                                                  |
| reading form an unique index is `faster` than non-unique |                                                                  |
|                                                          |                                                                  |


```sql
-- unique index
CREATE [UNIQUE] [Clusterd | nonClusterd] [COLUMNSTORE] INDEX index_name
	on table_name (col_name, col_name,....)
	
CREATE UNIQUE INDEX ix_category_name ON customers(category)
```

```sql
-- Filtered index
CREATE [UNIQUE] [nonClusterd] INDEX index_name
	on table_name (col_name, col_name,....)
	WHERE [Condition]
	
CREATE NONCLUSTERED INDEX ix_category_name 
	ON customers(category)
WHERE cuontry = 'USA';
```


---------

## Choosing the Right Index


| HEAP         | Clustere                                        | Non-clustere                             | Filtered                                     | Unique                                   |
| ------------ | ----------------------------------------------- | ---------------------------------------- | -------------------------------------------- | ---------------------------------------- |
| Fast inserts | For `primary key` if not, then for date columns | for `non-PK` Forign key , joins, filters | Target `Subset` of data Reduce size of index | Enforce `Uniqueness` improve Query speed |


------------ 


## Database Transactions (ACID)

Atomicity guarantees:
A transaction is indivisible — it either fully succeeds or fully fails.

Without it, partial failures can cause:
- Lost money
- Corrupted data
- Orphan records
- Business disasters