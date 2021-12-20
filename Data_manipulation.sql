# ENTERTAINMENT AGENCY DATABASE

# Question 1
# Display customers and their preferred styles, but change 50s, 60s, 70s, and 80s music
# to "Oldies." This query should return 36 rows.

SELECT CONCAT(CustFirstName, " ", CustLastName) AS CustomerName, CASE StyleName
WHEN "50's Music" THEN "Oldies"
WHEN "60's Music" THEN "Oldies"
WHEN "70's Music" THEN "Oldies"
WHEN "80's Music" THEN "Oldies"
ELSE StyleName END AS StyleName
FROM EntertainmentAgencyExample.Musical_Preferences
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
JOIN EntertainmentAgencyExample.Musical_Styles USING (StyleID);

# Question 2
# Display all the engagements in October 2017 that start between noon and 5PM. Note:
# This database already has fields using the correct datatypes (date and time). Assume
# the dates and times were stored as strings. Write this query under such an assumption.
# This query should return 17 rows.

SELECT EngagementNumber, StartDate, StartTime
FROM EntertainmentAgencyExample.Engagements
WHERE StartDate BETWEEN CAST("2017-10-01" AS DATETIME)
AND CAST("2017-10-31" AS DATETIME)
AND StartTime BETWEEN CAST("12:00:00" AS TIME) AND CAST("17:00:00" AS TIME);
 
# Question 3
# List Entertainers and display whether the entertainer was booked (on the job) on Christmas 2017
# (December 25th). For this, you have to display 3 columns - EntertainerID, EntertainerStageName,
# and a new column indicating if the engagement was booked on Christmas or not. The query
# should return 13 rows.

SELECT DISTINCT EntertainerID, EntStageName, IF(EntertainerID = ANY
(SELECT EntertainerID
FROM EntertainmentAgencyExample.Engagements
WHERE StartDate = "2017-12-25"),"OnTheJob","ChistmasOff") AS ChistmasBooking
FROM EntertainmentAgencyExample.Entertainers;

# Question 4
# Find customer who like Jazz but not Standards. THe query should return 2 rows.

SELECT CONCAT(CustFirstName, " ", CustLastName) AS CustomerName
FROM EntertainmentAgencyExample.Musical_Preferences
JOIN EntertainmentAgencyExample.Customers USING (CustomerID)
WHERE StyleID = (SELECT DISTINCT StyleID
FROM EntertainmentAgencyExample.Musical_Styles
WHERE StyleName = "Jazz")
AND CustomerID NOT IN (SELECT CustomerID
FROM EntertainmentAgencyExample.Musical_Styles
JOIN EntertainmentAgencyExample.Musical_Preferences USING (StyleID)
WHERE StyleName = "Standards");

# ACCOUNTS PAYABLE DATABASE

# Question 1
# Display the invoice totals from the invoices column and display all the invoice totals with a $ sign.

SELECT CONCAT("$", Invoice_Total) AS InvoiceTotal
FROM accountspayable.invoices;

# Question 2
# Write a query to convert invoice date to a date in a character format and invoice total in integer
# format. Both conversions should be performed in the same query. Please note, the integer
# have no decimals.

SELECT CAST(Invoice_Date AS CHAR) AS InvoiceDate, CAST(Invoice_Total AS UNSIGNED) AS InvoiceTotal
FROM accountspayable.Invoices;

# Question 3
# In the Invoices table, pad the single-digit and double-digit invoice numbers with 1 or 2 zeros
# before the invoice numbers. For example, invoice number 1 should be displayed as 001, invoice
# number 20 should be dispalyed as 020, etc.

SELECT CASE WHEN (LENGTH(Invoice_ID) = 1) THEN CONCAT("00",Invoice_ID)
WHEN (LENGTH(Invoice_ID) = 2) THEN CONCAT ("0",Invoice_ID)
ELSE Invoice_ID END AS InvoiceID
FROM accountspayable.Invoices
ORDER BY Invoice_ID;

# Question 4
# Write a query to return the invoice_total column with one decimal digit and the invoice_total
# column with no decimal digits.

