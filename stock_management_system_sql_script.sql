create database Stock_Management_System_SQL_0
use Stock_Management_System_SQL_0
CREATE TABLE Role
(
roleName VARCHAR(120) NOT NULL,
roleID int Identity(3,2) PRIMARY KEY not null 
);
CREATE TABLE users
(
userID INT Identity(2,2) PRIMARY KEY NOT NULL,
userName VARCHAR(30) NOT NULL unique,
userPassword VARCHAR(50) NOT NULL ,
roleID int references Role(roleID) NOT NULL
);
CREATE TABLE supplier
(
supplierID INT Identity(1,1) PRIMARY KEY NOT NULL,
supplierF_Name VARCHAR(30) not null,
supplierL_Name VARCHAR(30) not null,
supplierPhone VARCHAR(15) not null
);
CREATE TABLE products
(
productID INT Identity(1,2) PRIMARY KEY not null,
productName VARCHAR(50) NOT NULL,
productType VARCHAR(50) not null,
productDescription VARCHAR(255),
costPrice DECIMAL(10,2) check(costPrice>=0),
sellingPrice DECIMAL(10,2) check(sellingPrice>=0)
);
CREATE TABLE stock
(
stockID INT Identity(100,1) PRIMARY KEY NOT NULL,
stockQuantity INT NOT NULL check(stockQuantity>=0),
minStock INT not null check(minStock>=0),
expireDate DATE not null,
productID int references products(productID)
);
CREATE TABLE orders
(
orderID INT Identity(1000,5) PRIMARY KEY NOT NULL,
orderQuantity INT NOT NULL check(orderQuantity>=0),
orderDate DATE not null,
orderStatus varchar(20),
supplierID int references supplier(supplierID),
productID int references products(productID)
);
CREATE TABLE transactions
(
transactionID INT Identity(1000,10) PRIMARY KEY NOT NULL,
transactionType VARCHAR(20) not null,
transactionDate DATE not null,
quantity INT NOT NULl check(quantity>=0),
userID int references users(userID),
productID int references products(productID)
);
CREATE TABLE report
(
reportID INT Identity(10,10) PRIMARY KEY NOT NULL,
reportType VARCHAR(20),
reportContent varchar(200),
generateDate DATE,
userID int references users(userID)
);

INSERT INTO Role (roleName)
VALUES
('Owner,Sales,StockManager'),
('Admin,updateAccount,manageProdut'),
('Accountant,view');

INSERT INTO users (userName, userPassword, roleID)
VALUES
('KidmuNasr', 'Owner@123',3),
('BereketTeketel', 'admin@124',5),
('NahomDemsse', 'Acc@125',7);

INSERT INTO supplier (supplierF_Name, supplierL_Name, supplierPhone)
VALUES
('Abebe', 'Kebede', '+251911111111'),
('Almaz', 'Aschenaki', '+251911001111');

INSERT INTO products
(productName, productType, productDescription, costPrice, sellingPrice)
VALUES
('Oreo Biscuits', 'Bakery', 'Sweet cream-filled biscuits', 120, 160),
('Always Pads', 'Hygiene', 'Sanitary pad pack', 185, 220),
('Lifebuoy Soap', 'Hygiene', 'Antibacterial bath soap', 30, 50),
('KitKat Chocolate', 'Confectionery', 'Chocolate wafer pack', 185, 220),
('Closeup Toothpaste', 'Household', 'Dental care toothpaste', 170, 210);

INSERT INTO stock (stockQuantity, minStock, expireDate, productID)
VALUES
(200, 50, '2026-03-20', 1),
(120, 30, '2027-01-10', 3), 
(90,  20, '2027-06-15', 5), 
(150, 40, '2026-05-15', 7), 
(50, 24,  '2027-06-15', 9); 

INSERT INTO orders
(orderQuantity, orderDate, orderStatus, supplierID, productID)
VALUES
(300, '2025-01-10', 'Pending',   1, 1), 
(200, '2025-01-12', 'Delivered', 2, 3), 
(150, '2025-01-15', 'Pending',   1, 5),
(170, '2025-01-18', 'Cancelled', 2, 7); 

INSERT INTO transactions
(transactionType, transactionDate, quantity, userID, productID)
VALUES
('IN',  '2025-01-10', 300, 2, 1), 
('OUT', '2025-01-11', 40,  2, 1),

('IN',  '2025-01-12', 200, 2, 3), 
('OUT', '2025-01-13', 60,  2, 3),

('OUT', '2025-01-22', 25,  2, 7), 

('IN',  '2025-01-12', 150, 2, 5), 
('OUT', '2025-01-16', 35,  2, 5); 

INSERT INTO report
(reportType, reportContent, generateDate, userID)
VALUES
(
  'Stock Report',
  'Current stock levels for all products including Oreo, KitKat, Lifebuoy, Always, and Closeup.',
  '2025-01-20',
  2
),
(
  'Low Stock',
  'Products below minimum stock level: Lifebuoy soap and Closeup toothpaste.',
  '2025-01-21',
  2
),
(
  'Sales Report',
  'Daily sales summary based on OUT transactions recorded by the system.',
  '2025-01-22',
  2
),
(
  'Expiry Report',
  'List of products approaching expiry date within the next three months.',
  '2025-01-23',
  2
);

alter table products alter column productType varchar (90) not null;
update supplier set supplierF_Name = 'Bekalu', supplierL_Name = 'Ashenafi' where supplierPhone = '+251911111111' and supplierF_Name = 'Abebe';
select productID from products where productName = 'Always Pads';
delete from transactions  where productID = '2';
select * from products where productName LIKE 'k%';
Select expireDate, stockQuantity from stock where minStock between 20 and 30;
Select expireDate, minStock from stock where stockQuantity IN (50,200,90);
SELECT orderDate from orders where orderStatus is null;
select * from transactions where (productID='4' or userID='4') or (quantity in(150,200,40) and transactionType like 'I%') and transactionDate != '2025-01-12';

select minStock from stock where exists 
(select minStock from stock where stockQuantity > 90);


select * from stock where stockQuantity > all
(select stockQuantity from stock where stockQuantity <=90);

select * from transactions where quantity >any
(select quantity from transactions where productID > 3);

select count (*) from orders where orderStatus = 'pending';
select sum (orderQuantity) from orders;
select avg (orderQuantity) from orders;
select max (orderQuantity) from orders;
select min (orderQuantity) from orders;

update products set sellingPrice = 199
where sellingPrice < (select Avg (sellingPrice) from products)

select p.productID, p.productName, p.productType, p.productDescription, costPrice, sellingPrice
from products p join orders o on p.productID = o.orderID;
SELECT * from products p LEFT OUTER JOIN orders o ON p.productID = o.productID;
SELECT * from products p RIGHT OUTER JOIN orders o ON p.productID = o.productID;
SELECT * FROM products p FULL OUTER JOIN orders o ON p.productID = o.productID;

select * from supplier order by supplierF_Name;
select * from products order by sellingPrice;
select costPrice, sum (sellingPrice) from products group by costPrice;
SELECT orderStatus, SUM(orderQuantity) AS TotalQuantity FROM orders GROUP BY orderStatus;
SELECT orderStatus, SUM(orderQuantity) AS TotalQuantity FROM orders GROUP BY orderStatus HAVING SUM(orderQuantity) > 150;

select * from report
select * from transactions
select * from orders
select * from stock
select * from products
select * from supplier
select * from users

