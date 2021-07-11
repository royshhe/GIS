USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_3_Daily_Contract_Tran_Stat]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*
PROCEDURE NAME: RP_SP_Con_3_Daily_Contract_Tran_Stat
PURPOSE: Select all the information needed (7 days following start business date)
	      for Daily Contract Transaction Statistic Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/01/01
USED BY: Daily Contract Transaction Statistic Report
MOD HISTORY:
Name 		Date		Comments
Joseph T	1999/09/17	Add filtering to improve performance
*/

CREATE PROCEDURE [dbo].[RP_SP_Con_3_Daily_Contract_Tran_Stat] --'28 may 2012','*','*'
(
	@startDate varchar(20) = '08 Feb 1999',
	@paramVehicleTypeID varchar(20) = '*',
	@paramLocationID varchar(20) = '*'
)
AS
-- convert strings to datetime
DECLARE @@startDate datetime
DECLARE @@COUNTER NUMERIC

SELECT @@startDate = CONVERT(datetime,  '00:00:00 ' + @startDate)

-- fix upgrading problem (SQL7->SQL2000)

DECLARE  @tmpLocID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 

-- end of fixing the problem

-- create local TranDates temporary table
CREATE TABLE #TranDates (Transaction_Date Datetime PRIMARY KEY)

SELECT @@COUNTER = 0

-- insert 7 dates starting from the startDate parameter in the temporary table
WHILE (@@COUNTER < 7)

BEGIN
	INSERT INTO #TranDates VALUES ( DATEADD(day, @@COUNTER, @@startDate))
	SELECT @@COUNTER = @@COUNTER +1
END

--SELECT * FROM #TranDates

SELECT 	RP_Con_3_Tran_Type.Transaction_Type,
	Vehicle_Type.Vehicle_Type_ID,
	Location.Location_ID,
	Location.Location AS Location_Name,
	#TranDates.Transaction_Date,
	RP_Con_3_Tran_Hour.Transaction_Hour AS Transaction_Hour,
	ISNULL(v1.Cnt, 0) AS Cnt
    	    		
FROM 	#TranDates with(nolock)
	CROSS JOIN
	Vehicle_Type
	CROSS JOIN
    	RP_Con_3_Tran_Hour
	CROSS JOIN
    	RP_Con_3_Tran_Type
	CROSS JOIN
    	Location
	INNER JOIN
    	Lookup_Table
		ON Location.Owning_Company_ID = Lookup_Table.Code
		AND Lookup_Table.Category = 'BudgetBC Company'
		AND Location.Rental_Location = 1 -- rental locations

	LEFT
	JOIN
	RP_Con_3_Daily_Contract_Tran_Stat_L2_Main v1

		ON v1.Transaction_Type = RP_Con_3_Tran_Type.Transaction_Type
		AND v1.Location_ID = Location.Location_ID	
		AND v1.Vehicle_Type_ID = Vehicle_Type.Vehicle_Type_ID
		AND DATEDIFF(day, v1.Transaction_Date, #TranDates.Transaction_Date) = 0
		AND v1.Transaction_Hour = RP_Con_3_Tran_Hour.Transaction_Hour

WHERE	(@paramVehicleTypeID = '*' OR Vehicle_Type.Vehicle_Type_ID = @paramVehicleTypeID)
	AND
 	(@paramLocationID = '*'or CONVERT(INT, @tmpLocID) = Location.Location_ID)


RETURN @@ROWCOUNT


GO
