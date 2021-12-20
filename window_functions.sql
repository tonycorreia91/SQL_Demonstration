# ENTERTAINMENT AGENCY DATABASE

# Question 1
# For each customer, display the CustomerId, name of the customer (First name and Last Name)
# separated by a space, StyleName (style of music each customer prefers), and the total number of
# preferences for each customer.

SELECT Musical_Preferences.CustomerID, CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName, StyleName,
COUNT(Musical_Preferences.CustomerID) OVER (PARTITION BY Musical_Preferences.CustomerID) AS TotalPreferences
FROM EntertainmentAgencyExample.Musical_Preferences
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID);

# Question 2
# For each customer, display the CustomerID, name of the customer (first name and last name)
# StyleName (style of music each customer prefers), the total number of preferences for each
# customer, and a running total of the number of styles selected for all the customers. Display
# the results sorted by CustomerName.

SELECT Musical_Preferences.CustomerID, CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName, StyleName,
COUNT(Musical_Preferences.CustomerID) OVER (PARTITION BY Musical_Preferences.CustomerID) AS
TotalPreferences, COUNT(Musical_Preferences.StyleID) OVER (ORDER BY Customers.CustFirstName) AS RunningTotal
FROM EntertainmentAgencyExample.Musical_Preferences
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID);

# Q2 ALTERNATIVE SOLUTION. TECHNICALLY THERE ARE ONLY 20 DISTINCT STYLES PREFERRED. 
# THEREFORE, THE QUERY BELOW HAS A RUNNING TOTAL OF DISTINCT MUSIC STYLES PREFERRED. 

WITH CTE1 AS
(SELECT *, CASE WHEN 1 = ROW_NUMBER() OVER (PARTITION BY Musical_Preferences.StyleID ORDER BY CustFirstName) THEN 1
ELSE 0 END AS Flag
FROM EntertainmentAgencyExample.Musical_Preferences
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID)
ORDER BY CustFirstName)
SELECT CustomerID, CONCAT(CustFirstName,' ',CustLastName) AS CustomerName, StyleName,
COUNT(CustomerID) OVER (PARTITION BY CustomerID) AS TotalPreferences,
SUM(Flag) OVER (ORDER BY CTE1.CustFirstName) AS RunningTotal
FROM CTE1;

# Question 3
# DIsplay the customer city, customer, number of preferences of Music Styles, and a
# running total of preferences for each city overall.

SELECT CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName, 
COUNT(Musical_Preferences.CustomerID) OVER (PARTITION BY Musical_Preferences.CustomerID) AS
TotalCustPreferences, CustCity, COUNT(Musical_Preferences.StyleID) OVER (PARTITION BY CustCity) AS TotalPrefForCity,
 COUNT(Musical_Preferences.StyleID) OVER (ORDER BY CustCity) AS RunningTotalByCity
FROM EntertainmentAgencyExample.Musical_Preferences
JOIN EntertainmentAgencyExample.Customers USING (CustomerID);

# Q3 ALTERNATIVE SOLUTION. TECHNICALLY THERE ARE ONLY 20 DISTINCT STYLES PREFERRED. 
# THEREFORE, THE QUERY BELOW HAS A RUNNING TOTAL OF DISTINCT MUSIC STYLES PREFERRED, SORTED BY CITY NAME. 

WITH CTE1 AS
(SELECT *, CASE WHEN 1 = ROW_NUMBER() OVER (PARTITION BY Musical_Preferences.StyleID ORDER BY CustCity) THEN 1
ELSE 0 END AS Flag
FROM EntertainmentAgencyExample.Musical_Preferences
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID)
ORDER BY CustFirstName)
SELECT CONCAT(CustFirstName,' ',CustLastName) AS CustomerName,
COUNT(CustomerID) OVER (PARTITION BY CustomerID) AS TotalPreferences, StyleName, CustCity,
SUM(Flag) OVER (ORDER BY CTE1.CustCity) AS RunningTotalByCity
FROM CTE1;

# Question 4
# Assign a row number for each customer. Display their CustomerID, their combined First
# and Last Name, and their state. Return the customers in alphabetical order.

SELECT ROW_NUMBER() OVER (ORDER BY CustFirstName) AS Num, CustomerID,
CONCAT (CustFirstName, ' ', CustLastName) AS CustomerName, CustState
FROM EntertainmentAgencyExample.Customers;

# Question 5
# Assign a number for each customer within each city in each state. Display their Customer ID
# their combined name, their city and their state. Return the customers in alphabetical order.
 
# ALPHABETICAL ORDER WITHIN EACH PARTITION
SELECT CustomerID, CONCAT (CustFirstName, ' ', CustLastName) AS CustomerName,
ROW_NUMBER() OVER (PARTITION BY CustCity ORDER BY CustFirstName) AS CustNum, CustCity, CustState
FROM EntertainmentAgencyExample.Customers;

# ALTERNATIVE: ALPHABETICAL ORDER OVERALL
SELECT CustomerID, CONCAT (CustFirstName, ' ', CustLastName) AS CustomerName,
ROW_NUMBER() OVER (PARTITION BY CustCity ORDER BY CustFirstName) AS CustNum, CustCity, CustState
FROM EntertainmentAgencyExample.Customers
ORDER BY CustFirstName;

