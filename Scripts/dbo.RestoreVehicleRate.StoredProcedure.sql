USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RestoreVehicleRate]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		12 Dec 2002
--	Details		To restore record(s) from Vehicle Rate
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[RestoreVehicleRate]
@RateID varchar(7)
AS
--Declare @thisDate datetime
--Select @thisDate = getDate()
Declare @paramRateID int
Select @paramRateID = Convert(int,@RateID)

Update
	Vehicle_Rate
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from vehicle_rate vr
				where vr.rate_id = @paramRateID)

Update
	Rate_Restriction
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Restriction vr
				where vr.rate_id = @paramRateID)

Update
	Included_Optional_Extra
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Included_Optional_Extra vr
				where vr.rate_id = @paramRateID)

Update
	Included_Sales_Accessory
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Included_Sales_Accessory vr
				where vr.rate_id = @paramRateID)

Update
	Rate_Availability
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Availability vr
				where vr.rate_id = @paramRateID)
Update
	Rate_Time_Period
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Time_Period vr
				where vr.rate_id = @paramRateID)

Update
	Rate_Level
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Level vr
				where vr.rate_id = @paramRateID)

Update
	Rate_Vehicle_Class
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Vehicle_Class vr
				where vr.rate_id = @paramRateID)

Update
	Rate_Charge_Amount
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Charge_Amount vr
				where vr.rate_id = @paramRateID)

Update
	Rate_Location_Set
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Location_Set vr
				where vr.rate_id = @paramRateID)

Update
	Rate_Location_Set_Member
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Location_Set_Member vr
				where vr.rate_id = @paramRateID)

Update
	Rate_Drop_Off_Location
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Rate_Drop_Off_Location vr
				where vr.rate_id = @paramRateID)

Update
	Organization_Rate
Set
	Termination_Date='Dec 31 2078 11:59PM'
Where
	Rate_ID=@paramRateID
	And Termination_Date = 
				(select max(Termination_Date)
				from Organization_Rate vr
				where vr.rate_id = @paramRateID)
				

Return 1
GO
