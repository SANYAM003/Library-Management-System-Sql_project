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

  ![image](https://github.com/user-attachments/assets/3e0a56a1-dfe1-4702-9c31-4256cc95cb5a)


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


**Task 1: Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"**

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

**Task 2:  Update an Existing Member's Address
having member_id = C101**

```sql

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

```

**Task 3: Delete a Record from the Issued Status Table 
Objective: Delete the record with issued_id = 'IS121' from the issued_status table.**

```sql

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE issued_id = 'IS121'

```

**Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.**

```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

```

**Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.**

```sql

SELECT 
    ist.issued_emp_id,
     e.emp_name
    -- COUNT(*)
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
GROUP BY 1, 2
HAVING COUNT(ist.issued_id) > 1

```

## 3. CTAS (Create Table As Select)

**Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql

CREATE TABLE book_cnts
AS    
SELECT 
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;


SELECT * FROM
book_cnts;

```

## 4. Data Analysis and findings

**Task 7: Retrieve All Books in a Specific Category:**

```sql

SELECT * FROM books
WHERE category = 'Classic'

```

**Task 8: Find Total Rental Income by Category:**

```sql

SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;

```

**Task 9: List Members Who Registered in the Last 180 Days:**

```sql

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'

```

**Task 10: List Employees with Their Branch Manager's Name and their branch details:**

```sql

SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employees as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON b.manager_id = e2.emp_id

```

**Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:**

```sql

CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Books
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven

```

**Task 12: Retrieve the List of Books Not Yet Returned**

```sql
SELECT 
    DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL

```


# Advanced SQL Operations

**Task 13 : Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.**

```sql

select
	ist.issued_member_id,
    mem.member_name,
    bks.book_title,
    ist.issued_date,
    rst.return_date,
    datediff(curdate() , ist.issued_date) as days_overdue
from issued_status as ist
join
members as mem
on mem.member_id = ist.issued_member_id
join 
books as bks
on bks.isbn = ist.issued_book_isbn
left join 
return_status as rst
on rst.issued_id = ist.issued_id
where rst.return_date is null
and
(datediff(curdate() , ist.issued_date)) > 30

order by 1
;

```
**Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).**

```sql
##Process 1 manual updating :  Steps for updating books status for avaliablity and change it to available when it is being returned



###Step 1 checking the status  in books table using isbn for availability

select * from books
where isbn = '978-1-378-50269-0';

update books
set status = 'no'
where isbn = '978-0-330-25864-8';

### Step 2 retrieve the issued_id from the issued_status using issued_book_isbn

select * from issued_status 
where issued_book_isbn = '978-0-376-50268-9';

###Step 3 checking the return status using a issued_book_isbn 

select * from issued_status
where issued_id = 'IS156';

###Step 4 update the record in return status when the book is being returned 
insert into return_status( return_id , issued_id , return_date , book_quality)
values ('RS119' , 'IS155' , current_date() , 'Good');

###Step 5 update the status in books table from 'no' to 'yes'

update books
set status = 'no'
where isbn = '978-0-7432-7356-4';

```

```sql

##Process 2 automatic updating using Stored Procedure

delimiter //

create  procedure add_return_records(in p_return_id varchar(50) , in p_issued_id varchar(50) , in p_book_quality varchar(50))

begin

declare	v_isbn varchar(50);
declare v_book_name varchar(50); # declare seprate every variable

    
	insert into return_status(return_id , issued_id , return_date ,  book_quality)
    values (p_return_id , p_issued_id , current_date() , p_book_quality); # p ka mtlb parameter hai
    
     # get book isbn and name from issued_status
     
     Select issued_book_isbn , issued_book_name
     into v_isbn , v_book_name # here v means variable
     from issued_status 
     where issued_id = p_issued_id;
     
     update books
     set status = 'yes'
     where isbn = v_isbn;
     
     select Concat('Thank you for returning the book :' , v_book_name) As Message;
     
end //

delimiter ;   


call add_return_records('RS122', 'IS132' , 'Good');


```

**Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.**

```sql

create table Branch_performance_report
as
select 
     b.branch_id,
     b.manager_id,
     count(ist.issued_id) as total_book_issue,
     count(rst.return_id) as total_book_return,
     sum(bks.rental_price) as total_revenue
from issued_status as ist
join
employees as emp
on ist.issued_emp_id = emp.emp_id
join
branch as b
on emp.branch_id = b.branch_id
left join 
return_status as rst
on ist.issued_id = rst.issued_id
join 
books as bks
on ist.issued_book_isbn = bks.isbn
group by b.branch_id, b.manager_id;

select * from branch_performance_report;

```

**Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.**

```sql

create table active_member 
as
select * from members
where member_id in (
					select 
                    distinct issued_member_id
                    from issued_status
					where issued_date >= current_date() - interval 2 month
                    );


select * from active_member;

```

**Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.**

```sql

select 
emp.emp_name,
b.*,
count(ist.issued_id) as total_book_issue
from issued_status as ist
join 
employees as emp
on ist.issued_emp_id = emp.emp_id
join 
books as bks
on ist.issued_book_isbn = bks.isbn
join
branch as b
on emp.branch_id = b.branch_id
group by 
	emp.emp_name,
    b.branch_id,
    b.manager_id,
    b.branch_address,
    b.contact_no
order by total_book_issue
desc limit 5;

```

**Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.**

```sql

select 
bks.book_title,
mem.member_name,
count(ist.issued_id) as damage_books
from issued_status as ist
join
members as mem
on ist.issued_member_id = mem.member_id
join 
books as bks
on ist.issued_book_isbn = bks.isbn
left join
return_status as rst
on ist.issued_id = rst.issued_id
where rst.book_quality = 'damage'
group by 1,2
having count(ist.issued_id > 2);

```

**Task 19:Stored Procedure Objective: 
Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance.**

**The procedure should function as follows:** 

**The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.**


```sql

delimiter //

create procedure book_status(in p_issued_id varchar(50) , in p_issued_member_id varchar(50) , in p_issued_book_isbn varchar(50) , in p_issued_emp_id varchar(50))

begin

	declare v_status varchar(50);
	
    #checking book is available or no
	select status
	into v_status
    from books
    where isbn = p_issued_book_isbn;
    
    if v_status = 'yes' then
    
    insert into issued_status(issued_id , issued_member_id , issued_date,  issued_book_isbn , 				issued_emp_id)
    values
    (p_issued_id , p_issued_member_id , current_date() , p_issued_book_isbn , 					p_issued_emp_id);
    update books
	set status = 'no'
	where isbn = p_issued_book_isbn;
    
    select Concat('Book record added succesfully for book isbn: ' , p_issued_book_isbn) as Message;
    
    else
		select Concat('Sorry book is not available right now: ' , p_issued_book_isbn) as Message; 
        
	end if;



end //

delimiter ;


call book_status ('IS159' , 'C108' , '978-0-376-50268-9' , 'E104');

```

**Task 20: Create Table As Select (CTAS) 
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.**

**Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines.**

```sql

CREATE TABLE overdue_books_fines AS
SELECT 
    sub.member_id,
    COUNT(CASE WHEN sub.days_overdue > 30 THEN 1 END) AS overdue_books,
    SUM(CASE WHEN sub.days_overdue > 30 THEN 0.50 * sub.days_overdue ELSE 0 END) AS total_fine,
    COUNT(*) AS total_books_issued
FROM (
    SELECT 
        ist.issued_member_id AS member_id,
        ist.issued_id,
        DATEDIFF(CURDATE(), ist.issued_date) AS days_overdue
    FROM issued_status AS ist
    LEFT JOIN return_status AS rst ON ist.issued_id = rst.issued_id
    WHERE rst.return_date IS NULL
) AS sub
GROUP BY sub.member_id;

select * from overdue_books_fines

```


# Reports

- Database Schema: Detailed table structures and relationships.
- Data Analysis: Insights into book categories, employee salaries, member registration trends, and issued books.
- Summary Reports: Aggregated data on high-demand books and employee performance.

# Conclusionn

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


