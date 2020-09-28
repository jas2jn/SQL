/*DML Examples using tables instantiated in DDL script */

/* Show an entire table  */
SELECT * FROM A;

/* Show all information from table S for 1 coffee shop   */
SELECT * FROM S WHERE BRAND = ‘JoesJoe’;

/*  Show average price of all hot drinks in the drink table rounded to 2 decimals  */
SELECT ROUND(AVG(PRICE),2) FROM D WHERE TEMP = ‘Hot’;

/*   Show total quantity of bags sold for each bean currently sold by shops in the SB table */
SELECT BID,SUM(BAGSSOLD) FROM SB GROUP BY BID;

/*  Show the average bean sales across all stores currently selling beans  */
SELECT ROUND(AVG(TotalSales)) FROM (SELECT SID, SUM(BAGPRICE * BAGSSOLD) AS TotalSales FROM SB NATURAL JOIN B GROUP BY SID) AS RES;

/* Provide a list of all employee IDs, first names and last names for employees who are part time, living in Richmond along with employees who are full time living in Charlottesville   */
SELECT EID,FNAME,LNAME FROM E WHERE CITY = ‘Richmond’ AND ETYPE = ‘Part’ UNION SELECT EID, FNAME, LNAME FROM E WHERE CITY = ‘Charlottesville’ AND ETYPE = ‘Full’;

/*  Show which shops have sold more than 300 bags of beans and also sell the BID B2  */
SELECT SID FROM S WHERE SID IN (SELECT SID FROM SB GROUP BY SID HAVING SUM(BAGSSOLD) > 300) AND SID IN (SELECT SID FROM SB WHERE BID = ‘B2’);

/*Show every shop’s ID and the number of different bean IDs sold. If there are no bean IDs, show a 0 instead of NULL*/
SELECT SID,COALESCE(COUNT(DISTINCT BID), 0) AS 'Number of Different BIDS' FROM S NATURAL LEFT JOIN SB GROUP BY SID;

/*For any month that features at least one employee birthday, show the number of employees born in those months in descending order relative to the number of employees born in each month (i.e. October/July should be near the top in the result with 2 birthdays each) */
SELECT MONTHNAME(BDATE),COUNT(MONTHNAME(BDATE)) FROM E GROUP BY MONTHNAME(BDATE) ORDER BY COUNT(MONTHNAME(BDATE)) DESC;

/* Show the number of employees whose last names starts with the letter P (e.g. Porter) */
SELECT COUNT(LNAME) FROM E WHERE LNAME LIKE 'P%';

/* Show the average hourly wage (i.e. HRWAGE) rounded to two decimals split up relative to employee type and location */
SELECT ETYPE,LOC,ROUND(AVG(HRWAGE), 2) FROM E GROUP BY ETYPE,LOC;

/* Show the EID, first name and last name for each employee who currently manages other employees, along with the number of employees they manage */
SELECT M.EID,M.FNAME,M.LNAME,COUNT(E.EID) FROM E AS M JOIN E AS E ON E.MANAGER = M.EID GROUP BY E.MANAGER;