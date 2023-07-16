--Perform the following with help of the above database:
--a. Get all the details from the person table including email ID, phone number and phone number type
select * from [Person].[Person];
select * from [Person].[EmailAddress];
select * from [Person].[PersonPhone];
select * from [Person].[PhoneNumberType];

select P.*,PE.EmailAddress,PP.PhoneNumber,PPT.PhoneNumberTypeID from [Person].[Person] P inner join [Person].[EmailAddress] PE
on P.BusinessEntityID = PE.BusinessEntityID 
inner join [Person].[PersonPhone] PP on PE.BusinessEntityID=PP.BusinessEntityID inner join
[Person].[PhoneNumberType] PPT on PP.PhoneNumberTypeID=PPT.PhoneNumberTypeID;


--b. Get the details of the sales header order made in May 2011
select* from [Sales].[SalesOrderHeader]
where YEAR(OrderDate)='2011' and Month(OrderDate)=05;
--c. Get the details of the sales details order made in the month of May 2011
select * from [Sales].[SalesOrderDetail] SOD inner join [Sales].[SalesOrderHeader] SOH
on SOD.SalesOrderID=SOH.SalesOrderID where YEAR(SOH.OrderDate)='2011' and Month(SOH.OrderDate)=05;
--d. Get the total sales made in May 2011
select* from[Sales].[SalesOrderHeader]
select* from[Sales].[SalesOrderDetail]
select sum(sod.LineTotal) from [Sales].[SalesOrderDetail] SOD inner join [Sales].[SalesOrderHeader] SOH
on SOD.SalesOrderID=SOH.SalesOrderID where YEAR(SOH.OrderDate)='2011' and Month(SOH.OrderDate)=05;

--e. Get the total sales made in the year 2011 by month order by increasing sales
select* from[Sales].[SalesOrderHeader]
select* from[Sales].[SalesOrderDetail]

select sum(sod.LineTotal) as Total_Sales,DATENAME(MM,OrderDate)as Month_Name from [Sales].[SalesOrderDetail] SOD inner join [Sales].[SalesOrderHeader] SOH
on SOD.SalesOrderID=SOH.SalesOrderID 
where YEAR(SOH.OrderDate)='2011';
Group by DATENAME(MM,OrderDate)
Order by Total_Sales;
;
--f. Get the name of the person table where FirstName start with G

select Firstname from [Person].[Person]
where FirstName like 'G%';