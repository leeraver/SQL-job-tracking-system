-- --------------------------------------------------------------------------------
-- Name: Lee Raver
-- Class: Database Design and SQL 1 (111-401)
-- Abstract: Final Project
-- --------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------
-- Options
-- --------------------------------------------------------------------------------
USE dbSQL1;     -- Get out of the master database
SET NOCOUNT ON; -- Report only errors

-- --------------------------------------------------------------------------------
--						Step #1
-- --------------------------------------------------------------------------------

-- Drop Table Statements

IF OBJECt_ID ('TJobWorkers')			IS NOT NULL DROP TABLE TJobWorkers
IF OBJECt_ID ('TJobMaterials')			IS NOT NULL DROP TABLE TJobMaterials
IF OBJECt_ID ('TJobs')					IS NOT NULL DROP TABLE TJobs
IF OBJECt_ID ('TMaterials')				IS NOT NULL DROP TABLE TMaterials
IF OBJECt_ID ('TVendors')				IS NOT NULL DROP TABLE TVendors
IF OBJECt_ID ('TWorkerSkills')			IS NOT NULL DROP TABLE TWorkerSkills
IF OBJECt_ID ('TWorkers')				IS NOT NULL DROP TABLE TWorkers
IF OBJECt_ID ('TCustomers')				IS NOT NULL DROP TABLE TCustomers
IF OBJECt_ID ('TSkills')				IS NOT NULL DROP TABLE TSkills
IF OBJECt_ID ('TStatuses')				IS NOT NULL DROP TABLE TStatuses
IF OBJECt_ID ('TState')					IS NOT NULL DROP TABLE TState


-- --------------------------------------------------------------------------------
--	Step #1.1 : Create table 
-- --------------------------------------------------------------------------------

CREATE TABLE TState
(
	 intStateID			INTEGER				NOT NULL
	,strState			VARCHAR(255)		NOT NULL
	,CONSTRAINT TState_PK PRIMARY KEY ( intStateID )
)

CREATE TABLE TStatuses
(
	 intStatusID						INTEGER				NOT NULL
	,strStatus							VARCHAR(255)		NOT NULL
	,CONSTRAINT TStatuses_PK			PRIMARY KEY ( intStatusID )
)

CREATE TABLE TSkills
(
	 intSkillID							INTEGER				NOT NULL
	,strSkill							VARCHAR(255)		NOT NULL
	,strDescription						VARCHAR(255)		NOT NULL
	,CONSTRAINT TSkills_PK				PRIMARY KEY ( intSkillID )
)

CREATE TABLE TCustomers
(
	  intCustomerID						INTEGER				NOT NULL
	 ,strFirstName						VARCHAR(255)		NOT NULL
	 ,strLastName						VARCHAR(255)		NOT NULL
	 ,strAddress						VARCHAR(255)		NOT NULL
	 ,strCity							VARCHAR(255)		NOT NULL
	 ,intStateID						INTEGER				NOT NULL
	 ,strZip							VARCHAR(255)		NOT NULL
	 ,strPhoneNumber					VARCHAR(255)		NOT NULL
	 ,strEmail							VARCHAR(255)		NOT NULL
	 ,CONSTRAINT TCustomer_PK			PRIMARY KEY ( intCustomerID )
)

CREATE TABLE TWorkers
(
	 intWorkerID						INTEGER				NOT NULL
	 ,strFirstName						VARCHAR(255)		NOT NULL
	 ,strLastName						VARCHAR(255)		NOT NULL
	 ,strAddress						VARCHAR(255)		NOT NULL
	 ,strCity							VARCHAR(255)		NOT NULL
	 ,intStateID						INTEGER				NOT NULL
	 ,strZip							VARCHAR(255)		NOT NULL
	 ,strPhoneNumber					VARCHAR(255)		NOT NULL
	 ,strEmail							VARCHAR(255)		NOT NULL
	 ,dtmHireDate						DATETIME2			NOT NULL
	 ,monHourlyRate						SMALLMONEY			NOT NULL
	 ,CONSTRAINT TWorkers_PK			PRIMARY KEY ( intWorkerID )
)

CREATE TABLE TWorkerSkills
(
	 intWorkerSkillID					INTEGER				NOT NULL
	,intWorkerID						INTEGER				NOT NULL
	,intSkillID							INTEGER				NOT NULL
	,CONSTRAINT	TWorkerSkills_PK		PRIMARY KEY ( intWorkerSkillID )
)

