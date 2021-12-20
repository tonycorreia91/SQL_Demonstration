# Anthony (Tony) Correia
# Data Management
# Homework 4

# COLONIAL DATABASE

# Question 1
# List the reservation ID, trip ID, and trip date for reservations for a trip in Maine (ME). 
# Write this query one way using JOIN and two ways using subqueries. In total, you will write three queries 
# returning the same result set. One query will use only JOINs and no subqueries. The other two will use 
# subquerires (with or without joins, if applicable).

# 1b.
SELECT ReservationID, TripID, TripDate
FROM colonial.reservation
WHERE TripID IN (SELECT TripID FROM
Colonial.Trip
WHERE State = "ME");

# 1c.
SELECT ReservationID, TripID, TripDate
FROM colonial.reservation
WHERE EXISTS (SELECT *
FROM colonial.trip
WHERE State = "ME"
AND trip.TripID = reservation.TripID);

# Question 2
# Find the trip ID and trip name for each trip whose maximum group size is greater than the maximum group size 
# of every trip that has a the type Hiking.

SELECT TripID, TripName, MaxGrpSize
FROM colonial.trip
WHERE MaxGrpSize > ALL (SELECT MaxGrpSize
FROM Colonial.Trip
WHERE Type = 'Hiking');

# Question 3
# Find the trip ID and trip name for each trip whose maximum group size is greater than the maximum group size 
# of at least one trip that has the type biking.

SELECT TripID, TripName
FROM Colonial.trip
WHERE MaxGrpSize > ANY (SELECT MaxGrpSize
FROM colonial.Trip
WHERE Type = "Biking");

#Entertainment Agency Database

# Question 1
# Display all the entertainers who played engagements for customers Berg and Hallmark. 
# For this question, write the query in two different ways - each way will use subqueries (with joins). 
# So in all you will write two different queries - each returning the same resultset.

#1a.
SELECT DISTINCT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.entertainers
JOIN entertainmentAgencyExample.engagements USING (EntertainerID)
WHERE engagements.customerID = ANY (SELECT customers.CustomerID
FROM entertainmentAgencyExample.Customers
WHERE CustLastName = "Berg"
OR CustLastName = "Hallmark")
ORDER BY EntertainerID;

#1b.
SELECT DISTINCT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.entertainers
JOIN EntertainmentAgencyExample.engagements USING (EntertainerID)
WHERE CustomerID IN (SELECT CustomerID
FROM EntertainmentAgencyExample.Customers
WHERE CustLastName = "Berg"
OR CustLastName = "Hallmark")
ORDER BY EntertainerID;

# Question 2
# What is the average salary of a booking agent?

SELECT ROUND(AVG(Salary), 2) AS AveSalary
FROM EntertainmentAgencyExample.Agents;

# Question 3
# Display the engagement numbers for all engagements that have a contract price greater than or equal to 
# the overall average contract price.

SELECT EngagementNumber, ContractPrice
FROM EntertainmentAgencyExample.Engagements
WHERE ContractPrice >= (SELECT AVG(ContractPrice)
FROM EntertainmentAgencyExample.Engagements)
ORDER BY ContractPrice;

# Question 4
# How many of our entertainers are based in Bellevue?

SELECT COUNT(EntertainerID) AS NumberOfEntertainers
FROM EntertainmentAgencyExample.Entertainers
WHERE EntCity = "Bellevue";

# Question 5
# Display which engagements occur earliest in October 2017.

SELECT EngagementNumber, StartDate
FROM EntertainmentAgencyExample.Engagements
WHERE StartDate = (SELECT MIN(StartDate)
FROM EntertainmentAgencyExample.Engagements
WHERE StartDate BETWEEN "2017-10-01" AND "2017-10-31")
ORDER BY StartDate;

# Question 6
# Display all entertainers and the count of each entertainer's engagements.

SELECT EntertainerID, EntStageName, (SELECT COUNT(EntertainerID)
FROM EntertainmentAgencyExample.Engagements
WHERE Engagements.EntertainerID = Entertainers.EntertainerID) AS NumberOfEngagements
FROM EntertainmentAgencyExample.Entertainers;

