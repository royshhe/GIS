USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[DeleteVehicleRate]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



/****** Object:  Stored Procedure dbo.DeleteVehicleRate    Script Date: 2/18/99 12:12:07 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleRate    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleRate    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.DeleteVehicleRate    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To logical delete record(s) from Vehicle_Rate and its associated tables by setting the Termination Date and delete record(s) from Location_Vehicle_Rate_Level table
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[DeleteVehicleRate]
@RateID varchar(7)
AS
Declare @thisDate datetime
Select @thisDate = getDate()

Update
	Vehicle_Rate
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Restriction
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Included_Optional_Extra
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Included_Sales_Accessory
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Availability
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Time_Period
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Level
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Vehicle_Class
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Charge_Amount
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Location_Set
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Location_Set_Member
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Rate_Drop_Off_Location
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Update
	Organization_Rate
Set
	Termination_Date=@thisDate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'

Delete From
	Location_Vehicle_Rate_Level
Where
	Rate_ID=Convert(int,@RateID)
Return 1













GO