CREATE TABLE TVendors
(
	 intVendorID						INTEGER				NOT NULL
	,strVendorName						VARCHAR(255)		NOT NULL
	,strAddress							VARCHAR(255)		NOT NULL
	,strCity							VARCHAR(255)		NOT NULL
	,intStateID							INTEGER				NOT NULL
	,strZip								VARCHAR(255)		NOT NULL
	,strPhoneNumber						VARCHAR(255)		NOT NULL
	,strEmail							VARCHAR(255)		NOT NULL
	,CONSTRAINT TVendors_PK				PRIMARY KEY ( intVendorID )
)

CREATE TABLE TMaterials
(
	 intMaterialID						INTEGER				NOT NULL
	,strDescription						VARCHAR(255)		NOT NULL
	,monCost							MONEY				NOT NULL
	,intVendorID						INTEGER				NOT NULL
	,CONSTRAINT TMaterials_PK			PRIMARY KEY ( intMaterialID )
)

CREATE TABLE TJobs
(
	 intJobID							INTEGER				NOT NULL
	,intCustomerID						INTEGER				NOT NULL
	,intStatusID						INTEGER				NOT NULL
	,dtmStartDate						DATETIME2			NOT NULL
	,dtmEndDate							DATETIME2			NOT NULL  -- For Jobs that haven't ended yet, enter 9999-12-31
	,strJobDesc							VARCHAR(2000)		NOT NULL
	,CONSTRAINT TJobs_PK				PRIMARY KEY ( intJobID )
)

CREATE TABLE TJobMaterials
(
	 intJobMaterialID					INTEGER				NOT NULL
	,intJobID							INTEGER				NOT NULL
	,intMaterialID						INTEGER				NOT NULL
	,intQuantity						INTEGER				NOT NULL
	,CONSTRAINT TCustomerJobMaterials_PK PRIMARY KEY ( intJobMaterialID )
)

CREATE TABLE TJobWorkers
(
	 intJobWorkerID						INTEGER				NOT NULL
	,intJobID							INTEGER				NOT NULL
	,intWorkerID						INTEGER				NOT NULL
	,intHoursWorked						INTEGER				NOT NULL
	,CONSTRAINT TCustomerJobWorkers_PK	PRIMARY KEY ( intJobWorkerID )
)

-- --------------------------------------------------------------------------------
--	Step #1.2 : Create relationships. Foreign Keys
-- --------------------------------------------------------------------------------
--		Child						Parent			Column
--      -----						------			---------
--	1	TCustomers					TState			intStateID
--	2	TWorkers					TState			intStateID
--  3   TVendors					TState			intStateID
--  4   TJobs						TStatuses		intStatusID
--  5   TJobs						TCustomers		intCustomerID
--  6   TMaterials					TVendors		intVendorID
--  7   TJobMaterials				TJobs			intJobID
--  8   TWorkerSkills				TSkills			intSkillID
--  9   TJobMaterials				TMaterials		intMaterialID
--  10  TWorkerSkills				TWorkers		intWorkerID

--ALTER TABLE <Child Table> ADD CONSTRAINT <Child Table>_<Parent Table>_FK1
--FOREIGN KEY ( <Child column> ) REFERENCES <Parent Table> ( <Parent column> )

-- 1
ALTER TABLE TCustomers ADD CONSTRAINT TCustomers_TState_FK1
FOREIGN KEY ( intStateID ) REFERENCES TState ( intStateID )

-- 2
ALTER TABLE TWorkers ADD CONSTRAINT TWorkers_TState_FK1
FOREIGN KEY ( intStateID ) REFERENCES TState ( intStateID )

-- 3
ALTER TABLE TVendors ADD CONSTRAINT TVendors_TState_FK1
FOREIGN KEY ( intStateID ) REFERENCES TState ( intStateID )

-- 4
ALTER TABLE TJobs ADD CONSTRAINT TJobs_TStatuses_FK1
FOREIGN KEY ( intStatusID ) REFERENCES TStatuses ( intStatusID )

-- 5
ALTER TABLE TJobs ADD CONSTRAINT TJobs_TCustomers_FK1
FOREIGN KEY ( intCustomerID ) REFERENCES TCustomers ( intCustomerID )