# Question 7
# List customers who have booked entertainers who play country or country rock. Use subqueries 
# (including JOINS if applicable).

SELECT DISTINCT CustomerID, CONCAT(CustFirstName," ",CustLastName) AS CustomerName
FROM EntertainmentAgencyExample.Customers
JOIN EntertainmentAgencyExample.Engagements USING (CustomerID)
WHERE EntertainerID IN (SELECT EntertainerID
FROM EntertainmentAgencyExample.Entertainer_Styles
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID)
WHERE StyleName = "Country"
OR Stylename = "Country Rock"); 

# Question 8
# Rewrite 7 using ONLY joins and no subqueries.

SELECT DISTINCT CustomerID
FROM EntertainmentAgencyExample.Entertainer_Styles
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
JOIN EntertainmentAgencyExample.Engagements USING (EntertainerID)
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID)
WHERE StyleName = "Country"
OR StyleName = "Country Rock"
ORDER BY CustomerID;

# Question 9
# Find the entertainers who played engagements for customers Berg or Hallmark. Use subqueries (and JOINs). 
# There is only one query to write.

SELECT DISTINCT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.entertainers
JOIN EntertainmentAgencyExample.engagements USING (EntertainerID)
WHERE CustomerID IN (SELECT CustomerID
FROM EntertainmentAgencyExample.Customers
WHERE CustLastName = "Berg"
OR CustLastName = "Hallmark")
ORDER BY EntertainerID;

# Question 10
# Repeat 9. No subquerires but only joins.

SELECT DISTINCT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
WHERE CustLastName = "Berg"
OR CustLastName = "Hallmark"
ORDER BY EntertainerID;

# Question 11
# Display agents who haven't booked an entertainer. Answer in two different ways both ways using subqueiries. So, in all, you will write two different queries (each using subqueries) showing the same result set.

# 11a.
SELECT AgentID, CONCAT(AgtFirstName, " ", AgtLastName) As AgentName
FROM EntertainmentAgencyExample.Agents
WHERE NOT EXISTS (SELECT Engagements.AgentID
FROM EntertainmentAgencyExample.Engagements
WHERE Engagements.AgentID = Agents.AgentID);

# 11b.
SELECT AgentID, CONCAT(AgtFirstName, " ", AgtLastName) As AgentName
FROM EntertainmentAgencyExample.Agents
WHERE Agents.AgentID <> ALL (SELECT Engagements.AgentID
FROM EntertainmentAgencyExample.Engagements);

# Quesiton 12
# Repeat 11 using ONLY joins and no subqueries.

SELECT Agents.AgentID, CONCAT(AgtFirstName, " ", AgtLastName) As AgentName
FROM EntertainmentAgencyExample.Agents
LEFT JOIN EntertainmentAgencyExample.Engagements
ON Agents.AgentID = Engagements.AgentID
WHERE Engagements.AgentID IS NULL;

# Question 13
# Display all customers and the date of the last booking each made. Use subqueries.

SELECT CustomerID, CONCAT(CustFirstName, ' ', CustLastName), (SELECT MAX(StartDate)
FROM EntertainmentAgencyExample.Engagements
WHERE Engagements.CustomerID = Customers.CustomerID) AS MostRecentBooking
FROM EntertainmentAgencyExample.Customers;
# NOTE: I chose to include nulls.

# Question 14
# List the entertainers who played engagements for customer Berg. Write the query
# in two different ways using subqueries. So, in all, you will write two different
# queries (each using subqueries) returning the same result set.

#14a
SELECT DISTINCT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.entertainers
JOIN entertainmentAgencyExample.engagements USING (EntertainerID)
WHERE engagements.customerID = ANY (SELECT customers.CustomerID
FROM entertainmentAgencyExample.Customers
WHERE CustLastName = "Berg")
ORDER BY EntertainerID;

