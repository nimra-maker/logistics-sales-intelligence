-- Logistics Sales Intelligence
-- SQL Server (SSMS)
-- Table name: logistics_data

USE LogisticsSalesDB;
GO

-- BUSINESS PERFORMANCE OVERVIEW

SELECT
    COUNT(*) AS Total_Inquiries,
    SUM(Revenue_USD) AS Total_Revenue,
    SUM(Cost_USD) AS Total_Cost,
    SUM(Revenue_USD - Cost_USD) AS Total_Profit,
    ROUND(
        100.0 * SUM(Revenue_USD - Cost_USD) /
        NULLIF(SUM(Revenue_USD), 0), 2
    ) AS Profit_Margin_Percentage
FROM dbo.logistics_data;


-- INQUIRIES BY JOB STATUS

SELECT
    Job_Status,
    COUNT(*) AS Total_Inquiries
FROM dbo.logistics_data
GROUP BY Job_Status
ORDER BY Total_Inquiries DESC;


-- SALESPERSON PERFORMANCE

SELECT
    Salesperson,
    COUNT(*) AS Total_Inquiries,
    SUM(Revenue_USD) AS Total_Revenue,
    SUM(Revenue_USD - Cost_USD) AS Total_Profit
FROM dbo.logistics_data
GROUP BY Salesperson
ORDER BY Total_Revenue DESC;


-- FCL VS LCL ANALYSIS

SELECT
    Mode,
    COUNT(*) AS Total_Shipments,
    SUM(Revenue_USD) AS Total_Revenue
FROM dbo.logistics_data
GROUP BY Mode
ORDER BY Total_Shipments DESC;


-- TOP DESTINATION PORTS

SELECT TOP 5
    POD,
    COUNT(*) AS Total_Inquiries,
    SUM(Revenue_USD) AS Total_Revenue
FROM dbo.logistics_data
GROUP BY POD
ORDER BY Total_Inquiries DESC;


-- SHIPMENT DELAY ANALYSIS

SELECT
    Inquiry_ID,
    POL,
    POD,
    ETA_Date,
    Actual_Arrival_Date,
    DATEDIFF(
        DAY,
        ETA_Date,
        Actual_Arrival_Date
    ) AS Delay_Days
FROM dbo.logistics_data
WHERE ETA_Date IS NOT NULL
  AND Actual_Arrival_Date IS NOT NULL
  AND Actual_Arrival_Date > ETA_Date
ORDER BY Delay_Days DESC;