-- 6
ALTER TABLE TMaterials ADD CONSTRAINT TMaterials_TVendors_FK1
FOREIGN KEY ( intVendorID ) REFERENCES TVendors ( intVendorID )

-- 7
ALTER TABLE TJobMaterials ADD CONSTRAINT TJobMaterials_TJobs_FK1
FOREIGN KEY ( intJobID ) REFERENCES TJobs ( intJobID )

-- 8
ALTER TABLE TWorkerSkills ADD CONSTRAINT TWorkerSkills_TSkills_FK1
FOREIGN KEY ( intSkillID ) REFERENCES TSkills ( intSkillID )

-- 9
ALTER TABLE TJobMaterials ADD CONSTRAINT TJobMaterials_TMaterials_FK1
FOREIGN KEY ( intMaterialID ) REFERENCES TMaterials ( intMaterialID )

-- 10
ALTER TABLE TWorkerSkills ADD CONSTRAINT TWorkerSkills_TWorkers_FK1
FOREIGN KEY ( intWorkerID ) REFERENCES TWorkers ( intWorkerID )

-- --------------------------------------------------------------------------------
--	Step #2 : Add Sample Data - INSERTS
-- --------------------------------------------------------------------------------

INSERT INTO TState ( intStateID, strState)
VALUES				 (1, 'CA')
					,(2, 'ID')
					,(3, 'OH')
					,(4, 'NY')
					,(5, 'IL')
					,(6, 'WV')

INSERT INTO TStatuses ( intStatusID, strStatus)
VALUES				 (1, 'Open')
					,(2, 'In Process')
					,(3, 'Complete')

INSERT INTO TSkills( intSkillID, strSkill, strDescription)
VALUES				 (1, 'Electrical Certification', 'Trained and certified in electrical wiring and safety precautions.')
					,(2, 'HVAC Technician', 'Skilled in repairing and installing central heating and cooling units.')
					,(3, 'Plumber', 'Skilled in repairing and installing pipes and water and drainage solutions.')
					,(4, 'Carpenter', 'Skilled in woodworking of all kinds.')
					,(5, 'Database Designer', 'Skilled in designing normalized databases and creating a physical database.')

INSERT INTO TCustomers( intCustomerID, strFirstName, strLastName, strAddress, strCity, intStateID, strZip, strPhoneNumber, strEmail)
VALUES				 (1, 'Jane', 'Dough', '321 Baker Street', 'Bakersfield', 3, '54321', '0312344556', 'pastries@gmail.com')
					,(2, 'Jim', 'Doe', '456 Deer Street', 'Bakersfield', 3, '54321', '5138889999', 'jdoe@gmail.com')
					,(3, 'Hans', 'Zimmer', '111 Main Street', 'Indian Hill', 3, '45222', '9992223333', 'hans@zimmer.com')
					,(4, 'Sebastian', 'Vettel', '112 Main Street', 'Indian Hill', 3, '45222', '5134441234', 'seb@gmail.com')
					,(5, 'Don', 'Quixote', '127 Main Street', 'Indian Hill', 3, '45222', '5137774444', 'don@aol.com')

INSERT INTO TWorkers( intWorkerID, strFirstName, strLastName, strAddress, strCity, intStateID, strZip, strPhoneNumber, strEmail, dtmHireDate, monHourlyRate)
VALUES				 (1, 'Bob', 'Builder', '1234 Construction Ave', 'Buildhaven', 3, '45211', '5131112222', 'bobthebuilder@bob.com', '2002-06-27', 30.99)
					,(2, 'Mario', 'Nentendo', '123 Mushroom Road', 'Toad Town', 3, '45212', '5131113333', 'mario@plumbing.com', '2022-07-21', 28.99)
					,(3, 'Woody', 'Carver', '444 Sawdust Lane', 'Buildhaven', 3, '45211', '5134445555', 'wcarver@carpentry.com', '2025-03-18', 26.99)
					,(4, 'Billy', 'Willy', '77 Development Ave', 'Buildhaven', 3, '45211', '5134440000', 'billy@willy.org', '2025-08-12', 16.99)