#14b.
SELECT DISTINCT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.entertainers
JOIN EntertainmentAgencyExample.engagements USING (EntertainerID)
WHERE CustomerID IN (SELECT CustomerID
FROM EntertainmentAgencyExample.Customers
WHERE CustLastName = "Berg")
ORDER BY EntertainerID;

# Question 15
# Rewrite Question 14 using only JOINs (and no subqueries)

SELECT DISTINCT Engagements.EntertainerID AS EntertainerID, EntStageName, CustLastName
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
WHERE CustLastName = "Berg"
ORDER BY EntertainerID;

# Question 16
# Using a subquery, list the engagement number and contract price of all engagements that
# have a contract price larger than the total amount of all contract prices for the entire month
# of November 2017.

SELECT EngagementNumber, ContractPrice
FROM EntertainmentAgencyExample.Engagements
WHERE ContractPrice > (SELECT SUM(ContractPrice)
FROM EntertainmentAgencyExample.Engagements
WHERE StartDate BETWEEN "2017-11-01" AND "2017-11-30");

# Question 17
# Using a subquery, list the engagement number and contract price of contracts that occur
# on the earliest date.

SELECT EngagementNumber, ContractPrice, StartDate
FROM EntertainmentAgencyExample.Engagements
WHERE StartDate = (SELECT MIN(StartDate)
FROM EntertainmentAgencyExample.Engagements);

# Question 18
# What was the total value of all engagements booked in October 2017?

SELECT SUM(ContractPrice) As TotalValue
FROM EntertainmentAgencyExample.Engagements
WHERE StartDate BETWEEN "2017-10-01" AND "2017-10-31";

# Question 19
# List customers with no engagement bookings. Use only JOINs and NOT subqueries.

SELECT Customers.CustomerID, CONCAT (CustFirstName, " ", CustLastName) AS CustomerName
FROM EntertainmentAgencyExample.Customers
LEFT JOIN EntertainmentAgencyExample.Engagements
ON Customers.CustomerID = Engagements.CustomerID
WHERE EngagementNumber IS NULL;

# Question 20
# Repeat number 19. Write the query in two different ways returning the same result set.
# Each way will use a subquery.

#20a
SELECT Customers.CustomerID, CONCAT (CustFirstName, " ", CustLastName) AS CustomerName
FROM EntertainmentAgencyExample.Customers
WHERE CustomerID NOT IN (SELECT CustomerID
FROM EntertainmentAgencyExample.Engagements);

#20b
SELECT Customers.CustomerID, CONCAT (CustFirstName, " ", CustLastName) AS CustomerName
FROM EntertainmentAgencyExample.Customers
WHERE NOT EXISTS (SELECT *
FROM EntertainmentAgencyExample.Engagements
WHERE Engagements.CustomerID = Customers.CustomerID);

# Question 21
# For each city where our entertainers live, display how many different musical styles are represented.
# Display using subtotals and grand totals.

SELECT IF(GROUPING(Entertainers.EntCity), "GrandTotal", Entertainers.EntCity) AS EntertainerCity,
IF(GROUPING(Entertainer_Styles.StyleID),"TotalStylesCount",Entertainer_Styles.StyleID) AS StyleID,
COUNT(Entertainer_Styles.StyleID) AS CountOfStyles
FROM EntertainmentAgencyExample.Entertainers
JOIN EntertainmentAgencyExample.Entertainer_Styles USING (EntertainerID)
GROUP BY EntCity, StyleID WITH ROLLUP;

# Question 22
# Which agents booked more than $3,000 worth of business in December 2017?

SELECT Agents.AgentID, CONCAT (AgtFirstName, " ", AgtLastName) AS AgentName
FROM EntertainmentAgencyExample.Agents
WHERE 3000.00 < (SELECT SUM(Engagements.ContractPrice)
FROM EntertainmentAgencyExample.Engagements
WHERE Engagements.AgentID = Agents.AgentID
AND StartDate BETWEEN "2017-12-01" AND "2017-12-31");

# Question 23
# Which Display the entertainers who have more than two overlapped bookings.

