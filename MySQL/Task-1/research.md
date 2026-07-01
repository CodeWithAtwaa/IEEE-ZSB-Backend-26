# Research Questions


## What is the difference between a DBMS and an RDBMS?
* `DBMS` =>  A software to facilitate the creation and maintenance of a DB.
- XML File

* `RDMS` => Type of DBMS to store collection of Releted data.
- MySSQL



--------

## What is the difference between DDL and DML?

* `DDL` => Data Defination language is used to create tables and meta data
- create 
- drop
- alter
- truncate

(
    create table user (
        id int primary key,
        name varcahr(50)
    );

)

* `DMl` => to mainpulate in data 
- insert 
- delete
- update 

(
    insert into user (id, name)
    values
    (1, "Mohamed Tamer");

)




------------------

## why is Normalization important for a large system like a university database?
- to convert bad relations by breaking up thier attributes into smaller relations
- to make the system is scalabe and easy to maintainance 