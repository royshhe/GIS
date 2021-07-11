USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeletePlate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/****** Object:  Stored Procedure dbo.DeletePlate    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.DeletePlate    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeletePlate    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeletePlate    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record(s) from Vehicle_Licence and Vehicle_Licence_History  table by setting the delete flag 
MOD HISTORY:
Name    Date        	Comments
NP 	05/27/99 	- np modified - When a licence plate is deleted, vehicle's current licence information should be removed and vehicle licence history removed_on date should be set to deleted date 
CPY	6/01/99 	- cpy bug fix - only set removed_on date to the date (ie. set time as 12:00am) 
CPY	10/21/99 	- when updating vehicle_licence_history, save date AND time (down to the sec) 
CPY	Jan 21 2000	- update the vehicle last_updated_by and last_updated_on
*/

CREATE PROCEDURE [dbo].[DeletePlate]
	@PlateNumber varchar(20),
	@UserName varchar(30)
AS

Declare @UnitNumber Int
Declare @AttachedOn DateTime
Declare @CurrDatetime Datetime

SELECT	@CurrDatetime = GetDate()

/* Get the last Attached On date */
Select	
	@UnitNumber = Unit_Number,
	@AttachedOn = Attached_On
From	
	Vehicle_Licence_History
Where	
	Licence_Plate_Number = @PlateNumber
And	Attached_On =	(	Select	Max(Attached_On)
				From	Vehicle_Licence_History
				Where	Licence_Plate_Number = @PlateNumber
			)

/* Remove vehicle's current licence information */
Update
	Vehicle
Set	
	Current_Licence_Plate = '',
	Current_Licencing_Prov_State = '',
	Licence_Plate_Attached_On = (NULL), 
	Last_Update_By = @UserName, 
	Last_Update_On = @CurrDatetime
Where	
	Unit_Number = @UnitNumber

/* Set vehicle licence history removed on date to deleted date */
Update
	Vehicle_Licence_History
Set
	Removed_On = cast(convert(varchar(16), @CurrDatetime, 20) as datetime), -- trunc secs and millsecs
	Changed_By =  'd-' + @UserName
Where
	Unit_Number = @UnitNumber
And	Licence_Plate_Number = @PlateNumber
And	Attached_On = @AttachedOn

/* Set vehicle licence delete flag to true  */
Update	
	Vehicle_Licence
Set
	Delete_Flag = 1,
	Last_Change_By = @UserName,
	Last_Change_On = @CurrDatetime
Where
	Licence_Plate_Number = @PlateNumber
Return 1
GO