SELECT ENT1.EntertainerID AS EntertainerID
FROM EntertainmentAgencyExample.Engagements ENT1
INNER JOIN EntertainmentAgencyExample.Engagements ENT2
ON ENT1.StartDate BETWEEN ENT2.StartDate AND ENT2.EndDate
WHERE ENT1.EntertainerID = ENT2.EntertainerID
AND ENT1.EngagementNumber > ENT2.EngagementNumber
ORDER BY ENT1.EntertainerID;
# PER THE PROFESSOR, THERE SHOULD BE 1 ANSWER. TECHNICALLY, HOWEVER, THE QUESTION
# AS CURRENTLY WRITTEN PRODUCES 0 RESULTS AS NO MUSICIAN HAS *MORE* THAN 2 OVERLAPS.
# I HAVE WRITTEN AS ADVISED BY PROFESSOR.

# Question 24
# Show each agent's name, the sum of the contract price for the engagements
# booked, and the agent's total commission for agents whose total commision is more than $1,000.

SELECT AgentID, CONCAT(AgtFirstName, " ",AgtLastName) AS AgentName, SUM(ContractPrice) AS ContractPriceTotal,
ROUND(SUM(ContractPrice*CommissionRate), 2) AS CommissionTotal
FROM EntertainmentAgencyExample.Agents
JOIN EntertainmentAgencyExample.Engagements USING (AgentID)
GROUP BY AgentID
HAVING SUM(CommissionRate*ContractPrice) > 1000.00;

# Question 25
# Display agents who have never booked a Country or Country Rock group.

SELECT DISTINCT Agents.AgentID, CONCAT(AgtFirstName,' ', AgtLastName) AS AgentName
FROM EntertainmentAgencyExample.Engagements
RIGHT JOIN EntertainmentAgencyExample.Agents
ON Engagements.AgentID = Agents.AgentID
WHERE Agents.AgentID NOT IN (
SELECT DISTINCT Engagements.AgentID
FROM EntertainmentAgencyExample.Entertainer_Styles
JOIN EntertainmentAgencyExample.Engagements USING (EntertainerID)
WHERE EntertainerID = ANY
(SELECT DISTINCT EntertainerID
FROM EntertainmentAgencyExample.Entertainer_Styles
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID)
WHERE StyleName = "Country"
OR StyleName = "Country Rock"));

# Question 26
# Display the entertainers who did not have a booking in the 90 days preceeding May 1, 2018.

SELECT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.Entertainers
WHERE EntertainerID <> ALL (SELECT EntertainerID
FROM EntertainmentAgencyExample.Engagements
WHERE StartDate BETWEEN DATE_SUB("2018-05-01", INTERVAL 90 DAY) AND "2018-05-01");

# Question 27
# List the entertainers who play the Jazz, Rhythm and Blues, and Salsa styles.
# Answer this question using two queries - one with subqueries (with or without
# joins) and another using only JOINs. In sum, two queries returning the same results.

#27a
SELECT DISTINCT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.Entertainers
JOIN EntertainmentAgencyExample.Entertainer_Styles USING (EntertainerID)
WHERE Entertainer_Styles.StyleID = ANY (SELECT StyleID
FROM EntertainmentAgencyExample.Musical_Styles
WHERE StyleName = "Jazz"
OR StyleName = "Rhythm and Blues"
OR StyleName = "Salsa");

#27B
SELECT DISTINCT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.Entertainer_Styles
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID)
WHERE StyleName = "Jazz"
OR StyleName = "Rhythm and Blues"
OR StyleName = "Salsa";

# Question 28
# List the customers who have booked Carol Peacock Trio, Caroline Coie Cuartet, and
# Jazz Persuasion. Write this query in three ways - each way uses subqueries of some sort.
# all returning the same resultset. In all, you will write 3 different queries, each one
# returning the same result set.

