
-- Logistics Sales Intelligence
-- SQL Server (SSMS)
-- Table name: LogisticsData

-- 1. Overall business KPIs
SELECT
    COUNT(*) AS Total_Inquiries,
    COUNT(DISTINCT Inquiry_ID) AS Unique_Inquiries,
    SUM(Revenue_USD) AS Total_Revenue_USD,
    SUM(Cost_USD) AS Total_Cost_USD,
    SUM(Revenue_USD - Cost_USD) AS Total_Profit_USD,
    AVG(Revenue_USD) AS Average_Revenue_USD
FROM LogisticsData;


-- 2. Job status breakdown
SELECT
    Job_Status,
    COUNT(*) AS Inquiry_Count,
    SUM(Revenue_USD) AS Total_Revenue_USD
FROM LogisticsData
GROUP BY Job_Status
ORDER BY Inquiry_Count DESC;


-- 3. Salesperson performance
SELECT
    Salesperson,
    COUNT(*) AS Total_Inquiries,
    SUM(Revenue_USD) AS Total_Revenue_USD,
    SUM(Cost_USD) AS Total_Cost_USD,
    SUM(Revenue_USD - Cost_USD) AS Total_Profit_USD
FROM LogisticsData
GROUP BY Salesperson
ORDER BY Total_Revenue_USD DESC;


-- 4. FCL vs. LCL performance
SELECT
    Mode,
    COUNT(*) AS Total_Inquiries,
    SUM(Revenue_USD) AS Total_Revenue_USD,
    SUM(Revenue_USD - Cost_USD) AS Total_Profit_USD
FROM LogisticsData
GROUP BY Mode
ORDER BY Total_Revenue_USD DESC;


-- 5. Top 10 destination ports
SELECT TOP 10
    POD AS Destination_Port,
    COUNT(*) AS Total_Inquiries,
    SUM(Revenue_USD) AS Total_Revenue_USD,
    SUM(Revenue_USD - Cost_USD) AS Total_Profit_USD
FROM LogisticsData
GROUP BY POD
ORDER BY Total_Revenue_USD DESC;


-- 6. Follow-up requirements
SELECT
    Follow_Up_Required,
    COUNT(*) AS Total_Inquiries
FROM LogisticsData
GROUP BY Follow_Up_Required
ORDER BY Total_Inquiries DESC;


-- 7. Monthly revenue trend
SELECT
    YEAR(Inquiry_Date) AS Inquiry_Year,
    MONTH(Inquiry_Date) AS Inquiry_Month,
    SUM(Revenue_USD) AS Monthly_Revenue_USD,
    SUM(Cost_USD) AS Monthly_Cost_USD,
    SUM(Revenue_USD - Cost_USD) AS Monthly_Profit_USD
FROM LogisticsData
WHERE Inquiry_Date IS NOT NULL
GROUP BY YEAR(Inquiry_Date), MONTH(Inquiry_Date)
ORDER BY Inquiry_Year, Inquiry_Month;


-- 8. Shipment arrival performance
SELECT
    COUNT(*) AS Records_With_Actual_Arrival,
    AVG(CAST(DATEDIFF(
        DAY, ETA_Date, Actual_Arrival_Date
    ) AS FLOAT)) AS Average_Delay_Days,
    SUM(CASE
        WHEN Actual_Arrival_Date > ETA_Date THEN 1
        ELSE 0
    END) AS Delayed_Shipments,
    SUM(CASE
        WHEN Actual_Arrival_Date <= ETA_Date THEN 1
        ELSE 0
    END) AS On_Time_Or_Early_Shipments
FROM LogisticsData
WHERE ETA_Date IS NOT NULL
  AND Actual_Arrival_Date IS NOT NULL;


-- 9. Individual shipments arriving late
SELECT
    Inquiry_ID,
    Customer,
    POL,
    POD,
    ETA_Date,
    Actual_Arrival_Date,
    DATEDIFF(DAY, ETA_Date, Actual_Arrival_Date)
        AS Delay_Days
FROM LogisticsData
WHERE ETA_Date IS NOT NULL
  AND Actual_Arrival_Date > ETA_Date
ORDER BY Delay_Days DESC;


-- 10. Revenue by zone
SELECT
    Zone,
    COUNT(*) AS Total_Inquiries,
    SUM(Revenue_USD) AS Total_Revenue_USD,
    SUM(Revenue_USD - Cost_USD) AS Total_Profit_USD
FROM LogisticsData
GROUP BY Zone
ORDER BY Total_Revenue_USD DESC;
