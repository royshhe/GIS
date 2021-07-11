USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateStatus]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




/****** Object:  Stored Procedure dbo.UpdateStatus    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateStatus    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateStatus    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateStatus    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Vehicle table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 27 - Moved data conversion code out of the where clause */ 

CREATE PROCEDURE [dbo].[UpdateStatus]
@UnitNumber varchar(20),
@NewStatusCode char(1),
@NewStatusDate varchar(22),
@RemoveLicenceFlag char(1),
@UserName varchar(30)
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

	/* 5/26/99 - np modified - update condition status when vehicle status being changed to rental */

Declare @thisStatusString varchar(30)
Declare @currentStatusCode char(1)
Declare @currentStatusString varchar(30)
Declare @counter int
Declare @thisEffectiveDate datetime
Declare @sameStatus bit
Declare @nUnitNumber Integer

Select @nUnitNumber = Convert(int, NULLIF(@UnitNumber, ''))

Select @sameStatus = 0

Select @currentStatusCode = (   Select	Current_Vehicle_Status
				From	Vehicle
				Where	Unit_Number=@nUnitNumber)

Select @currentStatusString = (	Select	Value	
				From	Lookup_Table
				Where	Category='Vehicle Status'
				And 	Code=@currentStatusCode )

If @currentStatusCode = @NewStatusCode
	Select @sameStatus = 1
	
If @sameStatus = 1
	Begin
		Declare tempCursor1 Cursor FAST_FORWARD
		For
			Select	Effective_On
			From	Vehicle_History
			Where	Unit_Number=@nUnitNumber
				And Vehicle_Status<>@NewStatusCode
			Order By
				Effective_On Desc
		Open tempCursor1
		Fetch Next From tempCursor1 Into @thisEffectiveDate
		If @thisEffectiveDate > Convert(datetime,@NewStatusDate)
			Begin
				Close tempCursor1
				Deallocate tempCursor1
				Return -1
			End
		Close tempCursor1
		Deallocate tempCursor1
		
		Update	Vehicle_History
		Set	Effective_On=Convert(datetime,@NewStatusDate)
		Where
			Unit_Number=@nUnitNumber
			And Vehicle_Status=@NewStatusCode
			And Effective_On>@thisEffectiveDate
	End
Else
	Begin
		Declare tempCursor2 Cursor FAST_FORWARD
		For
			Select	Effective_On
			From	Vehicle_History
			Where	Unit_Number=@nUnitNumber
			Order By
				Effective_On Desc
		Open tempCursor2
		Fetch Next From tempCursor2 Into @thisEffectiveDate
		If @thisEffectiveDate > Convert(datetime,@NewStatusDate)
			Begin
				Close tempCursor2
				Deallocate tempCursor2
				Return -1
			End
		Close tempCursor2
		Deallocate tempCursor2
		Insert Into Vehicle_History
			(Unit_Number, Vehicle_Status, Effective_On)
		Values
			(Convert(int,@UnitNumber), @NewStatusCode, Convert(datetime,@NewStatusDate))
	End
Select @thisStatusString = (	Select	Value
				From	Lookup_Table
				Where	Category='Vehicle Status'
				And 	Code=@NewStatusCode)
Update
	Vehicle
Set
	Current_Vehicle_Status=@NewStatusCode,
	Vehicle_Status_Effective_On=Convert(datetime,@NewStatusDate),
	Last_Update_By=@UserName,
	Last_Update_On=getDate()
Where
	Unit_Number=@nUnitNumber

If @RemoveLicenceFlag = '1'
	Begin
		Update
			Vehicle
		Set
			Current_Licence_Plate='',
			Licence_Plate_Attached_On=(null),
			Current_Licencing_Prov_State=''
		Where
			Unit_Number=@nUnitNumber
		
		Update
			Vehicle_Licence_History
		Set
			Removed_On = Convert(datetime,@NewStatusDate),
			Changed_By = 'r-' + @UserName
		Where
			Unit_Number=@nUnitNumber
			And (Removed_On = '' Or Removed_On IS NULL)
	End
If @currentStatusString = 'Rental' And @sameStatus <> 1
	Begin
		Update
			Vehicle
		Set
			Current_Rental_Status='a',
			Rental_Status_Effective_On=Convert(datetime,@NewStatusDate)
		Where
			Unit_Number=@nUnitNumber
	End
If @thisStatusString = 'Rental'
	Begin
		Update
			Vehicle
		Set
			Current_Rental_Status='a',
			Rental_Status_Effective_On=Convert(datetime,@NewStatusDate),
			Current_Condition_Status='a',
			Condition_Status_Effective_On=Convert(datetime,@NewStatusDate)
		Where
			Unit_Number=@nUnitNumber


		Insert Into
			Condition_History
			(Unit_Number,
			Condition_Status,
			Effective_On)
		Values
			(Convert(int,@UnitNumber),
			'a',
			Convert(datetime, @NewStatusDate))

	End
	-- remove from batch file
	delete Vehicle_Status_Input where unit_number=@nUnitNumber

Return 1
GO
