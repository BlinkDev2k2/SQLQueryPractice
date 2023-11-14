-- create databse
create database hoang_database on(
	name = 'hoang_data',
	filename = 'C:\SQL2022\database\hoang_data.mdf',
	size = 10mb, maxsize = 100mb, filegrowth = 5mb
) log on (
	name = 'hoang_data_log',
	filename = 'C:\SQL2022\database_log\hoang_data_log.ldf',
	size = 5mb, maxsize = 50mb, filegrowth = 1mb
);

-- delete database 
drop database hoang_database;

-- create table
create table hoang_table(
	[id] int primary key identity,
	[name] varchar(30) not null default 'No Name',
	[gender] varchar(10) default null,
	[birth_date] date default '2000-01-01',
	[address] varchar(100) default null,
	[phone_number] varchar(10) default null check(len(phone_number) = 10 and patindex('%[^0-9]', phone_number) = 0)
);

-- edit table
alter table hoang_table
add Country varchar(20) default null;
alter table hoang_table
drop column [address];
exec sp_rename 'hoang_table.name' , 'From', 'COLUMN';
alter table hoang_table
alter column [gender] varchar(5);
alter table hoang_table
add constraint birth_date check(birth_date <= getdate())

-- delete data table
truncate table hoang_table

-- delete table
drop table hoang_table

-- insert data into table
insert into (id, name, gender, birth_date, address, phone_number)
values(1906, 'Hoang', 'Male', '2002-06-19', 'Bac Ninh', '0941923XXX');
insert into hoang_table
values(1906, 'Hoang', 'Male', '2002-06-19', 'Bac Ninh', '0941923XXX');

-- update data in table
update hoang_table set id = 10, name = 'Hoang Dinh' where id = 1906;

-- delete data in table with condition
delete from hoang_table where id < 10;

-- index in sql
create index [index] on hoang_table (name, gender, address);
create unique index [index] on hoang_table (name, gender, address);
set statistics io on
select * from Sales.SalesOrderDetail where CarrierTrackingNumber = '1B2B-492F-A9'
set statistics io off;
create index IDX_CarrierTrackingNumber on Sales.SalesOrderDetail(CarrierTrackingNumber);

-- select query
select ProductName, UnitPrice, QuantityPerUnit from Products;
select CompanyName, Address, City from Customers;

-- select into query
select * into UKCustomer from Customers C where C.Country = 'UK';

-- distinct query
select distinct Country from Customers;

-- top query
select top 10 Country from Customers;

-- percent query
select top 80 percent Country from Customers;
select distinct top 1 percent * from Orders;

-- as query
select CustomerID as "Ma khach hang" from Customers;
select FirstName as Ten, LastName as Ho from Employees;
select top 15 * from Orders as o;

-- min and max query
select min(UnitPrice) as MinPrice from Products;
select max(UnitPrice) as MaxPrice from Products;
select max(OrderDate) as OrderDate from Orders;
select max(UnitsInStock) from Products;

-- count, sum and avg query
select count(UnitsInStock) from Products;
select avg(Quantity) from "Order Details"
select sum(Freight) from Orders;
select count(*) as "Tong san pham", avg(UnitPrice) as "Trung binh gia", sum(UnitsInStock) as "Tong hang trong kho" from Products;

-- order by query
select * from Suppliers order by CompanyName asc;
select * from Products order by ProductName desc;
select * from Employees order by FirstName, LastName asc;
select top 1 * from "Order Details" order by Quantity desc;
select OrderId from Orders order by OrderDate desc;
select ProductName, UnitPrice, UnitsInStock from Products order by UnitsInStock desc;

-- +,-,*,/,% query
select ProductName, (UnitsInStock - UnitsOnOrder) as "Hang ton kho" from Products;
select *, (UnitPrice * Quantity) as Price from [Order Details];
select (avg(Freight) / max(Freight)) as FreightRatio from Orders;

-- where query
select * from Employees where(City = 'London') order by FirstName asc;
select * from Orders where ShippedDate > RequiredDate order by CustomerID asc;
select * from "Order Details" where Discount >= 0.1;

