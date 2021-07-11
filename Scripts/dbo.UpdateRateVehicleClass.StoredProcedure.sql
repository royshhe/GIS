USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateRateVehicleClass]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateRateVehicleClass    Script Date: 2/18/99 12:12:05 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRateVehicleClass    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRateVehicleClass    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateRateVehicleClass    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Rate_Vehicle_Class table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateRateVehicleClass]
@RateID varchar(7),
@RateVehicleClassID varchar(25),
@VehicleClass varchar(25),
@KmCharge varchar(25),
@ChangedBy varchar(20)
AS
Declare	@thisDate datetime
Declare	@thisVehicleClassCode char(1)

Declare 	@nRateID Integer
Declare	@nRateVehicleClassID Integer

Select		@nRateID = Convert(int, NULLIF(@RateID, ''))
Select		@nRateVehicleClassID = Convert(int, NULLIF(@RateVehicleClassID, ''))

If @ChangedBy = ''
	Select @ChangedBy = 'No name provided'

Select @thisDate = (getDate())

Select @ThisVehicleClassCode =
		(Select Distinct
			Vehicle_Class_Code
		From
			Vehicle_Class
		Where
			Vehicle_Class_Name = @VehicleClass)

--Set the current Rate Vehicle Class to expired
Update
	Rate_Vehicle_Class
Set
	Termination_Date=@thisDate
Where
	Rate_ID=@nRateID
And 	Rate_Vehicle_Class_ID=@nRateVehicleClassID
And 	Termination_Date='Dec 31 2078 11:59PM'

Set Identity_Insert Rate_Vehicle_Class On

--Create a new record for Rate Vehicle Class, the current one has been expired
Insert Into Rate_Vehicle_Class
	(Effective_Date,Termination_Date,Rate_ID,Rate_Vehicle_Class_ID,Vehicle_Class_Code,
	Per_Km_Charge)
Values
	(DateAdd(second,1,@thisDate),'Dec 31 2078 11:59PM',
	@nRateID, @nRateVehicleClassID, @thisVehicleClassCode,
	Convert(decimal(7,2),@KmCharge))

Set Identity_Insert Rate_Vehicle_Class Off

--Update the audit info
Update
	Vehicle_Rate
Set
	Last_Changed_By=@ChangedBy,
	Last_Changed_On=@thisDate
Where
	Rate_ID=@nRateID
And 	Termination_Date='Dec 31 2078 11:59PM'

Return @nRateVehicleClassID





GO
