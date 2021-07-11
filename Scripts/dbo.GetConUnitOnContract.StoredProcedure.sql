USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConUnitOnContract]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: 	To retrieve a list of vehicle on contract for the given unit number.
MOD HISTORY:
Name    Date        	Comments
NP	May 01 2000	Return additional column, VEH.Foreign_Vehicle_Unit_Number
*/
CREATE PROCEDURE [dbo].[GetConUnitOnContract]
	@UnitNum Varchar(10)
AS
	/* 10/22/99 - do nullif outside of SQL statements */

DECLARE	@iUnitNum Int
	SELECT @iUnitNum = Convert(Int, NULLIF(@UnitNum,''))

	SET ROWCOUNT 1
	SELECT	
		VOC.Unit_Number, 
		Contract_Number, 
		Checked_Out,
		Convert(Varchar(11), Expected_Check_In, 13),
		Convert(Varchar(5), Expected_Check_In, 14),
		Expected_Drop_Off_Location_ID,
		VEH.Foreign_Vehicle_Unit_Number
	FROM	
		Vehicle_On_Contract VOC,
		Vehicle VEH
	WHERE	
		VOC.Unit_Number = @iUnitNum
	AND	VOC.Unit_Number = VEH.Unit_Number
	ORDER BY
		 Checked_Out DESC
	RETURN @@ROWCOUNT

GO
