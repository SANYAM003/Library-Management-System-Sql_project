use sql_project_p2;
# Advance SQl Queries

select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status; 
select * from members;


/* 
Task 13 : Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue. 
*/

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

/*
 
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

*/
# Process 1 manual updating :  Steps for updating books status for avaliablity and change it to available when it is being returned



# Step 1 checking the status  in books table using isbn for availability

select * from books
where isbn = '978-1-378-50269-0';

update books
set status = 'no'
where isbn = '978-0-330-25864-8';

# Step 2 retrieve the issued_id from the issued_status using issued_book_isbn

select * from issued_status 
where issued_book_isbn = '978-0-376-50268-9';

# Step 3 checking the return status using a issued_book_isbn 

select * from issued_status
where issued_id = 'IS156';

# Step 4 update the record in return status when the book is being returned 
insert into return_status( return_id , issued_id , return_date , book_quality)
values ('RS119' , 'IS155' , current_date() , 'Good');

# Step 5 update the status in books table from 'no' to 'yes'

update books
set status = 'no'
where isbn = '978-0-7432-7356-4';


# Process 2 automatic updating using Stored Procedure

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




select * from books
where isbn = '978-1-378-50269-0';

select * from issued_status
where issued_book_isbn = '978-1-378-50269-0';

select * from return_status
where issued_id = 'IS156';

/*
isbn 
978-0-307-58837-1
978-0-375-41398-8
978-0-7432-7357-1
*/

/*
issued_id = 'IS156'
isbn = '978-1-378-50269-0'
*/

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

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


/*
Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
*/

select 
distinct ist.issued_member_id,
ist.issued_book_isbn,
ist.issued_date,
mem.member_name 
from issued_status as ist
join 
members as mem 
on ist.issued_member_id = mem.member_id
where issued_date >= current_date() - interval 2 month;

#or

select * from issued_status
where issued_date >= current_date() - interval 6 month;

#or
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


/*
Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
*/

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

/*
Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.
*/

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

/*
Task 19: Stored Procedure Objective: 
Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

*/

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

select * from issued_status;


/*
Task 20: Create Table As Select (CTAS) 
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines

approach to solve question

member
issued books
countof no. of books issued by each member
o/p member id no. of overdure books totall fines
*/

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