-- and, or, not query
select * from Products where UnitsInStock < 50 or UnitsInStock > 100;
select * from Orders where ShipCountry = 'Brazil' and ShippedDate > RequiredDate;
select * from Products where not (UnitPrice > 100 or CategoryID  = 1);

-- between query
select * from Products where UnitPrice between 10 and 20;
select * from Orders where OrderDate between '1996-07-01' and '1996-07-31';
select sum(Freight) from Orders where OrderDate between '1996-07-01' and '1996-07-31';
select top 10 * from Orders where OrderDate between '1997-01-01' and '1997-12-31' and ShipVia = 3;

-- like query
select * from Customers where Country like 'A%';
select * from Suppliers where CompanyName like '%b%';
select * from Customers where ContactName like 'a%';
select * from Customers where ContactName like 'h_%'
select * from Orders where ShipCity like 'L[u,o]%';
select * from Orders where ShipCity like 'L[^u,o]%';

-- in, not in query
select * from Orders where ShipCountry in('Germany', 'UK', 'Brazil');
select * from Orders where ShipCountry not in('Germany', 'UK', 'Brazil');

-- is null, is not null query
select * from Orders where ShippedDate is null;
select * from Orders where ShippedDate is not null;
select * from Customers where CompanyName is null;

-- group by query
select CustomerID, count(OrderId) as "OrderID" from Orders group by CustomerID;
select SupplierID, avg(UnitPrice) from Products group by SupplierID;
select CategoryID, sum(UnitsInStock) from Products group by CategoryID;
select ShipCity, ShipCountry, min(Freight) as "Min", max(Freight) as "Max" from Orders group by ShipCity, ShipCountry;
select Country, count(EmployeeID) from Employees group by Country;

-- day, month, year query
select CustomerID, count(OrderID) as "TotalOrders" , year(OrderDate) as "Year"
from Orders where year(OrderDate) = 1997
group by CustomerID, year(OrderDate);
select * from Orders
where month(OrderDate) = 5 and year(OrderDate) = 1997;
select CustomerID, count(OrderID) as "TotalOrder", month(OrderDate) as "Month"
from Orders
where year(OrderDate)=1998
group by CustomerID, month(OrderDate)
order by month(OrderDate) asc;
select * from Orders where month(ShippedDate)=5 order by year(ShippedDate) asc;

-- having query
select CustomerID, count(OrderID) as "TotalOrder"
from Orders
group by CustomerID
having count(OrderID) >= 20
order by count(OrderID) desc;
select SupplierID, avg(UnitPrice) as "AVGUnitPrice", sum(UnitsInStock) as "SUMUnitsInStock"
from Products group by SupplierID
having avg(UnitPrice)<=50 and sum(UnitsInStock)>=30;
select month(ShippedDate) as "MonthShipped", sum(Freight) as "SumFreight"
from Orders where year(Shippeddate) = 1996
group by month(ShippedDate) having month(ShippedDate) > 6
order by month(ShippedDate) asc;
select ShipCity, count(OrderID) from Orders
group by ShipCity having count(OrderID) > 16
order by count(OrderID) desc;