INSERT INTO TWorkerSkills( intWorkerSkillID, intWorkerID, intSkillID)
VALUES				 (1, 1, 1)
					,(2, 1, 2)
					,(3, 2, 3)
					,(4, 3, 4)
					,(5, 1, 3)
					,(6, 1, 4)
					,(7, 1, 5)

INSERT INTO TVendors ( intVendorID, strVendorName, strAddress, strCity, intStateID, strZip, strPhoneNumber, strEmail)
VALUES				 (1, 'Houdinis Grand Emporium', '22 Bazaar Avenue', 'Golftown', 3, '45213', '5139991111', 'billing@houdini.com')
					,(2, 'Bobs Hardware', '21 Bazaar Avenue', 'Buildhaven', 3, '45211', '51377772222', 'accounts@bobshardware.com')
					,(3, 'Big Lumber', '23 Bazaar Avenue', 'Buildhaven', 3, '45211', '5135553333', 'buywood@biglumber.com')

INSERT INTO TMaterials ( intMaterialID, strDescription, monCost, intVendorID)
VALUES				 (1, 'Wood 2x4', 5.00, 1)
					,(2, 'Galvanized Screws 100 pack', 10.00, 1)
					,(3, '3/4 in Copper Pipe 7ft', 36.00, 2)
					,(4, 'Mahogany Slab 10x4 ft', 1260.00, 3)
					,(5, 'Golden Toilet', 10000.00, 1)
					,(6, 'Window', 1000.00, 2)
					,(7, 'Light Bulb', 10.00, 2)
					,(8, 'Wooden Dowel', 1.89, 2)
					,(9, 'Oak Tabletop 8x4 ft', 899.98, 2)

					-- For Jobs that haven't ended yet, enter 9999-12-31
INSERT INTO TJobs ( intJobID, intCustomerID, intStatusID, dtmStartDate, dtmEndDate, strJobDesc)
VALUES				 (1, 1, 3, '2024-06-20', '2024-07-14', 'Installed new central air conditioning unit.')
					,(2, 1, 2, '2025-07-20', '9999-12-31', 'Inspected and cleaned central HVAC unit.')
					,(3, 2, 3, '2025-01-10', '2025-01-11', 'Replaced water pipe.')
					,(4, 3, 3, '2025-08-01', '2025-08-15', 'Building a new table.')
					,(5, 2, 2, '2025-08-06', '9999-12-31', 'Building new deck.')
					,(6, 3, 1, '2025-08-10', '9999-12-31', 'Install golden toilet.')
					,(7, 3, 3, '2024-09-19', '9999-12-31', 'Replace broken window')
					,(8, 3, 2, '2025-08-15', '9999-12-31', 'Inspected and cleaned central HVAC unit.')
					,(9, 3, 3, '2025-08-10', '2025-08-11', 'Installed new light fixture.')

INSERT INTO TJobMaterials ( intJobMaterialID, intJobID, intMaterialID, intQuantity)
VALUES				 (1, 1, 1, 2)
					,(2, 2, 2, 1)
					,(3, 3, 3, 1)
					,(4, 4, 4, 1)
					,(5, 4, 2, 1)
					,(6, 4, 1, 4)
					,(7, 5, 1, 100)
					,(8, 6, 5, 1)
					,(9, 7, 6, 1)
					,(10, 8, 3, 1)
					,(11, 9, 7, 4)

INSERT INTO TJobWorkers ( intJobWorkerID, intJobID, intWorkerID, intHoursWorked)
VALUES				 (1, 1, 1, 5)
					,(2, 2, 1, 1)
					,(3, 3, 2, 2)
					,(4, 4, 3, 8)
					,(5, 5, 1, 10)
					,(6, 6, 2, 0)
					,(7, 7, 1, 4)
					,(8, 8, 1, 2)
					,(9, 9, 1, 6)
					,(10, 8, 2, 2)

-- --------------------------------------------------------------------------------
-- Step #3.1 :  Create SQL to update the address for a specific customer. Include a select statement before and after the update. 
-- --------------------------------------------------------------------------------

SELECT
	strFirstName + ', ' + strLastName as CustomerName, strAddress
FROM
	TCustomers

UPDATE TCustomers
SET strAddress = '123 Batter Blvd'
WHERE strLastName = 'Dough'

SELECT
	strFirstName + ', ' + strLastName as CustomerName, strAddress
FROM
	TCustomers

