DDL defines and manages the structure (schema) of the database. These commands modify the layout of database objects rather than the data within them. 

• CREATE: Creates new database objects like tables, indexes, or views. 
• ALTER: Modifies the structure of an existing object (e.g., adding a column to a table). 
• DROP: Deletes an entire database object permanently. 
• TRUNCATE: Removes all records from a table while keeping the structure intact. 
• RENAME: Used to change the name of an existing database object. 

--2. DML (Data Manipulation Language) 
DML handles the manipulation of data stored within the database objects. These commands are used to add, edit, or remove records. 

• INSERT: Adds new rows of data into a table. 
• UPDATE: Modifies existing data within a table. 
• DELETE: Removes specific records from a table. 
• MERGE: Performs "upsert" operations (conditionally inserting or updating data)

--3. DQL (Data Query Language) 
DQL is dedicated solely to retrieving information from the database. It is the most commonly used part of SQL for data analysis. 

• SELECT: The primary command used to fetch data based on specific conditions. 

--4. DCL (Data Control Language) 
DCL manages security and access permissions for the database. It determines which users can perform operations on which objects. 

• GRANT: Gives specific access privileges to users. 
• REVOKE: Removes previously granted permissions. 

--5. TCL (Transaction Control Language)
TCL manages transactions within the database to ensure data integrity and consistency. It is used to group DML statements into logical units. 

• COMMIT: Saves all changes made during the current transaction permanently. 
• ROLLBACK: Undoes changes that havent been committed yet, restoring the database to its previous state. 
• SAVEPOINT: Sets a temporary marker within a transaction to which you can later roll back. 
• SET TRANSACTION: Sets characteristics for the current transaction, such as isolation level.  

----------------------------------------------------------------------------------------
create database Student_DB

create table student 
(student_id int, 
student_name varchar(50),
contact_no bigint, 
age int)

insert into student
values (101, 'Akash', 1010101010, 20), (102, 'Max', 2020202020, 22)

select * from student

-- Add row in table
-- insert into

insert into student
values (103, 'Suraj', 3030303030, 23)

-- Insert column
-- alter table 

alter table student
add gender varchar (10)

-- Update values
-- update set

update student
set gender = 'Male'
where student_id in (101,102,103)

-- delete column
-- alter table drop column_name

alter table student
drop column gender

-- delete row
-- delete from

delete from student
where student_id = 103

select * from student

update student
set gender = 'Female'
where student_id = 102

---------------- DROP / DELETE / TRUNCATE ----------------

DROP TABLE STUDENT -- ( USE TO REMOVE WHOLE TABLE FROM DATABASE)

TRUNCATE TABLE STUDENT --(USE TO REMOVE DATA FROM TABLE & STRUCTURE REMAINS SAME)

DELETE FROM STUDENT   -- ( USE TO REMOVE SELECTED RECORDS FROM TABLE ) 
WHERE STUDENT_ID = 1

DELETE FROM STUDENT  -- ( IT WORKS LIKE A TRUNCATE) 

-- Column Rename


-- column datatype change

-- 1. DDL (Data Definition Language)


-- DIM vs FACT
--| Table Type          | Example                                               | Purpose                                |
--| ------------------- | ----------------------------------------------------- | -------------------------------------- |
--| **Fact Table**      | `AdventureWorks_Sales_2017`                           | Contains measurable data (SalesAmount) |
--| **Dimension Table** | `AdventureWorks_Customers`, `Products`, `Territories` | Adds context (who, what, where)        |

-- select * -> select all columns
-- COUNT(*) -> Count all rows including nulls
-- count(column_name) -> count all elements in that column excluding nulls

-- **Non Aggregated column will be in where clause only**
-- **Every non-aggregated column must be in GROUP BY**
-- **HAVING is used only after aggregation**

-- How we write sql syntax
-- SELECT => FROM => JOIN => WHERE => GROUP BY => HAVING => ORDER BY
-- How SQL actually EXECUTES (logic order)
-- FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY

-- **Join direction ==> Sales(fact)--> Product_catogery(Enrish with dimentions)

| Clause |			Purpose             |
| ------ | ---------------------------  |
| WHERE  | Filters rows ❌ removes data |
| CASE   | Labels rows ✅ keeps data    |

-- COALESCE → prevents NULL from breaking logic
"
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'completed'

where convert LEFT Join to INNER JOIN (unexpectedly)

Why?

WHERE runs after join
It removes NULL rows → defeats LEFT JOIN

🔑 Trick 1: TO DECIDE WHICH JOIN TO USE

“Do I want to lose rows from the main table?”

Answer	  Use
YES		INNER JOIN
NO		LEFT JOIN

🔑 Trick 2: Identify your primary table

👉 In your case:

You care about customers → LEFT JOIN

👉 If question was:

“List all completed orders”

You care about orders → INNER JOIN is fine

"
"
If question involves:

Classification (VIP / Regular)
Reporting
Dashboards

👉 Default to LEFT JOIN
"
----------------------------------- Set Operators---------------------------------------
1 UNION -- All records from both the tables without duplicates
2 UNION ALL -- All records from both tables with duplicates
3 EXCEPT -- Records In left table but not in Second table
4 INTERSECT -- Common elements in both the tables
--Rows Wise table add in Set Operators

------------------------------- ----View In Sql-----------------------------------------
-- view is used to store select statement 
"
create view view_name
as
(
select statement
)

select * from view_name
"
------------------------------------Store Procedure---------------------------------------
"
stored procedure is a precompiled SQL code that can be saved and reused.
benefits:

Code Reusability - The same procedure can be called from various applications
Improved Performance - Stored procedures are precompiled and runs faster
Database Security - You can set users permission to run a specific procedure (limits direct access to tables)
Easy Maintenance - When updating a procedure, it automatically updates all its use
"
"
create procedure proc_student_1
as 
begin
|
|-- queries
|
end

exec proc_student_1

to drop a procedure
drop procedure procedure_name
"

--------------------------------------------SUBQUERIES--------------------------------------------
--Subqueries do not have a single fixed syntax, as they can be used in different clauses like SELECT, WHERE, FROM and HAVING
-- normal subquery and Correlated subquery
"
Normal Subquerry
🔹 Global Average (your query):
(2 + 10 + 50 + 60) / 4 = 30.5

👉 Result:

Only orders > 30.5
Output:
Customer 2 → 50, 60

🚫 Customer 1 disappears completely

Correlated Subquery
🔹 Per-Customer Average (correct query):
Customer 1 avg = (2 + 10) / 2 = 6
Customer 2 avg = (50 + 60) / 2 = 55

👉 Result:

Customer 1 → 10 (above 6) ✅
Customer 2 → 60 (above 55) ✅

✔️ Both customers appear"
---------------------------------------------------
🔍 Why use FROM specifically?

Because FROM is where SQL expects:

Tables
Subqueries (treated as tables)

-----------------------------------WINDOWS FUNCTION------------------------------------------------------