#28a
SELECT DISTINCT CustomerID, CONCAT(CustFirstName," ", CustLastName) AS CustomerName
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
WHERE Engagements.CustomerID = ANY (SELECT CustomerID
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
WHERE EntStageName = "Carol Peacock Trio")
AND Engagements.CustomerID = ANY (SELECT CustomerID
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
WHERE EntStageName = "Caroline Coie Cuartet")
AND Engagements.CustomerID = ANY (SELECT CustomerID
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
WHERE EntStageName = "Jazz Persuasion");

#28b
SELECT DISTINCT CustomerID, CONCAT(CustFirstName," ", CustLastName) AS CustomerName
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
WHERE Engagements.CustomerID IN (SELECT CustomerID
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
WHERE EntStageName = "Carol Peacock Trio")
AND Engagements.CustomerID IN (SELECT CustomerID
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
WHERE EntStageName = "Caroline Coie Cuartet")
AND Engagements.CustomerID IN (SELECT CustomerID
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Entertainers USING (EntertainerID)
WHERE EntStageName = "Jazz Persuasion");

#28c
SELECT DISTINCT CustomerID, CONCAT(CustFirstName," ", CustLastName) AS CustomerName
FROM EntertainmentAgencyExample.Engagements
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
WHERE EntertainerID = (SELECT EntertainerID
FROM EntertainmentAgencyExample.Entertainers
WHERE EntStageName = "Jazz Persuasion")
OR EntertainerID = (SELECT EntertainerID
FROM EntertainmentAgencyExample.Entertainers
WHERE EntStageName = "Caroline Coie Cuartet")
OR EntertainerID = (SELECT EntertainerID
FROM EntertainmentAgencyExample.Entertainers
WHERE EntStageName = "Carol Peacock Trio")
GROUP BY CustomerID
HAVING COUNT(DISTINCT EntertainerID) = 3;


# Question 29
# Display customers and groups where the musical styles of the group match all
# of the musical styles preferred by the customer.

SELECT StyleName, EntertainerID, CustomerID
FROM EntertainmentAgencyExample.Entertainer_Styles
JOIN EntertainmentAgencyExample.Musical_Styles ON
Entertainer_Styles.StyleID = Musical_Styles.StyleID
JOIN EntertainmentAgencyExample.Musical_Preferences
ON Entertainer_Styles.StyleID = Musical_Preferences.StyleID
ORDER BY StyleName;
# PER PROFESSOR, "GROUPS" IN QUESTION IS REFERRING TO ENTERTAINERS.
# IE QUESTION: Display customers and entertainers where the musical styles of the entertainers match all
# of the musical styles preferred by the customer.
 

# Question 30
# Display the entertainer groups that play in a jazz style and have more than 3 members.

SELECT EntertainerID, EntStageName
FROM EntertainmentAgencyExample.Entertainers
JOIN EntertainmentAgencyExample.Entertainer_Styles USING (EntertainerID)
WHERE 3 < (SELECT COUNT(EntertainerID)
FROM EntertainmentAgencyExample.Entertainer_Members
WHERE Entertainer_Members.EntertainerID = Entertainers.EntertainerID)
AND EXISTS (SELECT *
FROM EntertainmentAgencyExample.Musical_Styles
WHERE Musical_Styles.StyleID = Entertainer_Styles.StyleID
AND StyleName = "Jazz");

# ACCOUNTS PAYABLE DATABASE

# Question 1
# Display the count of unpaid invoices and the total due.

SELECT COUNT(Invoice_ID) AS NumberUnpaidInvoices, SUM(Invoice_Total - Credit_Total) AS TotalDue
FROM accountspayable.Invoices
WHERE Payment_Total = 0.00;
# I AM ASSUMING THAT TotalDue is Invoice Total - Credits. Thought I ran it both ways and it doesn't affect
# the results.

# Question 2
# Display the invoice details for each vendor in CA. Use JOINs and not subqueries

SELECT invoices.*
FROM accountspayable.invoices
JOIN accountspayable.vendors USING (Vendor_ID)
WHERE Vendor_State = "CA";

# Question 3
# Repeat question 2 using subqueries.