# Question 6
# Show a list of all engagements. Display the start date for each engagement, the name of the
# customer, and the entertainer. Number the entertainers overall and number the engagements
# within each start date.
WITH CTE AS
(SELECT EntertainerID, ROW_NUMBER() OVER (ORDER BY EntStageName) AS EntertainerNum
FROM EntertainmentAgencyExample.Entertainers)
SELECT EngagementNumber, StartDate, ROW_NUMBER() OVER (PARTITION BY StartDate ORDER BY StartDate)
AS EngagementTotalByDate, CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName, EntStageName, EntertainerNum
FROM EntertainmentAgencyExample.Engagements
JOIN CTE USING (EntertainerID)
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
JOIN EntertainmentAgencyExample.Customers USING (CustomerID);

# Question 7
# Rank all the entertainers based on the number of engagements booked for each. Arrange
# the entertainers into three groups (buckets). Remember to include any entertainers who
# haven't been booked for any engagements.

WITH CTE AS
(SELECT COUNT(Engagements.EntertainerID) AS NumberOfEngagements, EntStageName
FROM EntertainmentAgencyExample.Entertainers
LEFT JOIN EntertainmentAgencyExample.Engagements ON
Entertainers.EntertainerID = Engagements.EntertainerID
GROUP BY EntStageName)
SELECT *, NTILE(3) OVER (ORDER BY NumberOfEngagements DESC) AS BucketGroup
FROM CTE;

# Question 8
#  Rank all the agents based on the total dollars associated with the engagements that they've
# booked. Make sure to include any agents that haven't booked any acts.

WITH CTE AS
(SELECT SUM(ContractPrice) AS TotalDollarsBooked, Agents.AgentID, CONCAT(AgtFirstName, ' ', AgtLastName) AS AgentName
FROM EntertainmentAgencyExample.Agents
LEFT JOIN EntertainmentAgencyExample.Engagements
ON Agents.AgentID = Engagements.AgentID
GROUP BY AgentID)
SELECT RANK() OVER (ORDER BY TotalDollarsBooked DESC) AS 'Rank', AgentName, TotalDollarsBooked
FROM CTE;

# Question 9
# Display a list of all the engagements our entertainers are booked for. Display the
# entertainer's stage name, the customer's (combined) name, and the start date for
# each engagements, as well as the total number of engagements booked for each entertainer.

SELECT EngagementNumber, EntStageName, CONCAT(CustFirstName, ' ', CustLastName) AS CustomerName,
StartDate, COUNT(Engagements.EntertainerID) OVER (PARTITION BY Engagements.EntertainerID RANGE BETWEEN
UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS TotalBookingsforEntertainer
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID);

# Question 10
# Display a list of all the Entertainers and their members. Number each member within a group.
 
SELECT ROW_NUMBER() OVER (PARTITION BY Entertainer_Members.EntertainerID) AS MemberNumber, CONCAT(MbrFirstName, ' ',MbrLastName)
AS MemberName, EntStageName
FROM EntertainmentAgencyExample.Entertainer_Members
JOIN EntertainmentAgencyExample.Members USING (MemberID)
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID);

# Question 1 AP
# Display VendorID, Balance Due, total balance for all vendors, and total balance for each vendor.

WITH CTE AS
(SELECT *, (invoice_total - payment_total - Credit_total) AS balance
FROM accountspayable.invoices)
SELECT Vendor_ID, Balance, SUM(Balance) OVER (PARTITION BY Vendor_ID ORDER BY Vendor_ID RANGE BETWEEN UNBOUNDED PRECEDING AND
UNBOUNDED FOLLOWING) AS BalanceByVendor, SUM(Balance) OVER (ORDER BY Vendor_ID RANGE BETWEEN UNBOUNDED PRECEDING AND 
UNBOUNDED FOLLOWING) AS TotalAR
FROM CTE
WHERE Balance <> 0;

# Question 2 AP
# Modify AP1 to include Avg Balance by Vendor.
WITH CTE AS
(SELECT *, (invoice_total - payment_total - Credit_total) AS balance
FROM accountspayable.invoices)
SELECT Vendor_ID, Balance, SUM(Balance) OVER (PARTITION BY Vendor_ID ORDER BY Vendor_ID RANGE BETWEEN UNBOUNDED PRECEDING AND
UNBOUNDED FOLLOWING) AS BalanceByVendor, ROUND(AVG(Balance) OVER (PARTITION BY Vendor_ID ORDER BY Vendor_ID RANGE BETWEEN UNBOUNDED PRECEDING AND
UNBOUNDED FOLLOWING),2) AS AVGBalanceByVendor, SUM(Balance) OVER (ORDER BY Vendor_ID RANGE BETWEEN UNBOUNDED PRECEDING AND 
UNBOUNDED FOLLOWING) AS TotalAR
FROM CTE
WHERE Balance <> 0;

# Question 3 AP
# Write a query to calc the moving average of the sum of the invoice totals. Display the month of the invoice date, sum of the
# invoice totals, and the 4-month moving average of the invoice totals sorted by invoice month.
WITH CTE AS
(SELECT MONTH(Invoice_Date) AS InvMonth, sum(invoice_total) AS InvoiceMonthlyTotal
FROM accountspayable.invoices
GROUP BY InvMonth)
SELECT InvMonth, InvoiceMonthlyTotal, ROUND(AVG(InvoiceMonthlyTotal) OVER (ORDER BY InvMonth RANGE BETWEEN
4 PRECEDING AND CURRENT ROW),2) AS 4MonthRollingAVG, SUM(InvoiceMonthlyTotal) OVER (ORDER BY InvMonth RANGE BETWEEN
UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS InvoiceGrandTotal
FROM CTE;