# Library-Management-System-Sql_project

![image](https://github.com/user-attachments/assets/8dc10c9a-0a00-4f69-9ada-828edfcc0e91)


# 📚 Library Management System – SQL Project

This project is a fully functional **Library Management System** built using **MySQL**. It focuses on solving real-world library workflows such as book issuance, returns, overdue fine calculation, branch-level insights, and user activity monitoring using **advanced SQL queries, stored procedures, subqueries, and joins**.

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

## 🧰 Tech Stack

- **Database**: MySQL
- **SQL Features Used**:
  - `JOIN`, `GROUP BY`, `HAVING`, `ORDER BY`
  - Subqueries & nested SELECTs
  - `CTAS` (Create Table As Select)
  - Variables, Conditions, Loops
  - `Stored Procedures`
  - Views and Aggregations

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup

- Database Creation : Created a Database named sql_project_p2
- Table Creation : Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
Create Database "sql_project_p3"


-- Create table Branch

create table branch(
branch_id varchar(50),
manager_id varchar(50),
branch_address varchar(50),
contact_no varchar(50)
);

alter table branch
add primary key(branch_id);


--Create table Employees

create table employees(
emp_id varchar(50),
emp_name  varchar(50),
position varchar(50),
salary int,
branch_id varchar(50),
primary key (emp_id)
);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);


--Create table "Books"

create table books(
isbn int,
book_title varchar(100),
category varchar(50),
rental_price float,
status  varchar(50),
author varchar(50),
publisher varchar(50),
primary key(isbn));


--Create table "Members"

create table members(
member_id varchar(50),
member_name	varchar(50),
member_address	varchar(50),
reg_date date,
primary key(member_id)
);


--Create table "Issued_Status"

create table issued_status(
issued_id	varchar(50),
issued_member_id	varchar(50), #foreign key
issued_book_name varchar(100),
issued_date date,
issued_book_isbn int, #foreign key
issued_emp_id	varchar(50), #foreign key
primary key(issued_id)
);


ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);


--Create table "Return_Status"

create table return_status(
return_id	varchar(50),
issued_id	varchar(50), 
return_book_name	varchar(100),
return_date	date,
return_book_isbn varchar(50),
primary key (return_id)
);


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


```

## 2.CRUD Operations
- Create: Inserted sample records into the books table.
- Read: Retrieved and displayed data from various tables.
- Update: Updated records in the employees table.
- Delete: Removed records from the members table as needed.


**Task 1: Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')" **

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

** Task 2:  Update an Existing Member's Address
having member_id = C101 **

```sql

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

```

** Task 3: Delete a Record from the Issued Status Table 
Objective: Delete the record with issued_id = 'IS121' from the issued_status table. **

```sql

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE issued_id = 'IS121'

```

**
