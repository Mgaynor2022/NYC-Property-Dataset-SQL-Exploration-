--Uploaded the csv. file and found Borough column datatype needs to be changeed from interger to string. 
CREATE
	OR REPLACE TABLE `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `AS

SELECT *

EXCEPT

(BOROUGH)
	,CAST(BOROUGH AS STRING) AS BOROUGH
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `;

--Updating BOROUGH column.  Borough code: Manhattan (1), Bronx (2), Brooklyn (3), Queens (4), and Staten Island (5).

UPDATE `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
SET BOROUGH = 'Manhattan'
WHERE BOROUGH = "1";

UPDATE `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
SET BOROUGH = 'Bronx'
WHERE BOROUGH = "2";

UPDATE `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
SET BOROUGH = 'Brooklyn'
WHERE BOROUGH = "3";

UPDATE `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
SET BOROUGH = 'Queens'
WHERE BOROUGH = "4";

UPDATE `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
SET BOROUGH = 'Staten Island'
WHERE BOROUGH = "5";

-- Checking to view the data I am working with. 
SELECT *
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `;

--Checking to see if there are any Null values. 
SELECT *
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
WHERE BOROUGH IS NULL
	OR NEIGHBORHOOD IS NULL
	OR BUILDING_CLASS_AT_PRESENT IS NULL
	OR YEAR_BUILT IS NULL
	OR YEAR_SOLD IS NULL;

-- Making a subquery to see which borough most sales by percentage. 
SELECT BOROUGH
	,COUNT(*) * 100 / (
		SELECT COUNT(*)
		FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
		) AS Borough_Sales
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
GROUP BY BOROUGH;

-- Looking to see what Neighboorhood people want to live in top 20. 
SELECT NEIGHBORHOOD
	,COUNT(*) Neighborhood_Sales
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
GROUP BY NEIGHBORHOOD
ORDER BY Neighborhood_Sales DESC LIMIT 20;

--Which Sells More RESIDENTIAL_UNITS or COMMERCIAL_UNITS
SELECT SUM(RESIDENTIAL_UNITS) AS Total_RESIDENTIAL_UNITS
	,SUM(SALE_PRICE) AS Total_Sale_Price
	,YEAR_SOLD
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
WHERE RESIDENTIAL_UNITS > 0
GROUP BY YEAR_SOLD;

SELECT SUM(COMMERCIAL_UNITS) AS Total_COMMERCIAL_UNITS
	,SUM(SALE_PRICE) AS Total_Sale_Price
	,YEAR_SOLD
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
WHERE COMMERCIAL_UNITS > 0
GROUP BY YEAR_SOLD;

-- Find out how old the buildings are, when they were sold. Change yeat_built to date in excel  
SELECT BOROUGH
	,YEAR_SOLD
	,YEAR_BUILT
	,YEAR_SOLD - YEAR_BUILT AS Building_Age
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `;

-- Which Borough and neighborhood  have the higest SALE_PRICE.
SELECT BOROUGH
	,NEIGHBORHOOD
	,AVG(SALE_PRICE) AS Avg_sale_price
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
GROUP BY BOROUGH
	,NEIGHBORHOOD
	,SALE_PRICE
ORDER BY Avg_sale_price DESC;

-- See the average SALE_PRICE per borough 
SELECT BOROUGH
	,AVG(SALE_PRICE) AS Avg_borough_sale_price
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
GROUP BY BOROUGH
ORDER BY Avg_borough_sale_price DESC;

-- Created a case statement to see which neighborhood has the most property sells on Houses.
SELECT BOROUGH
	,NEIGHBORHOOD
	,COUNT(CASE 
			WHEN BUILDING_CLASS_AT_PRESENT BETWEEN 'A1'
					AND 'A5'
				THEN "One Family House"
			END) AS One_Family_House
	,COUNT(CASE 
			WHEN BUILDING_CLASS_AT_PRESENT BETWEEN 'B1'
					AND 'B5'
				THEN 'Two Family House'
			END) AS Two_Family_House
	,COUNT(CASE 
			WHEN BUILDING_CLASS_AT_PRESENT BETWEEN 'R0'
					AND 'R8'
				THEN 'CONDO'
			END) AS Condo
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
GROUP BY BOROUGH
	,NEIGHBORHOOD;

-- Created a case statement to see which neighborhood is good for commercial buildings. 
SELECT BOROUGH
	,NEIGHBORHOOD
	,COUNT(CASE 
			WHEN BUILDING_CLASS_AT_PRESENT BETWEEN 'O1'
					AND 'O9'
				THEN "Office Space"
			END) AS Office_Space
	,COUNT(CASE 
			WHEN BUILDING_CLASS_AT_PRESENT BETWEEN 'F1'
					AND 'F9'
				THEN 'Factory'
			END) AS Factory
	,COUNT(CASE 
			WHEN BUILDING_CLASS_AT_PRESENT BETWEEN 'S0'
					AND 'S9'
				THEN 'CONDO'
			END) AS Condo
FROM `dirty - TO - clean - 344721. nyc_data.nyc_property_sales `
GROUP BY BOROUGH
	,NEIGHBORHOOD;
