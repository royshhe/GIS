USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_7_Vehicle_Check_In_Override]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PROCEDURE NAME: RP_SP_Con_7_Vehicle_Check_In_Override
PURPOSE: Select all information needed for Vehicle Check In Override Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/09/16
USED BY:  Vehicle Check In Override Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/09/27	if override contract number = overriden contract number
				then print "Movement", else print override contract number
Joseph Tseung	1999/10/12	Remove Override_Drop_Off_Location_ID field.
				Add Overridden_Drop_Off_Location_ID and Overridden_Drop_Off_Location_Name
				fields. Used for the parameter for the report.
Joseph Tseung	2000/02/17	Show foreign unit number for foreign vehicles
Joseph Tseung	2000/02/24	Allow overridden drop off location to both BRAC and foreign locations
Peter Ni		2011/04/20	If override contract is cancel then don't show up
*/
CREATE PROCEDURE [dbo].[RP_SP_Con_7_Vehicle_Check_In_Override] --'*'
(
	@paramLocID varchar(20) = '*'
)
AS

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramLocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocID
	END 
-- end of fixing the problem

SELECT 	
	RP__Last_Vehicle_On_Contract.Expected_Drop_Off_Location_ID AS Overridden_Drop_Off_Location_ID,
	Loc2.Location AS Overridden_Drop_Off_Location_Name,
	Override_Check_In.Check_In AS Override_Date,
    	Override_Check_In.Overridden_Contract_Number,
   	New_Contract_Number =
	CASE
		WHEN Override_Check_In.Override_Contract_Number = Override_Check_In.Overridden_Contract_Number
		THEN 'Movement'
		ELSE  CONVERT(varchar(10), Override_Check_In.Override_Contract_Number)
	END,
	Unit_Number = CASE WHEN Vehicle.Foreign_Vehicle_Unit_Number IS NULL
			THEN CONVERT(varchar, RP__Last_Vehicle_On_Contract.Unit_Number)
			ELSE Vehicle.Foreign_Vehicle_Unit_Number
		      END,
   	Loc1.Location AS Override_Drop_Off_Location_Name,
    	Override_Check_In.Checked_in_By	AS CSR_Name
FROM 	RP__Last_Vehicle_On_Contract with(nolock)
	INNER 
	JOIN
   	Override_Check_In
		ON RP__Last_Vehicle_On_Contract.Unit_Number = Override_Check_In.Unit_Number
    		AND
   		RP__Last_Vehicle_On_Contract.Contract_Number = Override_Check_In.Overridden_Contract_Number
    		AND
   		RP__Last_Vehicle_On_Contract.Checked_Out = Override_Check_In.Checked_Out
	INNER
	JOIN
	Vehicle
		ON RP__Last_Vehicle_On_Contract.Unit_Number = Vehicle.Unit_Number
    	INNER 
	JOIN
   	Location AS Loc1
		ON Override_Check_In.Drop_Off_Location_ID = Loc1.Location_ID   		
	INNER 
	JOIN
	Location AS Loc2
		ON RP__Last_Vehicle_On_Contract.Expected_Drop_Off_Location_ID = Loc2.Location_ID   
		AND Loc2.Rental_Location = 1
	inner join contract c on c.contract_number=Override_Check_In.Overridden_Contract_Number
		
WHERE 	
	(RP__Last_Vehicle_On_Contract.Actual_Check_In IS NULL)
	AND
	(@paramLocID = "*" or CONVERT(INT, @tmpLocID) = RP__Last_Vehicle_On_Contract.Expected_Drop_Off_Location_ID)
	and c.status<>"CA"
GO
