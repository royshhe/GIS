USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateRateVehicleClass]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateRateVehicleClass    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreateRateVehicleClass    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateRateVehicleClass    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateRateVehicleClass    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Rate_Vehicle_Class table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateRateVehicleClass] --'5','O','$0.25','Peter'
@RateID varchar(7),
@VehicleClass varchar(25),
@KmCharge varchar(25),
@ChangedBy varchar(20)
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

Declare @ThisDate datetime
Declare @ThisLevel char(1)
Declare @ThisTimePeriodID int
Declare @ThisTimePeriodType varchar(25)
Declare @ThisVehicleClassID int
Declare @ThisVehicleClassCode char(1)
If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'
Select @ThisDate = getDate()
Select @ThisVehicleClassCode =
		(Select Distinct
			Vehicle_Class_Code
		From
			Vehicle_Class
		Where
			Vehicle_Class_Name = @VehicleClass)
Insert Into Rate_Vehicle_Class
	(Effective_Date,Termination_Date,Rate_ID,Vehicle_Class_Code,Per_Km_Charge)
Values
	(@ThisDate,'Dec 31 2078 11:59PM',
	Convert(int,@RateID),@ThisVehicleClassCode,
	Convert(decimal(7,2),replace(@KmCharge,'$','')))
Select @ThisVehicleClassID = @@IDENTITY
Declare LevelCursor Cursor FAST_FORWARD
For
	(Select Distinct
		Rate_Level
	From
		Rate_Level
	Where
		Rate_ID = Convert(int,@RateID)
		And Termination_Date = 'Dec 31 2078 11:59PM')
Open LevelCursor
Fetch Next From LevelCursor Into @ThisLevel
While (@@Fetch_Status = 0)
	Begin
		Declare TimePeriodCursor Cursor FAST_FORWARD
		For
			(Select Distinct
				Rate_Time_Period_ID
			From
				Rate_Time_Period
			Where
				Rate_ID = Convert(int,@RateID)
				And Termination_Date = 'Dec 31 2078 11:59PM')
		Open TimePeriodCursor
		Fetch Next From TimePeriodCursor Into @ThisTimePeriodID
		While (@@Fetch_Status = 0)
			Begin
				Select @ThisTimePeriodType =
						(Select Distinct
							Type
						From
							Rate_Time_Period
						Where
							Rate_Time_Period_ID = @ThisTimePeriodID)
				Insert Into Rate_Charge_Amount
					(Effective_Date,Termination_Date,Rate_ID,
					Rate_Vehicle_Class_ID,Rate_Time_Period_ID,
					Rate_Level,Type,Amount)
				Values
					(@ThisDate,'Dec 31 2078 11:59PM',
					Convert(int,@RateID),@ThisVehicleClassID,
					@ThisTimePeriodID,@ThisLevel,
					@ThisTimePeriodType,99999.99)

				Fetch Next From TimePeriodCursor Into @ThisTimePeriodID
			End
		Close TimePeriodCursor
		Deallocate TimePeriodCursor

		Fetch Next From LevelCursor Into @ThisLevel
	End

Close LevelCursor
Deallocate LevelCursor

Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@ThisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Return @ThisVehicleClassID
GO
