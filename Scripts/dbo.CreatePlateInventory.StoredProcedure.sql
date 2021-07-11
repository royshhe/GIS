USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreatePlateInventory]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreatePlateInventory    Script Date: 2/18/99 12:12:13 PM ******/
/****** Object:  Stored Procedure dbo.CreatePlateInventory    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreatePlateInventory    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreatePlateInventory    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Licence_History table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreatePlateInventory]
@PlateNumber varchar(20),
@Province varchar(20),
@UnitNumber varchar(20),
@DateAttached varchar(20),
@Comments varchar(255),
@UserName varchar(30)
AS

	/* 6/02/99 - cpy modified - apply nullif to comment field */

Declare @thisStatus char(1)
Insert into Vehicle_Licence_History
	(Licence_Plate_Number, Licencing_Province_State, Unit_Number,
	Attached_On, Removed_On, Comment)
Values
	(@PlateNumber, @Province, Convert(int,@UnitNumber),
	Convert(datetime,@DateAttached), (null),
	NULLIF(@Comments,''))

-- Update vehicle's licence plate info.
Update
	Vehicle
Set
	Current_Licence_Plate = @PlateNumber,
	Licence_Plate_Attached_On = Convert(datetime, @DateAttached),
	Current_Licencing_prov_State = @Province
Where
	Unit_Number=Convert(int,@UnitNumber)
Select @thisStatus = 	(Select
				Current_Vehicle_Status
			From
				Vehicle
			Where
				Unit_Number=Convert(int,@UnitNumber))
/* If vehicle status is 'Drop Ship' change to 'Owned' */
If @thisStatus = 'a'
	Begin
		Update
			Vehicle
		Set
			Current_Vehicle_Status = 'b',
			Ownership_Date = Convert(datetime, @DateAttached),
			Vehicle_Status_Effective_On = Convert(datetime, @DateAttached)
		Where
			Unit_Number=Convert(int,@UnitNumber)

		Insert Into Vehicle_History
			(Unit_Number, Vehicle_Status, Effective_On)
		Values
			(Convert(int,@UnitNumber), 'b',
			Convert(datetime, @DateAttached))
	End

-- update vehicle audit info
Update
	Vehicle_Licence
Set
	Last_Change_By=@UserName,
	Last_Change_On=getDate()
Where
	Licence_Plate_Number=@PlateNumber
	And Licencing_Province_State=@Province
	
Return 1














GO
