use sql_project_p2;

create table branch(
branch_id varchar(50),
manager_id varchar(50),
branch_address varchar(50),
contact_no varchar(50)
);

alter table branch
add primary key(branch_id); 

create table employees(
emp_id varchar(50),
emp_name  varchar(50),
position varchar(50),
salary int,
branch_id varchar(50),
primary key (emp_id)
);



create table books(
isbn int,
book_title varchar(100),
category varchar(50),
rental_price float,
status  varchar(50),
author varchar(50),
publisher varchar(50),
primary key(isbn));



create table members(
member_id varchar(50),
member_name	varchar(50),
member_address	varchar(50),
reg_date date,
primary key(member_id)
);


drop table issued_status;
create table issued_status(
issued_id	varchar(50),
issued_member_id	varchar(50), #foreign key
issued_book_name varchar(100),
issued_date date,
issued_book_isbn int, #foreign key
issued_emp_id	varchar(50), #foreign key
primary key(issued_id)
);

drop table return_status;
create table return_status(
return_id	varchar(50),
issued_id	varchar(50), 
return_book_name	varchar(100),
return_date	date,
return_book_isbn varchar(50),
primary key (return_id)
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

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE issued_status
DROP FOREIGN KEY fk_books;


alter table books
modify isbn varchar(50);

ALTER TABLE issued_status
MODIFY issued_book_isbn VARCHAR(50);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn) 
REFERENCES books(isbn);

# from here we write new query and solve some real life buisness problem one by one



