-- QUERY 1: Retrieve all records from the 'nigeria_houses_data$' table.
SELECT 
	* 
FROM
	PortfolioProject..nigeria_houses_data$;

-- QUERY 2: List states,town,price from the 'nigeria_houses_data$' table.
SELECT 
	state,
	town,
	price
FROM	
	PortfolioProject..nigeria_houses_data$

-- QUERY 3: Calculate the total price of houses by state, sorted in descending order.
SELECT 
  state,
  SUM(price) AS PriceByState 
FROM PortfolioProject..nigeria_houses_data$
GROUP BY state
ORDER BY PriceByState DESC;

-- QUERY 4: Calculate the total price of houses by state (rounded to 2 decimal places), sorted in descending order.
SELECT 
  state,
  ROUND(SUM(price), 2) AS PriceByState 
FROM PortfolioProject..nigeria_houses_data$
GROUP BY state
ORDER BY PriceByState DESC;

-- QUERY 5: Calculate the average price of houses by state (rounded to 2 decimal places), sorted in descending order.
SELECT    
  state,
  ROUND(AVG(price), 2) AS AvgPriceByState 
FROM PortfolioProject..nigeria_houses_data$
GROUP BY state
ORDER BY AvgPriceByState DESC; 

-- QUERY 6: Calculate the propertycount, total price, and average price per property title.
SELECT 
  title,  
  COUNT(title) AS Propertycount,
  SUM(price) AS totalPrice_per_Property
FROM PortfolioProject..nigeria_houses_data$
GROUP BY title
ORDER BY 1;

-- QUERY 7: Calculate the average price of houses by town, sorted in descending order.
SELECT 
	town,
	AVG(price) AS avg_price
FROM PortfolioProject..nigeria_houses_data$
GROUP BY town
ORDER BY avg_price DESC;

-- QUERY 8: Calculate the average price of houses by town (rounded to 2 decimal places),
-- for towns with the highest and lowest average prices.
SELECT 
    town,
    ROUND(AVG(price), 2) AS avg_price
FROM PortfolioProject..nigeria_houses_data$
GROUP BY town
HAVING AVG(price) IN (
    SELECT MAX(avg_price) FROM (
        SELECT town, AVG(price) AS avg_price 
        FROM PortfolioProject..nigeria_houses_data$ 
        GROUP BY town
    ) town
    UNION
    SELECT MIN(avg_price) FROM (
        SELECT town, AVG(price) AS avg_price 
        FROM PortfolioProject..nigeria_houses_data$ 
        GROUP BY town
    ) town
);
-- VIEW 1: 'Town_highest_and_lowest'
-- This view calculates and stores the average price of houses for each town,
-- considering towns with both the highest and lowest average prices.

CREATE VIEW Town_highest_and_lowest AS
SELECT 
    town,
    ROUND(AVG(price), 2) AS avg_price
FROM PortfolioProject..nigeria_houses_data$
GROUP BY town
HAVING AVG(price) IN (
    SELECT MAX(avg_price) FROM (
        SELECT town, AVG(price) AS avg_price 
        FROM PortfolioProject..nigeria_houses_data$ 
        GROUP BY town
    ) town
    UNION
    SELECT MIN(avg_price) FROM (
        SELECT town, AVG(price) AS avg_price 
        FROM PortfolioProject..nigeria_houses_data$ 
        GROUP BY town
    ) town
);

-- VIEW 2: 'AvgPriceByTown'
-- This view calculates and stores the average price of houses for each town.

CREATE VIEW AvgPriceByTown AS
SELECT 
	town,
	AVG(price) AS avg_price
FROM PortfolioProject..nigeria_houses_data$
GROUP BY town;

-- VIEW 3: 'PropertycountPriceByTitle'
-- This view calculates and stores the count of properties and the total price per property title.

CREATE VIEW PropertycountPriceByTitle AS
SELECT 
  title,  
  COUNT(title) AS Propertycount,
  SUM(price) AS totalPrice_per_Property
FROM PortfolioProject..nigeria_houses_data$
GROUP BY title;

