------------- Creating the Database------------------------------------------------------
Create database RetailHmwrk;
Use RetailHmwrk;

------------------------------CUSTOMER DATA----------------------------------------------------------------------
------Changing some column data types------------
UPDATE dbo.Customer_data
SET Cust_Gender = LEFT(Cust_Gender, 1);

-------Chaniging some of the data types----------------
Alter Table dbo.Customer_data
Alter Column Cust_Age INT;

Alter Table dbo.Customer_data
Alter Column Cust_Gender Char(1);

------------- Checking for Customer table----------------------------
Select * from dbo.Customer_data;
Exec sp_help 'dbo.Customer_data';


----------------STATISTICS FOR CUSTOMER DATA---------------------------------
-- Count of total customers
Select COUNT(*) as Total_Customers
from dbo.Customer_data;

-- Grouping total customers by Gender
Select COUNT(*) as Total_Customers, Cust_Gender
from dbo.Customer_data
group by Cust_Gender;

-- Grouping Customers by Age to know the age range of customers
Select Cust_Gender, Cust_Age, Count(*) as Total_Age
from dbo.Customer_data
group by Cust_Age, Cust_Gender
order by Cust_Gender, Cust_Age;

-- Checking the minimum, average  and maximum age of customers
Select min(Cust_Age) as Least_Age, max(Cust_Age) as Highest_age, AVG(Cust_Age) as Average_age
from dbo.Customer_data;


-----------------------PRODUCT TABLE ---------------------------------------------------
------Changing some column data types----------------
UPDATE dbo.Product
SET Prdct_Category = LEFT(Prdct_Category,  2);


------ Changing Data Types ------------------------------------
Alter Table dbo.Product
Alter Column Prdct_Category Char(2);


Alter Table dbo.Product
Alter Column Prdct_Amt Decimal(5,2);

Alter Table dbo.Product
Alter Column Prdct_ID Char(15);

----Checking for Duplicates -------------------------
Select Prdct_ID, COUNT(*) AS count
FROM Product
GROUP BY Prdct_ID
HAVING COUNT(*) > 1;


----Removing Duplicates------------------------
With Duplicates as (
    Select Prdct_ID, 
           row_number() over (partition by Prdct_ID order by Prdct_ID) as row_num
    from dbo.Product
)
Delete from dbo.Product
Where Prdct_ID IN (Select Prdct_ID from Duplicates where row_num > 1);

--------------Removing Null------------
Alter Table dbo.Product
Alter Column Prdct_ID CHAR(15) NOT NULL;

----------- Assigning Primary Key----------
ALTER TABLE dbo.Product
ADD CONSTRAINT PK_ProductID PRIMARY KEY (Prdct_ID);

------------- Checking for Product table----------------------------
Select * from dbo.Product;
Exec sp_help 'dbo.Product';

----------STATISTICS FOR PRODUCT TABLE-------------------------------------
-- Total number  of products
Select Count(*) as total_products
from dbo.Product;

--- Product count by category to know quantity of each product by category
Select Prdct_Category, Count(*) as total_products
from dbo.Product
Group by Prdct_Category;

-- Checking to Average price of the products
Select Prdct_Category, AVG(Prdct_Amt) as Avg_Price
from dbo.Product
Group by Prdct_Category;


-- Checking for the Min and Max of the products 
Select Max(Prdct_Amt) as Highest_Price, Min(Prdct_Amt) as Lowest_Price
from dbo.Product;

--- Checking both lowest and highest prices per category
Select Prdct_Category, Max(Prdct_Amt) as Highest_Price, Min(Prdct_Amt) as Lowest_Price
from dbo.Product
Group by Prdct_Category;


--------------------------------------------TRANSACTION DATA----------------------------------------------------
---Changing Data Types---------
Alter Table dbo.Transaction_data
Alter Column Prch_Qnty Int;

--- Attempt to Create foreign Key-----------------
Alter Table dbo.Transaction_data
Alter Constraint fk_Cust_ID
Foreign Key (Cust_ID)
References dbo.Customer_data (Cust_ID);


------------- Checking for Product table----------------------------
Select * from dbo.Transaction_data;
Exec sp_help 'dbo.Transaction_data';

---------------------STATISTICS FOR TRANSACTION TABLE----------------------------------------------------------
---Count of transaction
Select Count(*) as  total_transactions
from dbo.Transaction_data;

--- Counting number of transactions per customer
Select Cust_ID, Count(Distinct Trnst_ID) as total_cust_transactions
from dbo.Transaction_data
group by Cust_ID;

-----Count of purchase by customers
Select Cust_ID, Sum(Prch_Qnty) as Total_Purchase
from dbo.Transaction_data
group by Cust_ID;

----Count of Quantity by products
Select Prdct_ID, Sum(Prch_Qnty) as Total_Purchase
from dbo.Transaction_data
group by Prdct_ID;

--- Average Quantity Purchased
Select AVG(Prch_Qnty) as Average_Quantity, MAX(Prch_Qnty) as Highest_Quantity_Purch, Min(Prch_Qnty) as Lowest_Qunatity_Purch
from dbo.Transaction_data;

---Checking the numnber of purchases by date
Select Year(Trnst_Date) as year, Month(Trnst_Date) as month, Sum(Prch_Qnty) as Total_Purhcases
from dbo.Transaction_data
Group by Year(Trnst_Date),Month(Trnst_Date);


----------------------JOINING TABLES TO CREATE A CSV-----------------------------------------------------------
-- Mapping my  marketing data from all three tables
Select cd.Cust_ID,
       cd.Cust_Gender,
	   cd.Cust_Age,
	   pd.Prdct_ID,
	   pd.Prdct_Category,
	   pd.Prdct_Amt,
	   td.Trnst_ID,
	   td.Trnst_Date,
	   td.Prch_Qnty
from dbo.Customer_data cd
inner join dbo.Transaction_data td on cd.Cust_ID = td.Cust_ID
inner join dbo.Product pd on td.Prdct_ID = pd.Prdct_ID;

-------------Statistics on Marketing Data--------------------
---Checking the Revenue
Select td.Prdct_ID, Sum(td.Prch_Qnty * pd.Prdct_Amt) as Total_revenue
from Product pd
join Transaction_data td on td.Prdct_ID = pd.Prdct_ID
group by td.Prdct_ID;


----Category with Highest Revenue
Select pd.Prdct_Category, Sum(td.Prch_Qnty * pd.Prdct_Amt) as Total_revenue
from Product pd
join Transaction_data td on td.Prdct_ID = pd.Prdct_ID
group by pd.Prdct_Category;