-- --------------------------------------------------------------------------------
-- Step #3.2 :   Create SQL to increase the hourly rate by $2 for each worker that has been an employee for at least 1 year. 
				-- Include a select before and after the update. Make sure that you have data so that some rows are updated and others are not. 
-- --------------------------------------------------------------------------------

SELECT
	strFirstName + ', ' + strLastName as WorkerName, monHourlyRate, dtmHireDate
FROM
	TWorkers

UPDATE TWorkers
SET monHourlyRate += 2
WHERE dtmHireDate < '2024-08-15'

SELECT
	strFirstName + ', ' + strLastName as WorkerName, monHourlyRate, dtmHireDate
FROM
	TWorkers

-- --------------------------------------------------------------------------------
-- Step #3.3 :   Create SQL to delete a specific job that has associated work hours and materials assigned to it. Include a select before and after the statement(s).  
-- --------------------------------------------------------------------------------

SELECT
	TJ.strJobDesc, TJW.intHoursWorked, TJM.intQuantity, TM.strDescription
FROM
	TJobs AS TJ JOIN TJobWorkers AS TJW
	ON TJ.intJobID = TJW.intJobID

	JOIN TJobMaterials AS TJM
	ON TJ.intJobID = TJM.intJobID

	JOIN TMaterials AS TM
	ON TJM.intMaterialID = TM.intMaterialID

DELETE FROM TJobWorkers
FROM
	TJobs AS TJ JOIN TJobWorkers AS TJW
	ON TJ.intJobID = TJW.intJobID

	JOIN TJobMaterials AS TJM
	ON TJ.intJobID = TJM.intJobID

	JOIN TMaterials AS TM
	ON TJM.intMaterialID = TM.intMaterialID

WHERE 
	TM.strDescription = 'Galvanized Screws 100 pack'
	and TJW.intHoursWorked = 1

DELETE FROM TJobMaterials
FROM
	TJobs AS TJ JOIN TJobMaterials AS TJM
	ON TJ.intJobID = TJM.intJobID

	JOIN TMaterials AS TM
	ON TJM.intMaterialID = TM.intMaterialID

WHERE 
	TM.strDescription = 'Galvanized Screws 100 pack'
	and TJ.intJobID = 2

DELETE FROM TJobs
FROM
	TJobs AS TJ

WHERE 
	TJ.intJobID = 2


SELECT
	TJ.strJobDesc, TJW.intHoursWorked, TJM.intQuantity, TM.strDescription
FROM
	TJobs AS TJ JOIN TJobWorkers AS TJW
	ON TJ.intJobID = TJW.intJobID

	JOIN TJobMaterials AS TJM
	ON TJ.intJobID = TJM.intJobID

	JOIN TMaterials AS TM
	ON TJM.intMaterialID = TM.intMaterialID

SELECT
	*
FROM
	TJobs

-- --------------------------------------------------------------------------------
-- Step #4.1 :   Write a query to list all jobs that are in process. Include the Job ID and Description, Customer ID and name, and the start date. Order by the Job ID 
-- --------------------------------------------------------------------------------

SELECT
	TJ.intJobID, TJ.strJobDesc, TC.intCustomerID, TC.strFirstName + ', ' + TC.strLastName as CustomerName, TJ.dtmStartDate
FROM
	TJobs AS TJ JOIN TCustomers AS TC
	ON TC.intCustomerID = TJ.intCustomerID

	JOIN TStatuses AS TS
	ON TS.intStatusID = TJ.intStatusID

WHERE
	TS.strStatus = 'In Process'

ORDER BY 
	TJ.intJobID

-- --------------------------------------------------------------------------------
-- Step #4.2 :   Write a query to list all complete jobs for a specific customer and the materials used on each job. 
--					Include the quantity, unit cost, and total cost for each material on each job. Order by Job ID and material ID. 
--					Note: Select a customer that has at least 3 complete jobs and at least 1 open job and 1 in process job. 
--					At least one of the complete jobs should have multiple materials. If needed, go back to your inserts and add data. 
-- --------------------------------------------------------------------------------

SELECT
	 TC.strFirstName + ', ' + TC.strLastName as CustomerName
	,TJ.intJobID
	,TM.intMaterialID
	,TM.strDescription as MaterialUsed
	,TJM.intQuantity
	,TM.monCost as UnitCost
	,(TM.monCost * TJM.intQuantity) as TotalCost
