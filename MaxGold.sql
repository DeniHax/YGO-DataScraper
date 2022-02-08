--Take a look into the dataset
SELECT *
FROM PortfolioProject..MaxGold

--Show The least amount of times specific cards appear.
Select [Card Name], Price, Count([Card Name]) as Number_of_Appearances
FROM PortfolioProject..MaxGold
Group By [Card Name], Price
ORDER BY Number_of_Appearances

--Show the most amount of times cards appear.
Select [Card Name], Price, Count([Card Name]) as Number_of_Appearances
FROM PortfolioProject..MaxGold
Group By [Card Name], Price
ORDER BY Number_of_Appearances DESC

--Show top 10 Expensive cards pulled
SELECT DISTINCT TOP(10) [Card Name], Rarity, Price
FROM PortfolioProject..MaxGold
Order By Price DESC

--Check how many times we have received each of those cards that are in the top 10 most expensive
SELECT TOP(10) [Card Name], Rarity, Price, COUNT([Card Name]) AS Amount_Pulled
FROM PortfolioProject..MaxGold
GROUP BY [Card Name], Rarity, Price
ORDER BY Price DESC

--Get Total Price of Every card Pulled
SELECT COUNT([Card Name]) AS Amount_Pulled, SUM(Price) AS Total_Made
FROM PortfolioProject..MaxGold

--Get the total price of 'Rare' Cards
SELECT COUNT(Rarity) AS Number_of_Rares_Pulled, SUM(Price) AS Total_Made
FROM PortfolioProject..MaxGold
WHERE Rarity = 'Rare'


--Get the total price of 'Premium Gold Rare' Cards
SELECT COUNT(Rarity) AS Number_of_Prem_Rares_Pulled, SUM(Price) AS Total_Made
FROM PortfolioProject..MaxGold
WHERE Rarity = 'Premium Gold Rare'

--Get Total Price pulled from each case number
SELECT SUM(Price) AS total_made, [Case Number]
From PortfolioProject..MaxGold
Group by [Case Number]
Order By [Case Number]

--Get Average made from each case using CTE
WITH CTE (total_made, [Case Number])
AS
(
SELECT SUM(Price) AS total_made, [Case Number]
From PortfolioProject..MaxGold
Group by [Case Number]
)
SELECT AVG(total_made) As Average_Made
FROM CTE

--Create temp table showing ROI
--We want to add column that shows initial invest which is $349.95 // Source is from here: https://www.dacardworld.com/gaming/yu-gi-oh-maximum-gold-el-dorado-booster-4-box-case#details
--Anohter column which shows the Total Made from each case
--Then we want to show the results by summing the initial invest of each case then sum the total made and calculate the ROI

DROP Table if exists #ROI
SELECT SUM(Price) AS total_made, [Case Number]
INTO #ROI
From PortfolioProject..MaxGold
Group by [Case Number]
Order By [Case Number]

ALTER TABLE #ROI ADD Initial_investment real NOT NULL DEFAULT 349.95 WITH VALUES

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