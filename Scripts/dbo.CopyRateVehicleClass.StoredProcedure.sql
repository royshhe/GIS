USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CopyRateVehicleClass]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CopyRateVehicleClass    Script Date: 2/18/99 12:11:59 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateVehicleClass    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateVehicleClass    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CopyRateVehicleClass    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To copy Rate_Vehicle_Class info from the current rate into the new rate.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CopyRateVehicleClass]
@OldRateID int,
@NewRateID int
AS
	/* 5/11/99 - cpy modified - specified cursor as Fast_foward; close cursor */

Declare @thisDate datetime
Declare @RateVehicleClassID int
Declare @RateVehicleClassCode char(1)
Declare @PerKmCharge decimal(7,2)
Select @thisDate = getDate()
Declare thisCursor Cursor FAST_FORWARD
For
	(Select
		Rate_Vehicle_Class_ID,Vehicle_Class_Code,Per_Km_Charge
	From
		Rate_Vehicle_Class
	Where
		Rate_ID=Convert(int,@OldRateID)
		And Termination_Date='Dec 31 2078 23:59')
Open thisCursor
Fetch Next From thisCursor Into @RateVehicleClassID,
				@RateVehicleClassCode,
				@PerKmCharge
While (@@Fetch_Status = 0)
	Begin
		Set Identity_Insert Rate_Vehicle_Class On
		Insert Into Rate_Vehicle_Class
			(Rate_ID,Effective_Date,Termination_Date,
			Rate_Vehicle_Class_ID,Vehicle_Class_Code,
			Per_Km_Charge)
		Values
			(@NewRateID,@thisDate,'Dec 31 2078 23:59',
			@RateVehicleClassID,@RateVehicleClassCode,
			@PerKmCharge)
		Set Identity_Insert Rate_Vehicle_Class Off
		Fetch Next From thisCursor Into @RateVehicleClassID,
						@RateVehicleClassCode,
						@PerKmCharge
	End

Close thisCursor
Deallocate thisCursor

Return 1














GO