FROM
	TJobs AS TJ JOIN TCustomers AS TC
	ON TC.intCustomerID = TJ.intCustomerID

	JOIN TStatuses AS TS
	ON TS.intStatusID = TJ.intStatusID

	JOIN TJobMaterials AS TJM
	ON TJ.intJobID = TJM.intJobID

	JOIN TMaterials AS TM
	ON TM.intMaterialID = TJM.intMaterialID

WHERE
	TS.strStatus = 'Complete'
	and TC.strLastName = 'Zimmer'

GROUP BY
	 TC.strFirstName + ', ' + TC.strLastName
	,TJ.intJobID
	,TM.intMaterialID
	,TM.strDescription
	,TJM.intQuantity
	,TM.monCost

ORDER BY 
	TJ.intJobID, TM.intMaterialID

-- --------------------------------------------------------------------------------
-- Step #4.3 :   This step should use the same customer as in step 4.2. 
--					Write a query to list the total cost for all materials for each completed job for the customer. 
--					Use the data returned in step 4.2 to validate your results.  
-- --------------------------------------------------------------------------------

SELECT
	 TC.strFirstName + ', ' + TC.strLastName as CustomerName
	,TJ.intJobID
	,SUM(TM.monCost * TJM.intQuantity) as TotalCost
FROM
	TJobs AS TJ JOIN TCustomers AS TC
	ON TC.intCustomerID = TJ.intCustomerID

	JOIN TStatuses AS TS
	ON TS.intStatusID = TJ.intStatusID

	JOIN TJobMaterials AS TJM
	ON TJ.intJobID = TJM.intJobID

	JOIN TMaterials AS TM
	ON TM.intMaterialID = TJM.intMaterialID

WHERE
	TS.strStatus = 'Complete'
	and TC.strLastName = 'Zimmer'

GROUP BY
	 TC.strFirstName + ', ' + TC.strLastName
	,TJ.intJobID

ORDER BY 
	TJ.intJobID

-- --------------------------------------------------------------------------------
-- Step #4.4 :   Write a query to list all jobs that have work entered for them. Include the job ID, job description, and job status description. 
--					List the total hours worked for each job with the lowest, highest, and average hourly rate. 
--					Make sure that your data includes at least one job that does not have hours logged. 
--					This job should not be included in the query. Order by highest to lowest average hourly rate.  
-- --------------------------------------------------------------------------------

SELECT
	  TJ.intJobID
	 ,TJ.strJobDesc
	 ,TS.strStatus
	 ,SUM(TJW.intHoursWorked) AS TotalJobHours
	 ,MAX(TW.monHourlyRate) AS HighestHourlyRate
	 ,MIN(TW.monHourlyRate) AS LowestHourlyRate
	 ,AVG(TW.monHourlyRate) AS AVGHourlyRate
FROM
	TJobs AS TJ JOIN TCustomers AS TC
	ON TC.intCustomerID = TJ.intCustomerID

	JOIN TStatuses AS TS
	ON TS.intStatusID = TJ.intStatusID

	JOIN TJobWorkers AS TJW
	ON TJ.intJobID = TJW.intJobID

	JOIN TWorkers AS TW
	ON TW.intWorkerID = TJW.intWorkerID

WHERE
	TJW.intHoursWorked NOT IN (
		SELECT intHoursWorked
		FROM TJobWorkers
		WHERE intHoursWorked = 0
	)

GROUP BY
	 TJ.intJobID
	,TJ.strJobDesc
	,TS.strStatus

ORDER BY 
	AVG(TW.monHourlyRate) DESC

-- --------------------------------------------------------------------------------
-- Step #4.5 :   Write a query that lists all materials that have not been used on any jobs. Include Material ID and Description. Order by Material ID.  
-- --------------------------------------------------------------------------------

SELECT
	  TM.intMaterialID, TM.strDescription
FROM
	TMaterials AS TM

WHERE
	TM.intMaterialID NOT IN (
		SELECT TM.intMaterialID
		FROM TMaterials AS TM
			JOIN TJobMaterials AS TJM
			ON TM.intMaterialID = TJM.intMaterialID
	)

ORDER BY 
	TM.intMaterialID

