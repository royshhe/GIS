USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehInfoByUnitNumber]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To search for and retrieve all units that match on GIS unit # or foreign unit #
MOD HISTORY:
Name	Date        	Comments
*/
CREATE PROCEDURE [dbo].[GetVehInfoByUnitNumber]
@UnitNumber varchar(10)
AS
If IsNumeric(@UnitNumber) = 1
  Select
	V.Unit_Number,
	V.Foreign_Vehicle_Unit_Number,
	VMY.Model_Name,
	V.Current_Licence_Plate
  From
	Vehicle V, Vehicle_Model_Year VMY
  Where
	(V.Unit_Number=Convert(int,@UnitNumber) And
	(V.Foreign_Vehicle_Unit_Number='' Or V.Foreign_Vehicle_Unit_Number IS NULL)
	Or V.Foreign_Vehicle_Unit_Number=@UnitNumber)
	And V.Vehicle_Model_ID=VMY.Vehicle_Model_ID
	And V.Deleted = 0
Else
  Select
	V.Unit_Number,
	V.Foreign_Vehicle_Unit_Number,
	VMY.Model_Name,
	V.Current_Licence_Plate
  From
	Vehicle V, Vehicle_Model_Year VMY
  Where
	V.Foreign_Vehicle_Unit_Number=@UnitNumber
	And V.Vehicle_Model_ID=VMY.Vehicle_Model_ID
	And V.Deleted = 0
	
RETURN 1















GO