-- query data from multiple tables
select P.ProductID, P.ProductName, C.CategoryID, C.CategoryName
from Products as P, Categories as C where C.CategoryID = P.CategoryID;
select O.EmployeeID, E.LastName, E.FirstName, count(O.EmployeeID) 
from Orders as O, Employees as E where O.EmployeeID = E.EmployeeID
group by O.EmployeeID, E.LastName, E.FirstName;
select C.CustomerID, CompanyName, ContactName, count(O.OrderID)
from Customers as C, Orders as O where C.CustomerID = O.CustomerID and Country = 'UK'
group by C.CustomerID, CompanyName, ContactName;
select ShipperID, CompanyName, sum(Freight) as "SumFreight" 
from Orders as O, Shippers as S where ShipperID = ShipVia
group by ShipperID, CompanyName order by SumFreight desc;
select top 1 S.SupplierID, CompanyName, count(P.SupplierID) as "CountProducts"
from Products as P, Suppliers as S where S.SupplierID = P.SupplierID 
group by S.SupplierID, CompanyName order by CountProducts desc;
select O.OrderID, sum(OD.Quantity * OD.UnitPrice) from [Order Details] as OD, Orders as O 
where OD.OrderID = O.OrderID group by O.OrderID;
select E.FirstName, E.LastName, O.OrderID, sum(OD.UnitPrice * OD.Quantity) 
from [Order Details] as OD, Orders as O, Employees as E 
where E.EmployeeID = O.EmployeeID and O.OrderID = OD.OrderID
group by E.FirstName, E.LastName, O.OrderID;
select C.CategoryID, CategoryName, ProductID, ProductName from Products as P, Categories as C
where C.CategoryID = P.CategoryID and C.CategoryName = 'Seafood';
select S.SupplierID, S.Country, P.ProductID, P.ProductName from Products P, Suppliers S
where S.SupplierID = P.SupplierID and S.Country = 'Germany';
select OrderID, C.ContactName, S.CompanyName, RequiredDate, ShippedDate 
from Orders O, Customers C, Shippers S
where C.CustomerID = O.CustomerID and O.ShipVia = S.ShipperID and RequiredDate < ShippedDate;
select ShipCountry, count(OrderID) from Customers C, Orders O 
where O.CustomerID = C.CustomerID and C.Country <> 'USA'
group by ShipCountry having count(OrderID) > 100;

-- union and union all query
select distinct Country from Suppliers union select distinct Country from Customers;
select distinct Country from Suppliers union all select distinct Country from Customers;

-- join(inner join), left join, right join, full join
select C.CategoryID, C.CategoryName, P.ProductID, P.ProductName 
from Categories C join Products P on C.CategoryID = P.CategoryID;
select C.CategoryID, C.CategoryName, P.ProductID, P.ProductName 
from Categories C left join Products P on C.CategoryID = P.CategoryID;
select C.CategoryID, C.CategoryName, P.ProductID, P.ProductName 
from Categories C right join Products P on C.CategoryID = P.CategoryID;
select C.CategoryID, C.CategoryName, P.ProductID, P.ProductName 
from Categories C full join Products P on C.CategoryID = P.CategoryID;
select distinct od.ProductID, P.ProductName, S.CompanyName 
from [Order Details] od join Products P on P.ProductID = od.ProductID join Suppliers S on S.SupplierID = P.SupplierID;
select O.OrderID, E.LastName, E.FirstName, C.ContactName 
from Orders O left join Employees E on O.EmployeeID = E.EmployeeID left join Customers C on C.CustomerID = O.CustomerID;
select O.OrderID, E.LastName, E.FirstName, C.ContactName 
from Orders O right join Employees E on O.EmployeeID = E.EmployeeID right join Customers C on C.CustomerID = O.CustomerID;
select C.CategoryName, P.ProductName, S.CompanyName 
from Categories C full join Products P on C.CategoryID = P.CategoryID full join Suppliers S on S.SupplierID = P.SupplierID;

-- subquery
select C.ContactName, count(O.OrderID) 
from Customers C left join Orders O on C.CustomerID = O.CustomerID
group by C.ContactName having count(O.OrderID) > 10;
select * from Customers where(CustomerID in (select CustomerID 
from Orders group by CustomerID having count(OrderID) > 10));
select O.OrderID, sum(OD.Quantity * OD.UnitPrice) 
from Orders O join [Order Details] OD on O.OrderID = OD.OrderID group by O.OrderID;
select O.*, (select sum(OD.Quantity * OD.UnitPrice) 
from [Order Details] OD where OD.OrderID = O.OrderID ) from Orders O;