-- --------------------------------------------------------------------------------
-- Step #4.6 :   Create a query that lists all workers with a specific skill, their hire date, and the total number of jobs that they worked on. 
--					List the Skill ID and description with each row. Order by Worker ID.   
-- --------------------------------------------------------------------------------

SELECT
	   TW.intWorkerID
	  ,TW.strFirstName + ', ' + TW.strLastName AS WorkerName
	  ,TW.dtmHireDate
	  ,COUNT(TJW.intJobWorkerID) AS NumberOfJobs
	  ,TS.intSkillID
	  ,TS.strSkill
	  ,TS.strDescription
FROM
	TWorkers AS TW JOIN TWorkerSkills AS TWS
	ON TW.intWorkerID = TWS.intWorkerID

	JOIN TSkills AS TS
	ON TS.intSkillID = TWS.intSkillID

	JOIN TJobWorkers AS TJW
	ON TW.intWorkerID = TJW.intWorkerID

WHERE
	TS.strSkill = 'Plumber'

GROUP BY
	TW.intWorkerID
	,TW.strFirstName, TW.strLastName
	,TW.dtmHireDate
	,TS.intSkillID
	,TS.strSkill
	,TS.strDescription

ORDER BY 
	TW.intWorkerID

-- --------------------------------------------------------------------------------
-- Step #4.7 :   Create a query that lists all workers that worked greater than 20 hours for all jobs that they worked on. 
--					Include the Worker ID and name, number of hours worked, and number of jobs that they worked on. Order by Worker ID. 
-- --------------------------------------------------------------------------------

SELECT
	   TW.intWorkerID
	  ,TW.strFirstName + ', ' + TW.strLastName AS WorkerName
	  ,SUM(TJW.intHoursWorked) AS TotalHoursWorked
	  ,COUNT(TJW.intJobWorkerID) AS NumberOfJobs
FROM
	TWorkers AS TW JOIN TJobWorkers AS TJW
	ON TW.intWorkerID = TJW.intWorkerID

GROUP BY
	TW.intWorkerID
	,TW.strFirstName, TW.strLastName

HAVING
	SUM(TJW.intHoursWorked) > 20

ORDER BY 
	TW.intWorkerID

-- --------------------------------------------------------------------------------
-- Step #4.8 :   Create a query that includes the labor costs associated with each job. Include Customer ID and Name. 
-- --------------------------------------------------------------------------------

SELECT
	   TC.intCustomerID
	  ,TC.strFirstName + ', ' + TC.strLastName AS CustomerName
	  ,TJ.strJobDesc
	  ,SUM((TJW.intHoursWorked * TW.monHourlyRate)) AS LaborCosts
FROM
	TWorkers AS TW JOIN TJobWorkers AS TJW
	ON TW.intWorkerID = TJW.intWorkerID

	JOIN TJobs AS TJ
	ON TJ.intJobID = TJW.intJobID

	JOIN TCustomers AS TC
	ON TC.intCustomerID = TJ.intCustomerID

GROUP BY
	TC.intCustomerID
	,TC.strFirstName, TC.strLastName
	,TJ.strJobDesc

ORDER BY 
	TC.intCustomerID

-- --------------------------------------------------------------------------------
-- Step #4.9 :   Write a query that lists all customers who are located on 'Main Street'. 
--					Include the customer Id and full address. Order by Customer ID. 
--					Make sure that you have at least three customers on 'Main Street' each with different house numbers. 
--					Make sure that you also have customers that are not on 'Main Street'. 
-- --------------------------------------------------------------------------------

SELECT
	   TC.intCustomerID
	  ,TC.strFirstName + ', ' + TC.strLastName AS CustomerName
	  ,TC.strAddress
	  ,TC.strCity
	  ,TS.strState
	  ,TC.strZip
FROM
	TCustomers AS TC JOIN TState AS TS
	ON TS.intStateID = TC.intStateID

WHERE 
	TC.strAddress LIKE '%Main Street%'

ORDER BY 
	TC.intCustomerID

-- --------------------------------------------------------------------------------
-- Step #4.10 :   Write a query to list completed jobs that started and ended in the same month. List Job, Job Status, Start Date and End Date.
-- --------------------------------------------------------------------------------

SELECT
	TJ.intJobID, TJ.strJobDesc, TS.strStatus, TJ.dtmStartDate, TJ.dtmEndDate