SELECT invoices.*
FROM accountspayable.invoices
WHERE Vendor_ID = ANY (SELECT Vendor_ID
FROM accountspayable.vendors
WHERE Vendor_State = "CA");

# Question 4
# List vendor information for all vendors without invoices. Use JOINs and no subqueries.

SELECT DISTINCT Vendors.Vendor_ID, Vendor_Name
FROM accountspayable.Vendors
LEFT JOIN accountspayable.Invoices
ON vendors.Vendor_ID = invoices.Vendor_ID
WHERE invoices.Vendor_ID IS NULL
ORDER BY Vendor_ID;

# Question 5
# Repeat 4 using 2 different subqueries returning the same result set. So, in all, you
# will write 2 different queries here - each using a different subquery.

#5a
SELECT Vendor_ID, Vendor_Name
FROM accountspayable.Vendors
WHERE Vendor_ID <> ALL (SELECT Vendor_ID
FROM accountspayable.Invoices)
ORDER BY Vendor_ID;

#5b
SELECT Vendor_ID, Vendor_Name
FROM accountspayable.Vendors
WHERE NOT EXISTS (SELECT *
FROM accountspayable.Invoices
WHERE invoices.Vendor_ID = vendors.Vendor_ID)
ORDER BY Vendor_ID;

# Question 6
# List invoice information for invoices with a balance due less than average. Use subqueries.

SELECT Invoice_ID, Vendor_ID, Invoice_Number, Invoice_Total
FROM accountspayable.Invoices
WHERE Invoice_Total < (SELECT AVG(Invoice_Total)
FROM accountspayable.Invoices);

# Question 7
# List vendor name, invoice number, and invoice total for invoices larger than the largest invoice
# for vendor 34. Write two different subqueries yielding the same result set. So in all, you
# should have 2 separate queries each returning the same result set.

#7a
SELECT Vendor_Name, Invoice_Number, Invoice_Total
FROM accountspayable.Invoices
JOIN accountspayable.Vendors USING (Vendor_ID)
WHERE Invoice_Total > (SELECT MAX(Invoice_Total)
FROM accountspayable.Invoices
WHERE Vendor_ID = 34);

#7b
SELECT (SELECT Vendor_Name
FROM accountspayable.Vendors
WHERE Vendors.Vendor_ID = Invoices.Vendor_ID) AS Vendor_Name, Invoice_Number, Invoice_Total
FROM accountspayable.Invoices
WHERE Invoice_Total > (SELECT MAX(Invoice_Total)
FROM accountspayable.Invoices
WHERE Vendor_ID = 34);

# Question 8
# List vendor name, invoice number, and invoice total for invoices smaller than the largest
# invoice for vendor 115. Use subqueries in two different ways. So in all there will be
# two different subqueries generating the same result set.

#8a
SELECT (SELECT Vendor_Name
FROM accountspayable.Vendors
WHERE Vendors.Vendor_ID = Invoices.Vendor_ID) AS Vendor_Name, Invoice_Number, Invoice_Total
FROM accountspayable.Invoices
WHERE Invoice_Total < (SELECT MAX(Invoice_Total)
FROM accountspayable.Invoices
WHERE Vendor_ID = 115);

#8b
SELECT Vendor_Name, Invoice_Number, Invoice_Total
FROM accountspayable.Invoices
JOIN accountspayable.Vendors USING (Vendor_ID)
WHERE Invoice_Total < (SELECT MAX(Invoice_Total)
FROM accountspayable.Invoices
WHERE Vendor_ID = 115);

# Question 9
# Get the most recent invoice for each vendor. The query should return vendor name
# and the lastest invoice date in the result set. Use a subquery without JOINs.

SELECT Vendor_ID, Vendor_Name, (SELECT MAX(Invoice_Date)
FROM accountspayable.Invoices
WHERE invoices.Vendor_ID = vendors.Vendor_ID) AS MostRecentInvoiceDate
FROM accountspayable.Vendors
WHERE 1 <= (SELECT COUNT(Invoice_Date)
FROM accountspayable.Invoices
WHERE invoices.Vendor_ID = vendors.Vendor_ID)
ORDER BY MostRecentInvoiceDate DESC;


