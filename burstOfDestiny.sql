--Dive into the dataset
SELECT *
FROM PortfolioProject..BOD

--Get types of rarities
SELECT Rarity, Count(Rarity) as Rarity#
FROM PortfolioProject..BOD
GROUP BY Rarity
Order By Rarity#

--Let get the top 10 most common cards pulled
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..BOD
Group By [Card Name], Rarity
Order by Number_Pulled desc
--With this query we can gather what types of cards arent 'short printed'
--But we see that the most types of cards pulled are commons. Lets see whats most printed within each rarity type.

SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..BOD
Group By [Card Name], Rarity
HAVING Rarity = 'Starlight Rare'
Order by Number_Pulled desc


SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..BOD
Group By [Card Name], Rarity
HAVING Rarity = 'Secret Rare'
Order by Number_Pulled DESC

--Show most pulled for 'Ultra Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..BOD
Group By [Card Name], Rarity
HAVING Rarity = 'Ultra Rare'
Order by Number_Pulled desc

--Shows most pulled for 'Super Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..BOD
Group By [Card Name], Rarity
HAVING Rarity = 'Super Rare'
Order by Number_Pulled desc


--Shows most short printed for 'Ultra Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..BOD
Group By [Card Name], Rarity
HAVING Rarity = 'Ultra Rare'
Order by Number_Pulled

--Shows most short printed for 'Super Rare' Type
SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..BOD
Group By [Card Name], Rarity
HAVING Rarity = 'Super Rare'
Order by Number_Pulled

SELECT TOP(10) [Card Name], Rarity, SUM(Price) as Total_Price, Count([Card Name]) as Number_Pulled
FROM PortfolioProject..BOD
Group By [Card Name], Rarity
HAVING Rarity = 'Secret Rare'
Order by Number_Pulled

--Top 10 most expensive cards pulled
SELECT TOP(10) [Card Name], COUNT([Card Name]) as Amount_Pulled, SUM(Price) As Total_Made
FROM PortfolioProject..BOD
Group by [Card Name]
ORDER By Total_Made DESC


--Lets see how much we have made from each type of Rarity in total
SELECT COUNT([Card Name]) as Total_Cards, Rarity, SUM(Price) as Total_Made 
FROM PortfolioProject..BOD
Group By Rarity
Order by Total_Made

--Now lets sum it all together
SELECT COUNT([Card Name]) as Total_Cards, SUM(Price) as Total_Made
FROM PortfolioProject..BOD
Order by Total_Made


--Lets see how much we made per box
SELECT SUM(Price) as Total_Made, [Box Number]
FROM PortfolioProject..BOD
Group By [Box Number]
Order by [Box Number]

WITH CTE
AS
(
SELECT SUM(Price) as Total_Made, [Box Number]
FROM PortfolioProject..BOD
Group By [Box Number]
)
SELECT COUNT([Box Number]) AS Num_of_Boxes, ROUND(AVG(Total_Made), 2) AS Average_Made_Per_Box
FROM CTE


--Lets see how much we made per case
SELECT SUM(Price) as Total_Made, [Case Number]
FROM PortfolioProject..BOD
Group By [Case Number]
Order by [Case Number]

--Lets find our ROI
DROP Table if exists #ROI
SELECT SUM(Price) AS total_made, [Case Number]
INTO #ROI
From PortfolioProject..BOD
Group by [Case Number]
Order By [Case Number]

ALTER TABLE #ROI ADD Initial_investment real NOT NULL DEFAULT 799.95 WITH VALUES

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