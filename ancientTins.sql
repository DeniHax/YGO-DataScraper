--Dive into the dataset
SELECT *
FROM PortfolioProject..AncientTins

--Get types of rarities
SELECT Rarity, Count(Rarity) as Rarity#
FROM PortfolioProject..AncientTins
GROUP BY Rarity
Order By Rarity#
--From the above query we gather that each pack has the same amount of 'Prismatic Secret Rare's' and 'Rare's' as well as 'Ultra rares' and 'Super rares'

--Let get the top 10 most common cards pulled
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
Order by Number_Pulled desc
--With this query we can gather what types of cards arent 'short printed'
--But we see that the most types of cards pulled are commons. Lets see whats most printed within each rarity type.

SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Prismatic Secret Rare'
Order by Number_Pulled desc
--With the above query we gather that Parallel eXceed and Raviel, Lord of Phantasms are tied with the most pulled. Lets check what was the most 'short printed' card.

SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Prismatic Secret Rare'
Order by Number_Pulled
-- We have a tie between 3 different cards but luckily they are the cheapest in their rarity type.
--Lets go back to checking the other rarity types.

--Shows most pulled for 'Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Rare'
Order by Number_Pulled desc

--Show most pulled for 'Ultra Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Ultra Rare'
Order by Number_Pulled desc

--Shows most pulled for 'Super Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Super Rare'
Order by Number_Pulled desc

--The below queries will show the most 'short printed' cards

--This shows the most short printed for 'Rare' Types
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Rare'
Order by Number_Pulled
--Adamancipator Friends as the most short printed in 'Rare' Types

--This shows the most short printed for 'Prismatic Secret Rares'
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Prismatic Secret Rare'
Order by Number_Pulled 

--Shows most short printed for 'Ultra Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Ultra Rare'
Order by Number_Pulled

--Shows most short printed for 'Super Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..AncientTins
Group By [Card Name], Rarity
HAVING Rarity = 'Super Rare'
Order by Number_Pulled

--Top 10 most expensive cards pulled
SELECT TOP(10) [Card Name], COUNT([Card Name]) as Amount_Pulled, SUM(Price) As Total_Made
FROM PortfolioProject..AncientTins
Group by [Card Name]
ORDER By Total_Made DESC



--Lets dive into the numbers

--Lets see how much we have made from each type of Rarity in total
SELECT COUNT([Card Name]) as Total_Cards, Rarity, SUM(Price) as Total_Made 
FROM PortfolioProject..AncientTins
Group By Rarity
Order by Total_Made

--Now lets sum it all together
SELECT COUNT([Card Name]) as Total_Cards, SUM(Price) as Total_Made
FROM PortfolioProject..AncientTins
Order by Total_Made
--Total of 1,908 Cards pulled with 799.95 dollars made

--Lets see how much we made per box
SELECT SUM(Price) as Total_Made, [Box Number]
FROM PortfolioProject..AncientTins
Group By [Box Number]
Order by [Box Number]
--We see a large range of profit made to profit loss. Lets find the average we made per box

WITH CTE
AS
(
SELECT SUM(Price) as Total_Made, [Box Number]
FROM PortfolioProject..AncientTins
Group By [Box Number]
)
SELECT COUNT([Box Number]) AS Num_of_Boxes, ROUND(AVG(Total_Made), 2) AS Average_Made_Per_Box
FROM CTE
--We see that an average amount made per box opening is $22.22

--Lets see how much we made per case
SELECT SUM(Price) as Total_Made, [Case Number]
FROM PortfolioProject..AncientTins
Group By [Case Number]
Order by [Case Number]

--The initial investment was 139.95 for each case and a case containg 12 boxes per case.
-- Which leaves us with each box costing $11.66
--Which means we double our money with the average amount made per box opening being $22.22

--Lets find our ROI
DROP Table if exists #ROI
SELECT SUM(Price) AS total_made, [Case Number]
INTO #ROI
From PortfolioProject..AncientTins
Group by [Case Number]
Order By [Case Number]

ALTER TABLE #ROI ADD Initial_investment real NOT NULL DEFAULT 139.95 WITH VALUES

SELECT *
FROM #ROI

SELECT ROUND(SUM(Initial_investment), 2) AS Total_Investment, SUM(Total_made) as Total_Return
FROM #ROI

--Calculate ROI
WITH roiCTE(Total_Investment, Total_Return)
AS
(
SELECT ROUND(SUM(Initial_investment), 2) AS Total_Investment, 
		SUM(Total_made) as Total_Return
FROM #ROI
)
SELECT ((Total_Return - Total_Investment)  / Total_Investment) * 100 AS ROI
FROM roiCTE