-- common table expression
with sortEmployees as (select E.EmployeeID, E.FirstName, E.LastName, E.BirthDate from Employees E)
select * from sortEmployees;
select o.OrderID, o.OrderDate, o.Freight, sum(od.UnitPrice * od.Quantity) as TotalPrice, sum(od.UnitPrice * od.Quantity) / o.Freight
from Orders o, [Order Details] od
where o.OrderID = od.OrderID
group by o.OrderID, o.OrderDate, o.Freight;
select o.OrderID, o.OrderDate, o.Freight, (select sum(od.Quantity * od.UnitPrice) 
from [Order Details] od where od.OrderID = o.OrderID) from Orders o;
with totalprice as (select od.OrderID, sum(od.Quantity * od.UnitPrice) as TotalPrice 
from [Order Details] od group by od.OrderID)
select o.OrderID, o.OrderDate, o.Freight, tp.TotalPrice, tp.TotalPrice / o.Freight 
from Orders o, totalprice tp where o.OrderID = tp.OrderID;

-- recursive query
with fibo(prev_n, n) as (
	select 0 as prev_n, 1 as n 
	union all 
	select n as prev_n, prev_n + n as n 
	from fibo
) select top 6 f.n from fibo as f option(maxrecursion 6);
with factorial(n, result) as (
	select 0 as n, 1 as result
	union all
	select (n + 1) as n, (result * (n + 1)) as result
	from factorial
) select * from factorial option(maxrecursion 6);
with e_cte as (
	select e.EmployeeID, e.FirstName, e.ReportsTo, 1 as Level from Employees as e
	where e.EmployeeID = 2
	union all
	select e1.EmployeeID, e1.FirstName, e1.ReportsTo, (Level + 1) as Level from Employees as e1
	join e_cte on e1.ReportsTo = e_cte.EmployeeID
) select * from e_cte option (maxrecursion 500);

-- windows funtion
select p.ProductID, p.ProductName, p.CategoryID, p.UnitPrice,
	rank() over(partition by p.CategoryID order by p.UnitPrice desc) as Ranking
from Products p;
select p.ProductID, p.ProductName, p.CategoryID, p.UnitPrice,
	dense_rank() over(partition by p.CategoryID order by p.UnitPrice desc) as Ranking
from Products p;
select p.ProductID, p.ProductName, p.CategoryID, p.UnitPrice,
	row_number() over(partition by p.CategoryID order by p.UnitPrice desc) as Ranking
from Products p;
select o.CustomerID, o.OrderID, o.OrderDate,
	lag(o.OrderDate) over(partition by o.CustomerID order by o.OrderDate) as PreviousOrderDate
from Orders o;
select o.CustomerID, o.OrderID, o.OrderDate,
	lead(o.OrderDate) over(partition by o.CustomerID order by o.OrderDate) as FollowingOrderDate
from Orders o;
select o.CustomerID, o.OrderID, o.OrderDate,
	first_value(o.CustomerID) over(order by o.OrderDate) as FirstCustomerOrdered
from Orders o;
select o.CustomerID, o.OrderID, o.OrderDate,
	ntile(5) over(order by o.CustomerID) as Part
from Orders o;
select o.CustomerID, o.OrderID, o.OrderDate,
	percent_rank() over(partition by o.CustomerID order by o.OrderDate) as PercentRank
from Orders o;

-- view in sql
create view StatisByMonth as
select year(o.OrderDate) as 'Year', month(o.OrderDate) as 'Month', count(o.OrderID) as 'AmountOrder'
from Orders as o group by year(o.OrderDate), month(o.OrderDate);

-- stored procedures
create procedure getProductsByName(@name nvarchar(30)) as 
begin
	select * from Products p where p.ProductName like @name
end
exec getProductsByName @name = 'Chai';

-- trigger in sql
create trigger makeProductNameUpper on Products
after insert as
begin
	update Products set ProductName = upper(i.ProductName)
	from inserted i where Products.ProductID = i.ProductID
end
create trigger blockUpdateWrongValue on Products
for update as
begin
	set nocount on
	if exists(select 0 from inserted where Discontinued <> 0 and Discontinued <> 1)
	begin
		rollback
		raiserror('Discontinued cannot different 0', 16, 1)
	end
end
create trigger updateProductInventory on [Order Details]
after insert as
begin
	update Products set UnitsInStock = (UnitsInStock - i.Quantity)
	from inserted i
	where Products.ProductID = i.ProductID
end