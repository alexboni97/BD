alter session set nls_date_format = 'DD/MM/YYYY';

drop table Customer cascade constraints;
drop table ORDERR cascade constraints;
drop table Author cascade constraints;
drop table Author_Book cascade constraints;
drop table Book cascade constraints;
drop table Book_Order cascade constraints;

create table Customer
(customer_Id VARCHAR2(10) PRIMARY KEY,
 name VARCHAR2(40) NOT NULL,
 address VARCHAR2 (60) NOT NULL,
 numCC VARCHAR2(16) NOT NULL);
 

create table ORDERR
(order_Id VARCHAR2(10) PRIMARY KEY,
 customer_Id VARCHAR2(10) NOT NULL REFERENCES Customer on delete cascade,
 order_date DATE NOT NULL,
 shipping_date DATE);

create table Author
(author_Id NUMBER PRIMARY KEY,
  name VARCHAR2(40));

create table Book
(ISBN VARCHAR2(13) PRIMARY KEY,
 title VARCHAR2(60) NOT NULL,
 year CHAR(4) NOT NULL,
 -- Publisher price (precio de adquisición editor)
 purchase_price NUMBER(6,2) DEFAULT 0, 
 -- Retail price (precio de venta al público - PVP)
 sale_price NUMBER(6,2) DEFAULT 0);    

create table Author_Book
(ISBN VARCHAR2(13),
 author_Id NUMBER,
 CONSTRAINT alA_PK PRIMARY KEY (ISBN,author_Id ),
 CONSTRAINT BookA_FK FOREIGN KEY (ISBN) REFERENCES Book on delete cascade,
 CONSTRAINT AuthorA_FK FOREIGN KEY (author_Id) REFERENCES Author);


create table Book_Order(
 ISBN VARCHAR2(13),
 order_Id VARCHAR2(10),
 quantity NUMBER(3) CHECK (quantity >0),
 CONSTRAINT lpB_PK PRIMARY KEY (ISBN, order_Id),
 CONSTRAINT BookB_FK FOREIGN KEY (ISBN) REFERENCES Book on delete cascade,
 CONSTRAINT pedidoB_FK FOREIGN KEY (order_Id) REFERENCES ORDERR on delete cascade);

insert into Customer values ('0000001','James Smith', 'Picadilly 2','1234567890123456');
insert into Customer values ('0000002','Laura Jones', 'Holland Park 13', '1234567756953456');
insert into Customer values ('0000003','Peter Doe', 'High Street 42', '1237596390123456');
insert into Customer values ('0000004','Rose Johnson', 'Notting Hill 46', '4896357890123456');
insert into Customer values ('0000005','Joseph Clinton', 'Leicester Square 1', '1224569890123456');
insert into Customer values ('0000006','Betty Fraser', 'Whitehall 32', '2444889890123456' );
insert into Customer values ('0000007','Jack the Ripper', 'Tottenham Court Road 3', '2444889890123456' );
insert into Customer values ('0000008','John H. Watson', 'Tottenham Court Road 3', '2444889890123456' );



insert into ORDERR values ('0000001P','0000001', TO_DATE('01/10/2020'),TO_DATE('03/10/2020'));
insert into ORDERR values ('0000002P','0000001', TO_DATE('01/10/2020'),null);
insert into ORDERR values ('0000003P','0000002', TO_DATE('02/10/2020'),TO_DATE('03/10/2020'));
insert into ORDERR values ('0000004P','0000004', TO_DATE('02/10/2020'),TO_DATE('05/10/2020'));
insert into ORDERR values ('0000005P','0000005', TO_DATE('03/10/2020'),TO_DATE('03/10/2020'));
insert into ORDERR values ('0000006P','0000003', TO_DATE('04/10/2020'),null);
insert into ORDERR values ('0000007P','0000006', TO_DATE('05/09/2012'),NULL);
insert into ORDERR values ('0000008P','0000006', TO_DATE('05/09/2012'),TO_DATE('05/10/2012'));
insert into ORDERR values ('0000009P','0000007', TO_DATE('05/09/2012'),NULL);

insert into Author values (1,'Jane Austin');
insert into Author values (2,'George Orwell');
insert into Author values (3,'J.R.R Tolkien');
insert into Author values (4,'Antoine de Saint-Exupéry');
insert into Author values (5,'Bram Stoker');
insert into Author values (6,'John Steinbeck');
insert into Author values (7,'Alvin Toffler');

insert into Book values ('8233771378567', 'Pride and Prejudice', '2008', 9.45, 13.45);
insert into Book values ('1235271378662', '1984', '2009', 12.50, 19.25);
insert into Book values ('4554672899910', 'The Hobbit', '2002', 19.00, 33.15);
insert into Book values ('5463467723747', 'The Little Prince', '2000', 49.00, 73.45);
insert into Book values ('0853477468299', 'Dracula', '2011', 9.45, 13.45);
insert into Book values ('014017737X', 'The Pearl', '1993', 10.45, 15.75);
insert into Book values ('9780553277371', 'Future Shock', '1984', 4.00, 9.45);


insert into Author_Book values ('8233771378567',1);
insert into Author_Book values ('1235271378662',2);
insert into Author_Book values ('4554672899910',3);
insert into Author_Book values ('5463467723747',4);
insert into Author_Book values ('0853477468299',5);
insert into Author_Book values ('014017737X',6);
insert into Author_Book values ('9780553277371',7);

insert into Book_Order values ('8233771378567','0000001P', 1);
insert into Book_Order values ('5463467723747','0000001P', 2);
insert into Book_Order values ('9780553277371','0000002P', 1);
insert into Book_Order values ('4554672899910','0000003P', 1);
insert into Book_Order values ('8233771378567','0000003P', 1);
insert into Book_Order values ('014017737X','0000003P', 1);
insert into Book_Order values ('8233771378567','0000004P', 1);
insert into Book_Order values ('4554672899910','0000005P', 1);
insert into Book_Order values ('014017737X','0000005P', 1);
insert into Book_Order values ('5463467723747','0000005P', 3);
insert into Book_Order values ('8233771378567','0000006P', 5); 
insert into Book_Order values ('0853477468299','0000007P', 2);
insert into Book_Order values ('1235271378662','0000008P', 7);
insert into Book_Order values ('8233771378567','0000009P', 1);
insert into Book_Order values ('5463467723747','0000009P', 7);

commit;