FROM
	TJobs AS TJ JOIN TStatuses AS TS
	ON TS.intStatusID = TJ.intStatusID

WHERE 
	MONTH(TJ.dtmStartDate) = MONTH(TJ.dtmEndDate)

ORDER BY 
	TJ.intJobID

-- --------------------------------------------------------------------------------
-- Step #4.11 :   Create a query to list workers that worked on three or more jobs for the same customer. 
-- --------------------------------------------------------------------------------

SELECT
	 TC.strFirstName + ', ' + TC.strLastName AS CustomerName
	,COUNT(TJ.intJobID) AS NumberOfJobs
	,TW.strFirstName + ', ' + TW.strLastName AS WorkerName
FROM
	TJobs AS TJ JOIN TJobWorkers AS TJW
	ON TJ.intJobID = TJW.intJobID

	JOIN TWorkers AS TW
	ON TW.intWorkerID = TJW.intWorkerID

	JOIN TCustomers AS TC
	ON TC.intCustomerID = TJ.intCustomerID

GROUP BY
	TC.strFirstName, TC.strLastName
	,TW.strFirstName, TW.strLastName

Having
	COUNT(TJ.intJobID) >= 3

-- --------------------------------------------------------------------------------
-- Step #4.12 :   Create a query to list all workers and their total # of skills. 
--					Make sure that you have workers that have multiple skills and that you have at least 1 worker with no skills. 
--					The worker with no skills should be included with a total number of skills = 0. Order by Worker ID.  
-- --------------------------------------------------------------------------------

SELECT
	 TW.intWorkerID
	,TW.strFirstName + ', ' + TW.strLastName AS WorkerName
	,ISNULL(COUNT(TWS.intSkillID), 0) AS NumberOfSkills
FROM
	TWorkers AS TW 
	LEFT JOIN TWorkerSkills AS TWS
	ON TW.intWorkerID = TWS.intWorkerID

GROUP BY
	TW.intWorkerID
	,TW.strFirstName, TW.strLastName

ORDER BY
	TW.intWorkerID

-- --------------------------------------------------------------------------------
-- Step #4.13 :   Write a query to list the total Charge to the customer for each job. 
--					Calculate the total charge to the customer as the total cost of materials + total Labor costs + 30% Profit.  
-- --------------------------------------------------------------------------------

SELECT
	 TJ.intJobID
	,TJ.strJobDesc
	,TC.intCustomerID
	,TC.strFirstName + ', ' + TC.strLastName AS CustomerName
	,CAST(ROUND((SUM((TJM.intQuantity * TM.monCost) + (TJW.intHoursWorked * TW.monHourlyRate)) * 1.3), 2) as decimal(10,2)) AS TotalCharge
FROM
	TWorkers AS TW JOIN TJobWorkers AS TJW
	ON TW.intWorkerID = TJW.intWorkerID

	JOIN TJobs AS TJ
	ON TJ.intJobID = TJW.intJobID

	JOIN TCustomers AS TC
	ON TC.intCustomerID = TJ.intCustomerID

	JOIN TJobMaterials AS TJM
	ON TJ.intJobID = TJM.intJobID

	JOIN TMaterials AS TM
	ON TM.intMaterialID = TJM.intMaterialID

GROUP BY
	TJ.intJobID
	,TJ.strJobDesc
	,TC.intCustomerID
	,TC.strFirstName, TC.strLastName

ORDER BY
	TJ.intJobID
	,TC.intCustomerID

-- --------------------------------------------------------------------------------
-- Step #4.14 :   Write a query that totals what is owed to each vendor for a particular job.  
-- --------------------------------------------------------------------------------

SELECT
	 TV.strVendorName
	,TJ.intJobID
	,TJ.strJobDesc
	,SUM((TJM.intQuantity * TM.monCost)) AS AmountOwed
FROM
	TJobs AS TJ JOIN TJobMaterials AS TJM
	ON TJ.intJobID = TJM.intJobID

	JOIN TMaterials AS TM
	ON TM.intMaterialID = TJM.intMaterialID

	JOIN TVendors AS TV
	ON TV.intVendorID = TM.intVendorID

WHERE
	TJ.intJobID = 4

GROUP BY
	TV.strVendorName
	,TJ.intJobID
	,TJ.strJobDesc

ORDER BY
	TV.strVendorName