# Question 10
# Repeat question 9. Use JOINs and no subqueries.

SELECT Vendor_ID, Vendor_Name, MAX(Invoice_Date) AS MostRecentInvoiceDate
FROM accountspayable.Vendors
JOIN accountspayable.Invoices USING (Vendor_ID)
GROUP BY Vendor_ID;

# Question 11
# Get each invoice amount that is higher than the vendor's average invoice amount.

SELECT Vendor_ID, Invoice_Number, Invoice_Total
FROM accountspayable.Invoices A
WHERE Invoice_Total > (SELECT AVG(Invoice_Total)
FROM accountspayable.Invoices B
WHERE B.Vendor_ID = A.Vendor_ID)
ORDER BY Vendor_ID;

# Question 12
# Get the largest invoice total for the top vendor in each state.

SELECT Vendor_State, MAX(Invoice_Total) AS MaxInvoice
FROM accountspayable.Vendors
JOIN accountspayable.Invoices USING (Vendor_ID)
GROUP BY Vendor_State
ORDER BY VEndor_State;
# PER PROFESSOR, "top vendor" is based on MAX invoice.

# Question 13
# Display the GL account description, the number of line items are in each GL account,
# and the line item amount for accounts which have more than 1 line item.

SELECT Account_Description, (SELECT COUNT(Account_Number)
FROM accountspayable.Invoice_Line_Items
WHERE Invoice_Line_Items.Account_Number = General_Ledger_Accounts.Account_Number) AS NumberOfLineItems,
(SELECT SUM(Line_Item_Amount)
FROM accountspayable.Invoice_Line_Items
WHERE Invoice_Line_Items.Account_Number = General_Ledger_Accounts.Account_Number) AS LineItemAmount
FROM accountspayable.General_Ledger_Accounts
WHERE 1 < (SELECT COUNT(Account_Number)
FROM accountspayable.Invoice_Line_Items
WHERE Invoice_Line_Items.Account_Number = General_Ledger_Accounts.Account_Number);

# Question 14
# What is the total amount invoiced for each GL account number. Display the grand total as well.

SELECT IF(GROUPING (Account_Number),'GrandTotal',(Account_Number)) AS GLAccountNumber,
SUM(Invoice_Total) AS TotalInvoiced
FROM accountspayable.invoices
JOIN accountspayable.invoice_line_items USING (Invoice_ID)
GROUP BY Account_Number WITH ROLLUP;
#NOTE: THere is a descrepancy between invoices.invoice_total and invoice_line_items.sum(line_item_amount) within invoices.
# hypothetically these two items should sum to be the same. I am assuming sum(line_item_amount) is most accurate for this question.

# Question 15
# Which vendors are being paid from more than one account?

SELECT Vendor_ID, Vendor_Name, COUNT(account_number) AS NumberOfAccountsPaidFrom
FROM accountspayable.invoices
JOIN accountspayable.vendors USING (Vendor_ID)
JOIN accountspayable.Invoice_Line_Items USING (Invoice_ID)
GROUP BY Vendor_ID
HAVING COUNT(account_number) > 1
ORDER BY NumberOfAccountsPaidFrom DESC;

# Question 16
# What are the last payment date and the total amount due for each vendor with each
# terms ID. Show the subtotal and grand total of each terms ID level.
SELECT IF(GROUPING (Default_Terms_ID), 'GrandTotal', Default_Terms_ID) AS TotalforTerms,
IF(GROUPING (Vendor_ID),'TotalVendors',Vendor_ID) AS VendorID, MAX(Payment_Date) AS LastPayment,
SUM(Invoice_Total - Credit_Total - Payment_Total) AS TotalDue
FROM accountspayable.vendors
JOIN accountspayable.Invoices USING (Vendor_ID)
GROUP BY Default_Terms_ID, Vendor_ID WITH ROLLUP;