SELECT CAST(A.Invoice_Total AS DECIMAL(7,1)) AS InvoiceTotal_Format1, 
CAST(B.Invoice_Total AS UNSIGNED) AS InvoiceTotal_Format2
FROM accountspayable.Invoices A
JOIN accountspayable.Invoices B
ON A.Invoice_ID = B.Invoice_ID;

# Question 5
# Create a new table named Date_Sample using the script given below. Download this script
# from Canvas and run it in your MySQL Workbench on the ap database. Running this will
# create the Date_Sample table in your ap database.
# Display the start_date column, a new date column - call it Format_1 which displays date
# in this format: Mar/01/86, a new date column - call it Format_2 which displays 3/1/86
# where the month and days are returned as integers with no leading 0s, and a third
# date column - call it Format_3 which displays only ours and minutes on a 12-hour clock
# with an am/pm indicator, for example: 12:00PM.

SELECT start_date, 
DATE_FORMAT(start_date, '%b/%d/%y') AS Format_1, 
DATE_FORMAT(start_date, '%c/%e/%y') AS Format_2, 
DATE_FORMAT(start_date, '%l:%i %p') AS Format_3
FROM accountspayable.date_sample;

# Question 6
# Write a query that returns the following columns from the Vendors table:
# Vendor_name column, Vendor_Name column in all caps, vendor_phone,
# last 4 digits of the vendor's phone number.
# When you get that working right, add the columns that follow to ththe result set. These
# require nested funtions.
# The vendor_phone column with the parts ofthe number separated by dots as in 111.111.1111
# And A column that displays the second word in each vendor name if there is one and blanks if there isn't.

SELECT Vendor_Name, UPPER(Vendor_Name) AS Vendor_NameCAPS, Vendor_Phone, RIGHT(Vendor_Phone, 4) AS LastFourPhone,
CONCAT(SUBSTR(Vendor_Phone,2,3),".",SUBSTR(Vendor_Phone,POSITION(" " IN Vendor_Phone)+1,3),
".",RIGHT(Vendor_Phone,4)) AS PhoneWDots,
CASE WHEN (  length(Vendor_Name) - length(replace(Vendor_Name, ' ', ''))>1) THEN
SUBSTRING_INDEX(SUBSTRING_INDEX(Vendor_Name, ' ', 2), ' ', -1) ELSE " " END AS SecondWordVendor
FROM accountspayable.vendors;

# Question 7
# Write a query that returns these columns from the Invoices table:
# The invoice_number column, the invoice_date column, the invoice_date column plus 30 days,
# the payment_date column, A column named days_to_pay that shows the number of days between
# the invoice date and the payment date, the number of invoice date's month, the 4 digit year of invoice date.
# When you have this working, add a WHERE clause that retrieves just the invoices for the month of May
# based on the invoice date, and not the number of the invoice month.

SELECT Invoice_Number, Invoice_Date, DATE_ADD(Invoice_Date, INTERVAL 30 DAY) AS Invoice_Date_Add30, Payment_Date,
(Payment_Date-Invoice_Date) AS Days_to_Pay, EXTRACT(MONTH FROM Invoice_Date) AS Month,
EXTRACT(YEAR FROM Invoice_Date) AS Year
FROM  accountspayable.Invoices
WHERE Invoice_Date BETWEEN "2014-05-01" AND "2014-05-31";
              
# Question 8
# Create a new table named string_sample using the script given below. Download this script
# from Canvas and run it in your MySql Workbench on the ap database. Running this will create
# the string_sample table in your ap database.
# Write a query that returns these columns from the string_sample table you created with
# the above script: emp_name column, a column that displays each employee's first name
# a column that displays each employee's last name.
# Use regular expression functions to get the first and last name. If a name contains three
# parts, everything after the first part should be considered part of the last name. Be sure to
# provide for last names with hyphens and apostrophes.

SELECT Emp_Name, regexp_substr(Emp_Name, '^[[:alpha:]]+') as FirstName, 
regexp_replace(Emp_Name, '^[[:alpha:]]+ ', '') as LastName
FROM accountspayable.String_Sample;
