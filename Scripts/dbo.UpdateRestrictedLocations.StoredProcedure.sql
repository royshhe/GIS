USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRestrictedLocations]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




/****** Object:  Stored Procedure dbo.UpdateRestrictedLocations    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRestrictedLocations    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRestrictedLocations    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRestrictedLocations    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To create a record in Vehicle_Location_Restriction table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateRestrictedLocations]
@UnitNumber varchar(10),@LocationID varchar(10)
AS
Declare @ret int
Declare @nUnitNumber Integer
Declare @nLocationID Integer

Select @nUnitNumber = Convert(int, NULLIF(@UnitNumber, ''))
Select @nLocationID = Convert(int, NULLIF(@LocationID, ''))

Select @ret =	(Select
			Count(*)
		From
			Vehicle_Location_Restriction
		Where
			Unit_Number=@nUnitNumber
			And Location_ID=@nLocationID)
If @ret > 0
	Return 1

Insert Into Vehicle_Location_Restriction
	(Unit_Number, Location_ID)
Values
	(@nUnitNumber, @nLocationID)
	
Return 1














GO
